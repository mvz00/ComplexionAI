import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
  const { conversation_id, message, image_path } = await req.json();

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // Get conversation and user context
  const { data: conversation } = await supabase
    .from("chat_conversations")
    .select()
    .eq("id", conversation_id)
    .single();

  if (!conversation) {
    return new Response(JSON.stringify({ error: "Conversation not found" }), {
      status: 404,
    });
  }

  const userId = conversation.user_id;

  // Fetch context in parallel
  const [profileRes, analysisRes, routinesRes, checkinsRes, messagesRes] =
    await Promise.all([
      supabase.from("skin_profiles").select().eq("user_id", userId).single(),
      supabase
        .from("skin_analyses")
        .select()
        .eq("user_id", userId)
        .order("analysed_at", { ascending: false })
        .limit(1)
        .single(),
      supabase
        .from("routines")
        .select("*, routine_steps(*)")
        .eq("user_id", userId)
        .eq("is_active", true),
      supabase
        .from("daily_checkins")
        .select()
        .eq("user_id", userId)
        .order("checkin_date", { ascending: false })
        .limit(7),
      supabase
        .from("chat_messages")
        .select()
        .eq("conversation_id", conversation_id)
        .order("created_at")
        .limit(10),
    ]);

  // Build conversation history
  const history = (messagesRes.data || []).map((m: any) => ({
    role: m.role,
    content: m.content,
  }));

  // Add current message
  history.push({ role: "user", content: message });

  const systemPrompt = `You are ComplexionAI, a knowledgeable skincare advisor. You have access to:
- User's skin profile: ${JSON.stringify(profileRes.data)}
- Latest analysis: ${JSON.stringify(analysisRes.data)}
- Current routine: ${JSON.stringify(routinesRes.data)}
- Recent check-ins: ${JSON.stringify(checkinsRes.data)}

Guidelines:
- Be warm, encouraging, evidence-based
- Reference their specific scores and concerns
- Recommend products from our catalogue when relevant
- Flag when they should see a dermatologist
- Never diagnose medical conditions
- Use Australian English
- Keep responses concise (2-4 paragraphs max)`;

  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-5-20250514",
      max_tokens: 1024,
      system: systemPrompt,
      messages: history,
    }),
  });

  const aiResult = await response.json();
  const aiContent = aiResult.content[0].text;

  return new Response(
    JSON.stringify({
      content: aiContent,
      metadata: {
        model: "claude-sonnet-4-5-20250514",
        has_product_recommendation: aiContent.toLowerCase().includes("recommend"),
      },
    }),
    { headers: { "Content-Type": "application/json" } }
  );
});
