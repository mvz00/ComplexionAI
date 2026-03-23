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
