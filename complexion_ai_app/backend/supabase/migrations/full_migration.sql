-- 001: Users & Skin Profiles
-- Extends Supabase auth.users with app-specific user data

CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  subscription_tier TEXT DEFAULT 'free' CHECK (subscription_tier IN ('free', 'premium', 'pro', 'admin')),
  subscription_expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.skin_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE UNIQUE,
  skin_type TEXT CHECK (skin_type IN ('oily', 'dry', 'combination', 'normal', 'sensitive')),
  skin_concerns TEXT[],
  age_range TEXT CHECK (age_range IN ('18-24', '25-34', '35-44', '45+')),
  gender TEXT,
  climate TEXT CHECK (climate IN ('tropical', 'arid', 'temperate', 'cold')),
  allergies TEXT[],
  current_products TEXT[],
  goals TEXT[],
  fitzpatrick_scale INT CHECK (fitzpatrick_scale BETWEEN 1 AND 6),
  onboarding_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Auto-create user row when auth user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email)
  VALUES (NEW.id, NEW.email);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER skin_profiles_updated_at
  BEFORE UPDATE ON public.skin_profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own data" ON public.users
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own data" ON public.users
  FOR UPDATE USING (auth.uid() = id);

ALTER TABLE public.skin_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own profile" ON public.skin_profiles
  FOR ALL USING (auth.uid() = user_id);

-- Admin policies
CREATE POLICY "Admins can view all users" ON public.users
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );

CREATE POLICY "Admins can view all profiles" ON public.skin_profiles
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );
-- 002: Skin Analyses

CREATE TABLE public.skin_analyses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  image_path TEXT NOT NULL,
  overall_score DECIMAL(4,1) CHECK (overall_score BETWEEN 0 AND 100),
  acne_score DECIMAL(4,1) CHECK (acne_score BETWEEN 0 AND 100),
  texture_score DECIMAL(4,1) CHECK (texture_score BETWEEN 0 AND 100),
  pigmentation_score DECIMAL(4,1) CHECK (pigmentation_score BETWEEN 0 AND 100),
  hydration_score DECIMAL(4,1) CHECK (hydration_score BETWEEN 0 AND 100),
  wrinkle_score DECIMAL(4,1) CHECK (wrinkle_score BETWEEN 0 AND 100),
  pore_score DECIMAL(4,1) CHECK (pore_score BETWEEN 0 AND 100),
  redness_score DECIMAL(4,1) CHECK (redness_score BETWEEN 0 AND 100),
  dark_circles_score DECIMAL(4,1) CHECK (dark_circles_score BETWEEN 0 AND 100),
  ai_summary TEXT,
  raw_ai_response JSONB,
  model_version TEXT,
  analysed_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_analyses_user_date ON public.skin_analyses(user_id, analysed_at DESC);

-- RLS
ALTER TABLE public.skin_analyses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own analyses" ON public.skin_analyses
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admins see all analyses" ON public.skin_analyses
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );
-- 003: Routines & Routine Steps

CREATE TABLE public.routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  routine_type TEXT NOT NULL CHECK (routine_type IN ('morning', 'evening', 'weekly')),
  is_active BOOLEAN DEFAULT true,
  generated_by TEXT DEFAULT 'ai' CHECK (generated_by IN ('ai', 'admin_template', 'user_custom')),
  based_on_analysis_id UUID REFERENCES public.skin_analyses(id),
  ai_reasoning TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.routine_steps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id UUID REFERENCES public.routines(id) ON DELETE CASCADE NOT NULL,
  step_order INT NOT NULL,
  step_type TEXT NOT NULL CHECK (step_type IN ('cleanser', 'toner', 'serum', 'moisturiser', 'sunscreen', 'treatment', 'mask', 'tool')),
  title TEXT NOT NULL,
  description TEXT,
  duration_seconds INT,
  recommended_product_id UUID, -- FK added after products table
  is_optional BOOLEAN DEFAULT false,
  ai_notes TEXT
);

CREATE INDEX idx_routine_steps_order ON public.routine_steps(routine_id, step_order);

CREATE TRIGGER routines_updated_at
  BEFORE UPDATE ON public.routines
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- RLS
ALTER TABLE public.routines ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own routines" ON public.routines
  FOR ALL USING (auth.uid() = user_id);

ALTER TABLE public.routine_steps ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users see own routine steps" ON public.routine_steps
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.routines WHERE id = routine_id AND user_id = auth.uid())
  );
-- 004: Products Catalogue

CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  brand TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('cleanser', 'moisturiser', 'serum', 'sunscreen', 'toner', 'exfoliant', 'mask', 'eye_cream', 'tool', 'treatment')),
  subcategory TEXT,
  description TEXT,
  key_ingredients TEXT[],
  suitable_skin_types TEXT[],
  targets_concerns TEXT[],
  price_aud DECIMAL(8,2),
  image_url TEXT,
  affiliate_url TEXT,
  affiliate_provider TEXT,
  rating DECIMAL(3,2) CHECK (rating BETWEEN 0 AND 5),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.product_ingredients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
  ingredient_name TEXT NOT NULL,
  concentration_pct DECIMAL(5,2),
  is_active_ingredient BOOLEAN DEFAULT false,
  comedogenic_rating INT CHECK (comedogenic_rating BETWEEN 0 AND 5)
);

-- Add FK from routine_steps to products
ALTER TABLE public.routine_steps
  ADD CONSTRAINT fk_routine_steps_product
  FOREIGN KEY (recommended_product_id) REFERENCES public.products(id);

CREATE TRIGGER products_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- RLS — products publicly readable
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Products publicly readable" ON public.products
  FOR SELECT USING (is_active = true);
CREATE POLICY "Admins manage products" ON public.products
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );

ALTER TABLE public.product_ingredients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Ingredients publicly readable" ON public.product_ingredients
  FOR SELECT USING (true);
CREATE POLICY "Admins manage ingredients" ON public.product_ingredients
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );
-- 005: Daily Check-ins

CREATE TABLE public.daily_checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  checkin_date DATE NOT NULL,
  skin_feeling TEXT CHECK (skin_feeling IN ('great', 'good', 'okay', 'bad', 'terrible')),
  notes TEXT,
  photo_path TEXT,
  routine_completed BOOLEAN DEFAULT false,
  routine_id UUID REFERENCES public.routines(id),
  steps_completed UUID[],
  sleep_hours DECIMAL(3,1),
  water_intake_litres DECIMAL(3,1),
  stress_level INT CHECK (stress_level BETWEEN 1 AND 5),
  ai_daily_tip TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, checkin_date)
);

CREATE INDEX idx_checkins_user_date ON public.daily_checkins(user_id, checkin_date DESC);

-- RLS
ALTER TABLE public.daily_checkins ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own checkins" ON public.daily_checkins
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admins view all checkins" ON public.daily_checkins
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );
-- 006: Chat Conversations & Messages

CREATE TABLE public.chat_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES public.chat_conversations(id) ON DELETE CASCADE NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  image_path TEXT,
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_chat_messages_conversation ON public.chat_messages(conversation_id, created_at);

CREATE TRIGGER chat_conversations_updated_at
  BEFORE UPDATE ON public.chat_conversations
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- RLS
ALTER TABLE public.chat_conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own conversations" ON public.chat_conversations
  FOR ALL USING (auth.uid() = user_id);

ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users see own messages" ON public.chat_messages
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.chat_conversations WHERE id = conversation_id AND user_id = auth.uid())
  );
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
