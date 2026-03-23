import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
  const { user_id, analysis_id } = await req.json();

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // Fetch user profile, analysis, and product catalogue
  const [profileRes, analysisRes, productsRes] = await Promise.all([
    supabase.from("skin_profiles").select().eq("user_id", user_id).single(),
    supabase.from("skin_analyses").select().eq("id", analysis_id).single(),
    supabase.from("products").select().eq("is_active", true),
  ]);

  const profile = profileRes.data;
  const analysis = analysisRes.data;
  const products = productsRes.data;

  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-5-20250514",
      max_tokens: 2048,
      system: `You are building a skincare routine for a user. Follow dermatological best practices:
- Correct layering order (thinnest to thickest)
- No conflicting ingredients (e.g., retinol + AHA in same routine)
- Sunscreen always last step AM
- Actives introduced gradually
- Product recommendations from the provided catalogue only
Use Australian English.`,
      messages: [
        {
          role: "user",
          content: `Analysis scores: ${JSON.stringify(analysis)}
Profile: ${JSON.stringify(profile)}
Available products: ${JSON.stringify(products?.map((p: any) => ({ id: p.id, name: p.name, brand: p.brand, category: p.category, key_ingredients: p.key_ingredients, suitable_skin_types: p.suitable_skin_types })))}

Generate a morning and evening routine. Return ONLY valid JSON:
{
  "morning": {
    "name": "Morning Routine",
    "reasoning": "string explaining why",
    "steps": [
      {
        "step_order": 1,
        "step_type": "cleanser|toner|serum|moisturiser|sunscreen|treatment",
        "title": "Step name",
        "description": "Brief instruction",
        "duration_seconds": 60,
        "recommended_product_id": "uuid or null",
        "is_optional": false,
        "ai_notes": "Why this step matters"
      }
    ]
  },
  "evening": {
    "name": "Evening Routine",
    "reasoning": "string",
    "steps": [...]
  }
}`,
        },
      ],
    }),
  });

  const aiResult = await response.json();
  const routineData = JSON.parse(aiResult.content[0].text);

  // Save morning routine
  const { data: morningRoutine } = await supabase
    .from("routines")
    .insert({
      user_id,
      name: routineData.morning.name,
      routine_type: "morning",
      generated_by: "ai",
      based_on_analysis_id: analysis_id,
      ai_reasoning: routineData.morning.reasoning,
    })
    .select()
    .single();

  if (morningRoutine) {
    const steps = routineData.morning.steps.map((s: any) => ({
      ...s,
      routine_id: morningRoutine.id,
    }));
    await supabase.from("routine_steps").insert(steps);
  }

  // Save evening routine
  const { data: eveningRoutine } = await supabase
    .from("routines")
    .insert({
      user_id,
      name: routineData.evening.name,
      routine_type: "evening",
      generated_by: "ai",
      based_on_analysis_id: analysis_id,
      ai_reasoning: routineData.evening.reasoning,
    })
    .select()
    .single();

  if (eveningRoutine) {
    const steps = routineData.evening.steps.map((s: any) => ({
      ...s,
      routine_id: eveningRoutine.id,
    }));
    await supabase.from("routine_steps").insert(steps);
  }

  // Return full routine with steps
  const { data: fullRoutines } = await supabase
    .from("routines")
    .select("*, routine_steps(*, product:products(*))")
    .eq("user_id", user_id)
    .eq("is_active", true)
    .order("created_at", { ascending: false });

  return new Response(JSON.stringify(fullRoutines), {
    headers: { "Content-Type": "application/json" },
  });
});
