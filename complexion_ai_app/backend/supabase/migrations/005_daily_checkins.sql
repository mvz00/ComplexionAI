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
