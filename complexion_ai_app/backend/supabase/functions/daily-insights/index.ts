import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
  const { user_id, checkin_id } = await req.json();

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // Get recent check-ins and latest analysis
  const [checkinsRes, analysisRes, routineRes] = await Promise.all([
    supabase
      .from("daily_checkins")
      .select()
      .eq("user_id", user_id)
      .order("checkin_date", { ascending: false })
      .limit(7),
    supabase
      .from("skin_analyses")
      .select()
      .eq("user_id", user_id)
      .order("analysed_at", { ascending: false })
      .limit(1)
      .single(),
    supabase
      .from("routines")
      .select("*, routine_steps(*)")
      .eq("user_id", user_id)
      .eq("is_active", true),
  ]);

  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-5-20250514",
      max_tokens: 256,
      system:
        "You are ComplexionAI. Generate a short (1-2 sentence) personalised daily skincare tip based on the user's recent check-ins, analysis, and routine. Be warm and encouraging. Use Australian English.",
      messages: [
        {
          role: "user",
          content: `Recent check-ins: ${JSON.stringify(checkinsRes.data)}
Latest analysis: ${JSON.stringify(analysisRes.data)}
Current routine: ${JSON.stringify(routineRes.data)}

Generate one short daily tip.`,
        },
      ],
    }),
  });

  const aiResult = await response.json();
  const tip = aiResult.content[0].text;

  // Save tip to the check-in
  if (checkin_id) {
    await supabase
      .from("daily_checkins")
      .update({ ai_daily_tip: tip })
      .eq("id", checkin_id);
  }

  return new Response(JSON.stringify({ tip }), {
    headers: { "Content-Type": "application/json" },
  });
});
