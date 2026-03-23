-- 007: Admin Config & Notification Templates

CREATE TABLE public.ai_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  config_key TEXT UNIQUE NOT NULL,
  config_value JSONB NOT NULL,
  description TEXT,
  updated_by UUID REFERENCES public.users(id),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.notification_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trigger_type TEXT NOT NULL CHECK (trigger_type IN (
    'daily_reminder', 'streak_milestone', 'routine_update',
    'new_analysis', 'morning_routine', 'evening_routine',
    'missed_checkin', 'weekly_scan'
  )),
  title_template TEXT NOT NULL,
  body_template TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- RLS — admin only
ALTER TABLE public.ai_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admins manage config" ON public.ai_config
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );

ALTER TABLE public.notification_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admins manage templates" ON public.notification_templates
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );

-- Seed default AI config
INSERT INTO public.ai_config (config_key, config_value, description) VALUES
  ('analysis_model', '"claude-sonnet-4-5-20250514"', 'AI model for skin analysis summaries'),
  ('chat_model', '"claude-sonnet-4-5-20250514"', 'AI model for chat conversations'),
  ('routine_model', '"claude-sonnet-4-5-20250514"', 'AI model for routine generation'),
  ('analysis_system_prompt', '"You are ComplexionAI, a knowledgeable skincare advisor. Analyse skin metrics and provide warm, encouraging, evidence-based summaries. Use Australian English. Never diagnose medical conditions."', 'System prompt for analysis summaries'),
  ('chat_system_prompt', '"You are ComplexionAI, a knowledgeable skincare advisor. Be warm, encouraging, and evidence-based. Recommend products from our catalogue when relevant. Flag when users should see a dermatologist. Never diagnose medical conditions. Use Australian English."', 'System prompt for chat');

-- Seed notification templates
INSERT INTO public.notification_templates (trigger_type, title_template, body_template) VALUES
  ('morning_routine', 'Good morning! ☀️', 'Time for your AM skincare routine'),
  ('evening_routine', 'Wind down 🌙', 'Time for your PM skincare routine'),
  ('missed_checkin', 'How''s your skin today?', 'Quick 30-second check-in — keep your streak going!'),
  ('streak_milestone', '🔥 {{streak_count}}-day streak!', 'Your consistency is paying off. Keep it up!'),
  ('weekly_scan', 'Weekly scan time!', 'Let''s see your progress this week'),
  ('new_analysis', 'New insight available', 'Your {{metric}} score improved {{delta}}% this week!');

-- Storage buckets (run via Supabase dashboard or CLI)
-- CREATE BUCKET skin-images WITH (public = false, file_size_limit = 10485760);
-- CREATE BUCKET product-images WITH (public = true, file_size_limit = 5242880);
