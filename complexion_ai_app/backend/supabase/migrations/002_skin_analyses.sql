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
