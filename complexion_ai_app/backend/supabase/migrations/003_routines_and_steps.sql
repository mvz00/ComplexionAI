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
