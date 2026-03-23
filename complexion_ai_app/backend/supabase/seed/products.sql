-- Seed: Sample Products Catalogue

INSERT INTO public.products (name, brand, category, description, key_ingredients, suitable_skin_types, targets_concerns, price_aud, rating, is_active) VALUES

-- Cleansers
('Hydrating Facial Cleanser', 'CeraVe', 'cleanser',
 'Gentle, non-foaming cleanser with ceramides and hyaluronic acid. Ideal for daily use.',
 ARRAY['ceramides', 'hyaluronic_acid', 'glycerin'],
 ARRAY['dry', 'combination', 'normal', 'sensitive'],
 ARRAY['dehydration', 'dullness'],
 18.99, 4.6, true),

('Salicylic Acid Cleanser', 'CeraVe', 'cleanser',
 'Medicated cleanser with 2% salicylic acid for acne-prone skin.',
 ARRAY['salicylic_acid', 'niacinamide', 'ceramides'],
 ARRAY['oily', 'combination'],
 ARRAY['acne', 'large_pores'],
 21.99, 4.4, true),

('Soy pH-Balanced Cleanser', 'Fresh', 'cleanser',
 'Gentle gel cleanser with soy proteins and cucumber extract.',
 ARRAY['soy_proteins', 'cucumber_extract', 'rosewater'],
 ARRAY['normal', 'sensitive', 'dry'],
 ARRAY['redness', 'dullness'],
 54.00, 4.3, true),

-- Serums
('Vitamin C Suspension 23% + HA Spheres 2%', 'The Ordinary', 'serum',
 'High-strength vitamin C brightening serum with hyaluronic acid.',
 ARRAY['vitamin_c', 'hyaluronic_acid'],
 ARRAY['oily', 'combination', 'normal'],
 ARRAY['dark_spots', 'dullness', 'texture'],
 9.90, 4.2, true),

('Hyaluronic Acid 2% + B5', 'The Ordinary', 'serum',
 'Multi-weight hyaluronic acid hydration serum.',
 ARRAY['hyaluronic_acid', 'panthenol'],
 ARRAY['oily', 'dry', 'combination', 'normal', 'sensitive'],
 ARRAY['dehydration'],
 12.90, 4.5, true),

('Niacinamide 10% + Zinc 1%', 'The Ordinary', 'serum',
 'Oil-control and pore-minimising serum.',
 ARRAY['niacinamide', 'zinc'],
 ARRAY['oily', 'combination'],
 ARRAY['acne', 'large_pores', 'texture'],
 9.90, 4.3, true),

('Advanced Retinol Serum', 'Paula''s Choice', 'serum',
 'Gentle retinol serum for anti-ageing and texture improvement.',
 ARRAY['retinol', 'peptides', 'vitamin_c'],
 ARRAY['normal', 'combination', 'dry'],
 ARRAY['wrinkles', 'texture', 'dark_spots'],
 49.00, 4.5, true),

-- Moisturisers
('Toleriane Sensitive Moisturiser', 'La Roche-Posay', 'moisturiser',
 'Lightweight, fragrance-free moisturiser for sensitive skin.',
 ARRAY['niacinamide', 'glycerin', 'shea_butter'],
 ARRAY['sensitive', 'normal', 'combination'],
 ARRAY['redness', 'dehydration'],
 29.99, 4.7, true),

('Moisturising Cream', 'CeraVe', 'moisturiser',
 'Rich cream with 3 essential ceramides for dry skin.',
 ARRAY['ceramides', 'hyaluronic_acid', 'glycerin'],
 ARRAY['dry', 'normal'],
 ARRAY['dehydration', 'dullness'],
 22.99, 4.6, true),

-- Sunscreens
('Face Day Wear Moisturiser SPF50+', 'Cancer Council', 'sunscreen',
 'Lightweight daily moisturiser with broad spectrum SPF50+ protection.',
 ARRAY['zinc_oxide', 'niacinamide', 'vitamin_e'],
 ARRAY['oily', 'combination', 'normal', 'sensitive'],
 ARRAY[],
 12.99, 4.4, true),

('Ultra-Light Invisible Fluid SPF50+', 'La Roche-Posay', 'sunscreen',
 'Ultra-light, invisible finish broad-spectrum sunscreen.',
 ARRAY['anthelios_filter', 'vitamin_e'],
 ARRAY['oily', 'combination', 'normal'],
 ARRAY[],
 32.99, 4.6, true),

-- Exfoliants
('Glycolic Acid 7% Exfoliating Toner', 'The Ordinary', 'exfoliant',
 'Daily exfoliating toner with glycolic acid and aloe vera.',
 ARRAY['glycolic_acid', 'aloe_vera', 'ginseng'],
 ARRAY['oily', 'combination', 'normal'],
 ARRAY['texture', 'dullness', 'large_pores'],
 14.90, 4.3, true),

-- Treatments
('Effaclar Duo+ Acne Treatment', 'La Roche-Posay', 'treatment',
 'Targeted acne treatment with salicylic acid and niacinamide.',
 ARRAY['salicylic_acid', 'niacinamide', 'piroctone_olamine'],
 ARRAY['oily', 'combination'],
 ARRAY['acne', 'dark_spots'],
 34.99, 4.4, true);
