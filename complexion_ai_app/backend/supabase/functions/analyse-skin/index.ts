import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
  const { image_path, user_id } = await req.json();

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // Get user's skin profile for context
  const { data: profile } = await supabase
    .from("skin_profiles")
    .select()
    .eq("user_id", user_id)
    .single();

  // Download image from storage
  const { data: imageData } = await supabase.storage
    .from("skin-images")
    .download(image_path);

  if (!imageData) {
    return new Response(JSON.stringify({ error: "Image not found" }), {
      status: 400,
    });
  }

  // Convert to base64 for vision API
  const base64Image = btoa(
    new Uint8Array(await imageData.arrayBuffer()).reduce(
      (data, byte) => data + String.fromCharCode(byte),
      ""
    )
  );

  // Call Claude for skin analysis
  const analysisResponse = await fetch(
    "https://api.anthropic.com/v1/messages",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: "claude-sonnet-4-5-20250514",
        max_tokens: 1024,
        messages: [
          {
            role: "user",
            content: [
              {
                type: "image",
                source: {
                  type: "base64",
                  media_type: "image/jpeg",
                  data: base64Image,
                },
              },
              {
                type: "text",
                text: `Analyse this facial skin image. Provide scores from 0-100 (100 = healthiest) for:
- acne_score: Acne severity (100 = clear skin)
- texture_score: Skin texture smoothness
- pigmentation_score: Pigmentation evenness
- hydration_score: Apparent hydration level
- wrinkle_score: Wrinkle/fine line presence (100 = no wrinkles)
- pore_score: Pore visibility (100 = minimal pores)
- redness_score: Redness/inflammation (100 = no redness)
- dark_circles_score: Dark circles under eyes (100 = none)

User profile context: skin type: ${profile?.skin_type || "unknown"}, age: ${profile?.age_range || "unknown"}, concerns: ${(profile?.skin_concerns || []).join(", ")}

Also provide a 2-3 sentence friendly summary and top 3 priority areas.

Return ONLY valid JSON in this format:
{
  "acne_score": number,
  "texture_score": number,
  "pigmentation_score": number,
  "hydration_score": number,
  "wrinkle_score": number,
  "pore_score": number,
  "redness_score": number,
  "dark_circles_score": number,
  "ai_summary": "string",
  "priority_areas": ["string", "string", "string"]
}`,
              },
            ],
          },
        ],
      }),
    }
  );

  const aiResult = await analysisResponse.json();
  const content = aiResult.content[0].text;
  const scores = JSON.parse(content);

  // Calculate overall score
  const overall =
    (scores.acne_score +
      scores.texture_score +
      scores.pigmentation_score +
      scores.hydration_score +
      scores.wrinkle_score +
      scores.pore_score +
      scores.redness_score +
      scores.dark_circles_score) /
    8;

  // Save to database
  const { data: analysis, error } = await supabase
    .from("skin_analyses")
    .insert({
      user_id,
      image_path,
      overall_score: Math.round(overall * 10) / 10,
      acne_score: scores.acne_score,
      texture_score: scores.texture_score,
      pigmentation_score: scores.pigmentation_score,
      hydration_score: scores.hydration_score,
      wrinkle_score: scores.wrinkle_score,
      pore_score: scores.pore_score,
      redness_score: scores.redness_score,
      dark_circles_score: scores.dark_circles_score,
      ai_summary: scores.ai_summary,
      raw_ai_response: scores,
      model_version: "claude-sonnet-4-5-20250514",
    })
    .select()
    .single();

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
    });
  }

  return new Response(JSON.stringify(analysis), {
    headers: { "Content-Type": "application/json" },
  });
});
