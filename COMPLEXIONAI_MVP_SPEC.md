# ComplexionAI — MVP Specification
## AI-Powered Skincare Analysis & Routine Builder

**Version:** 1.0 MVP
**Platform:** Flutter (iOS, Android, Web Admin)
**Architecture Pattern:** Clean Architecture + BLoC + Repository Pattern
**Last Updated:** 2026-03-23

---

## 1. Product Overview

### 1.1 Concept
ComplexionAI is a mobile-first AI skincare companion that uses computer vision to analyse a user's skin, builds personalised routines, tracks daily progress, and recommends products/procedures. An admin backend manages product catalogues, AI model configs, user analytics, and content.

### 1.2 Core Value Propositions
- AI skin analysis via device camera (acne, texture, pigmentation, hydration indicators, wrinkles, pore size)
- Personalised routine generation based on analysis + user profile
- Daily check-in tracking with before/after comparison
- Product/procedure recommendations with affiliate integration
- Admin dashboard for catalogue management, user insights, and AI tuning

### 1.3 Target Users
- **End Users:** 18-45, skincare-conscious, willing to follow structured routines
- **Admin Users:** Product managers, dermatology advisors, content editors

---

## 2. Technical Architecture

### 2.1 Flutter App Structure
```
lib/
├── main.dart
├── app/
│   ├── app.dart                    # MaterialApp, routing, theme
│   ├── router.dart                 # GoRouter configuration
│   └── di.dart                     # Dependency injection (get_it)
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   └── typography.dart
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── utils/
│   │   ├── image_utils.dart        # Camera/gallery preprocessing
│   │   ├── date_utils.dart
│   │   └── validators.dart
│   ├── network/
│   │   ├── api_client.dart         # Dio HTTP client
│   │   ├── api_interceptors.dart
│   │   └── api_exceptions.dart
│   └── services/
│       ├── ai_service.dart         # AI analysis orchestration
│       ├── camera_service.dart
│       ├── notification_service.dart
│       └── local_storage_service.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── auth_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in.dart
│   │   │       ├── sign_up.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── pages/
│   │           ├── login_page.dart
│   │           ├── register_page.dart
│   │           └── onboarding_page.dart
│   ├── skin_analysis/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── analysis_result_model.dart
│   │   │   │   └── skin_metrics_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── analysis_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── analysis_remote_datasource.dart
│   │   │       └── analysis_local_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── analysis_result.dart
│   │   │   │   └── skin_metrics.dart
│   │   │   ├── repositories/
│   │   │   │   └── analysis_repository.dart
│   │   │   └── usecases/
│   │   │       ├── capture_and_analyse.dart
│   │   │       ├── get_analysis_history.dart
│   │   │       └── compare_analyses.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── analysis_bloc.dart
│   │       │   ├── analysis_event.dart
│   │       │   └── analysis_state.dart
│   │       ├── pages/
│   │       │   ├── camera_capture_page.dart
│   │       │   ├── analysis_result_page.dart
│   │       │   └── analysis_history_page.dart
│   │       └── widgets/
│   │           ├── skin_score_radar.dart
│   │           ├── face_overlay_guide.dart
│   │           └── metric_card.dart
│   ├── routine/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── routine_model.dart
│   │   │   │   ├── routine_step_model.dart
│   │   │   │   └── product_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── routine_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── routine_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── routine.dart
│   │   │   │   ├── routine_step.dart
│   │   │   │   └── product.dart
│   │   │   ├── repositories/
│   │   │   │   └── routine_repository.dart
│   │   │   └── usecases/
│   │   │       ├── generate_routine.dart
│   │   │       ├── update_routine.dart
│   │   │       └── log_routine_completion.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── routine_bloc.dart
│   │       │   ├── routine_event.dart
│   │       │   └── routine_state.dart
│   │       ├── pages/
│   │       │   ├── routine_overview_page.dart
│   │       │   ├── routine_detail_page.dart
│   │       │   └── product_detail_page.dart
│   │       └── widgets/
│   │           ├── routine_step_card.dart
│   │           ├── product_recommendation_tile.dart
│   │           └── routine_progress_ring.dart
│   ├── daily_checkin/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── checkin_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── checkin_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── checkin_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── checkin.dart
│   │   │   ├── repositories/
│   │   │   │   └── checkin_repository.dart
│   │   │   └── usecases/
│   │   │       ├── submit_checkin.dart
│   │   │       └── get_checkin_streak.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── checkin_bloc.dart
│   │       │   ├── checkin_event.dart
│   │       │   └── checkin_state.dart
│   │       ├── pages/
│   │       │   ├── daily_checkin_page.dart
│   │       │   └── progress_timeline_page.dart
│   │       └── widgets/
│   │           ├── before_after_slider.dart
│   │           ├── streak_counter.dart
│   │           └── mood_skin_selector.dart
│   ├── ai_chat/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── chat_message_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── chat_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── chat_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── chat_message.dart
│   │   │   ├── repositories/
│   │   │   │   └── chat_repository.dart
│   │   │   └── usecases/
│   │   │       ├── send_message.dart
│   │   │       └── get_chat_history.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── chat_bloc.dart
│   │       │   ├── chat_event.dart
│   │       │   └── chat_state.dart
│   │       ├── pages/
│   │       │   └── ai_chat_page.dart
│   │       └── widgets/
│   │           ├── chat_bubble.dart
│   │           ├── quick_action_chips.dart
│   │           └── image_attachment_preview.dart
│   └── profile/
│       ├── data/
│       │   ├── models/
│       │   │   └── skin_profile_model.dart
│       │   ├── repositories/
│       │   │   └── profile_repository_impl.dart
│       │   └── datasources/
│       │       └── profile_remote_datasource.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── skin_profile.dart
│       │   ├── repositories/
│       │   │   └── profile_repository.dart
│       │   └── usecases/
│       │       └── update_skin_profile.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── profile_bloc.dart
│           │   ├── profile_event.dart
│           │   └── profile_state.dart
│           ├── pages/
│           │   ├── profile_page.dart
│           │   ├── skin_profile_setup_page.dart
│           │   └── settings_page.dart
│           └── widgets/
│               └── skin_type_selector.dart
└── shared/
    ├── widgets/
    │   ├── loading_overlay.dart
    │   ├── error_widget.dart
    │   ├── custom_app_bar.dart
    │   └── bottom_nav_bar.dart
    └── extensions/
        ├── context_extensions.dart
        └── string_extensions.dart
```

### 2.2 Backend Architecture (Supabase + Edge Functions)
```
backend/
├── supabase/
│   ├── migrations/
│   │   ├── 001_users_and_profiles.sql
│   │   ├── 002_skin_analyses.sql
│   │   ├── 003_routines_and_steps.sql
│   │   ├── 004_products_catalogue.sql
│   │   ├── 005_daily_checkins.sql
│   │   ├── 006_chat_messages.sql
│   │   └── 007_admin_config.sql
│   ├── functions/
│   │   ├── analyse-skin/            # Receives image, calls AI vision API, returns metrics
│   │   ├── generate-routine/        # Takes analysis + profile, returns routine via LLM
│   │   ├── ai-chat/                 # Conversational AI with skin context
│   │   ├── recommend-products/      # Product matching based on analysis + routine
│   │   ├── daily-insights/          # Generate daily AI insights from checkin data
│   │   └── admin-analytics/         # Aggregate user/analysis stats for admin
│   └── seed/
│       ├── products.sql
│       └── ingredient_database.sql
└── storage/
    ├── skin-images/                 # User skin photos (private, encrypted)
    └── product-images/              # Product catalogue images (public)
```

### 2.3 Admin Web App Structure (Flutter Web)
```
admin/
├── lib/
│   ├── features/
│   │   ├── dashboard/               # KPIs, user growth, analysis volume
│   │   ├── user_management/         # User list, profiles, activity logs
│   │   ├── product_catalogue/       # CRUD products, ingredients, categories
│   │   ├── routine_templates/       # Pre-built routine templates
│   │   ├── ai_config/              # Prompt management, model selection, thresholds
│   │   ├── content_management/      # Tips, articles, push notification content
│   │   └── analytics/              # Retention, engagement, skin improvement trends
```

### 2.4 Technology Stack
| Layer | Technology | Purpose |
|-------|-----------|---------|
| Mobile/Web | Flutter 3.x | Cross-platform UI |
| State | flutter_bloc | State management |
| DI | get_it + injectable | Dependency injection |
| Routing | go_router | Declarative routing |
| Backend | Supabase | Auth, DB, Storage, Edge Functions |
| Database | PostgreSQL (via Supabase) | Relational data store |
| AI Vision | Google Cloud Vision API or Custom ML model | Skin image analysis |
| AI LLM | Anthropic Claude API (via Edge Function) | Routine gen, chat, recommendations |
| Image Processing | TensorFlow Lite (on-device) | Face detection, image quality validation |
| Notifications | Firebase Cloud Messaging | Push notifications |
| Analytics | PostHog or Mixpanel | User behaviour tracking |
| Payments | RevenueCat | Subscriptions (iOS/Android) |
| CI/CD | Codemagic or GitHub Actions | Build + deploy |

---

## 3. Database Schema

### 3.1 Core Tables

```sql
-- Users & Profiles
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  subscription_tier TEXT DEFAULT 'free', -- free, premium, pro
  subscription_expires_at TIMESTAMPTZ
);

CREATE TABLE skin_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  skin_type TEXT, -- oily, dry, combination, normal, sensitive
  skin_concerns TEXT[], -- ['acne', 'wrinkles', 'dark_spots', 'redness']
  age_range TEXT, -- '18-24', '25-34', '35-44', '45+'
  gender TEXT,
  climate TEXT, -- tropical, arid, temperate, cold
  allergies TEXT[],
  current_products TEXT[],
  fitzpatrick_scale INT, -- 1-6
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Skin Analyses
CREATE TABLE skin_analyses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  image_path TEXT NOT NULL,
  overall_score DECIMAL(4,1), -- 0-100
  acne_score DECIMAL(4,1),
  texture_score DECIMAL(4,1),
  pigmentation_score DECIMAL(4,1),
  hydration_score DECIMAL(4,1),
  wrinkle_score DECIMAL(4,1),
  pore_score DECIMAL(4,1),
  redness_score DECIMAL(4,1),
  dark_circles_score DECIMAL(4,1),
  ai_summary TEXT, -- AI-generated natural language summary
  raw_ai_response JSONB, -- Full AI response for debugging
  model_version TEXT, -- Track which AI model was used
  analysed_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_analyses_user_date ON skin_analyses(user_id, analysed_at DESC);

-- Routines
CREATE TABLE routines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  routine_type TEXT NOT NULL, -- 'morning', 'evening', 'weekly'
  is_active BOOLEAN DEFAULT true,
  generated_by TEXT DEFAULT 'ai', -- 'ai', 'admin_template', 'user_custom'
  based_on_analysis_id UUID REFERENCES skin_analyses(id),
  ai_reasoning TEXT, -- Why this routine was recommended
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE routine_steps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id UUID REFERENCES routines(id) ON DELETE CASCADE,
  step_order INT NOT NULL,
  step_type TEXT NOT NULL, -- 'cleanser', 'toner', 'serum', 'moisturiser', 'sunscreen', 'treatment', 'mask', 'tool'
  title TEXT NOT NULL,
  description TEXT,
  duration_seconds INT,
  recommended_product_id UUID REFERENCES products(id),
  is_optional BOOLEAN DEFAULT false,
  ai_notes TEXT -- Why this step matters for their skin
);

-- Products Catalogue
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  brand TEXT NOT NULL,
  category TEXT NOT NULL, -- 'cleanser', 'moisturiser', 'serum', etc.
  subcategory TEXT,
  description TEXT,
  key_ingredients TEXT[],
  suitable_skin_types TEXT[],
  targets_concerns TEXT[],
  price_aud DECIMAL(8,2),
  image_url TEXT,
  affiliate_url TEXT,
  affiliate_provider TEXT, -- 'amazon', 'adore_beauty', 'sephora', etc.
  rating DECIMAL(3,2),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE product_ingredients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  ingredient_name TEXT NOT NULL,
  concentration_pct DECIMAL(5,2),
  is_active_ingredient BOOLEAN DEFAULT false,
  comedogenic_rating INT -- 0-5
);

-- Daily Check-ins
CREATE TABLE daily_checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  checkin_date DATE NOT NULL,
  skin_feeling TEXT, -- 'great', 'good', 'okay', 'bad', 'terrible'
  notes TEXT,
  photo_path TEXT,
  routine_completed BOOLEAN DEFAULT false,
  routine_id UUID REFERENCES routines(id),
  steps_completed UUID[], -- Array of routine_step IDs completed
  sleep_hours DECIMAL(3,1),
  water_intake_litres DECIMAL(3,1),
  stress_level INT, -- 1-5
  ai_daily_tip TEXT, -- AI-generated personalised tip
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, checkin_date)
);

-- AI Chat
CREATE TABLE chat_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES chat_conversations(id) ON DELETE CASCADE,
  role TEXT NOT NULL, -- 'user', 'assistant'
  content TEXT NOT NULL,
  image_path TEXT, -- If user attaches a photo
  metadata JSONB, -- Product references, routine links, etc.
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Admin Config
CREATE TABLE ai_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  config_key TEXT UNIQUE NOT NULL,
  config_value JSONB NOT NULL,
  description TEXT,
  updated_by UUID REFERENCES users(id),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Notifications
CREATE TABLE notification_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trigger_type TEXT NOT NULL, -- 'daily_reminder', 'streak_milestone', 'routine_update', 'new_analysis'
  title_template TEXT NOT NULL,
  body_template TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### 3.2 Row-Level Security (Supabase RLS)
```sql
-- Users can only access their own data
ALTER TABLE skin_analyses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users see own analyses" ON skin_analyses
  FOR ALL USING (auth.uid() = user_id);

-- Admin role can access all
CREATE POLICY "Admins see all" ON skin_analyses
  FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND subscription_tier = 'admin')
  );

-- Products are publicly readable
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Products publicly readable" ON products
  FOR SELECT USING (is_active = true);
```

---

## 4. Feature Specifications

### 4.1 Onboarding Flow
**Screens:** Welcome → Sign Up/In → Skin Profile Questionnaire → First Scan Prompt

**Skin Profile Questionnaire collects:**
- Skin type (with visual examples)
- Primary concerns (multi-select)
- Age range
- Fitzpatrick scale (with photo examples)
- Climate/location
- Known allergies/sensitivities
- Current products they use (optional, free text)
- Goals (e.g., "clear acne", "anti-ageing", "glow")

**AI Integration:** After profile completion, AI generates a preliminary assessment and prompts for first camera scan.

### 4.2 Skin Analysis (Core Feature)
**Flow:** Tap "Scan" → Camera opens with face guide overlay → Auto-capture when face aligned → Processing animation → Results screen

**Camera Requirements:**
- Face detection overlay (oval guide)
- Lighting quality indicator (too dark/bright warning)
- Auto-capture when conditions met (face centred, good lighting, in focus)
- Multiple angles: front, left profile, right profile (guided)
- Minimum resolution: 1080p
- Save to encrypted Supabase storage

**AI Analysis Pipeline:**
1. **On-device (TFLite):** Face detection, image quality validation, face region cropping
2. **Server (Edge Function → Vision API):** Send cropped face image to AI vision model
3. **Server (Edge Function → Claude API):** Send vision results + user profile to Claude for natural language summary, scoring, and actionable recommendations
4. **Response:** Structured JSON with scores + natural language insights

**Analysis Result Screen:**
- Overall skin health score (0-100) with animated ring
- Radar chart of individual metrics (acne, texture, pigmentation, hydration, wrinkles, pores, redness, dark circles)
- AI-generated summary paragraph
- "Build My Routine" CTA button
- Compare with previous analysis (side-by-side slider)
- Save/share results

### 4.3 Routine Generation
**Flow:** Analysis Complete → AI generates AM + PM routines → User reviews/customises → Activate routine

**AI Routine Generation (Claude API):**
- Input: Analysis scores, skin profile, current products, goals, budget preference, product catalogue
- Output: Structured routine with steps, timing, product recommendations, reasoning for each step
- System prompt includes dermatological best practices (layering order, ingredient conflicts, etc.)

**Routine Display:**
- Morning routine card / Evening routine card (tabbed)
- Each step: icon, name, description, recommended product, duration
- Tap step → product detail with affiliate link
- "Regenerate" option with modification prompts ("less steps", "budget-friendly", "focus on acne")
- Mark steps complete (daily tracking)

### 4.4 Daily Check-in
**Flow:** Push notification → Open app → Quick check-in card on home screen

**Check-in Captures:**
- How does your skin feel today? (emoji selector: 5 levels)
- Optional photo (triggers quick mini-analysis for comparison)
- Did you complete your routine? (yes/partial/no with step checklist)
- Lifestyle factors: sleep, water, stress (quick sliders)
- Free-text notes

**AI Daily Insight:** After check-in, AI generates a short personalised tip based on their input, recent trends, and current routine.

### 4.5 AI Chat (Skin Advisor)
**Always-available chat interface:**
- Context-aware: AI has access to user's profile, latest analysis, current routine, recent check-ins
- Quick action chips: "Why is my skin breaking out?", "Can I use retinol with vitamin C?", "What SPF should I use?", "Suggest a cheaper alternative"
- Can attach photos for spot-analysis
- Product recommendations link to catalogue with affiliate URLs
- Chat history persisted per conversation

**System Prompt Structure (Claude):**
```
You are ComplexionAI, a knowledgeable skincare advisor. You have access to:
- User's skin profile: {profile_json}
- Latest analysis: {analysis_json}
- Current routine: {routine_json}
- Recent check-ins: {checkins_json}

Guidelines:
- Be warm, encouraging, evidence-based
- Reference their specific scores and concerns
- Recommend products from our catalogue when relevant
- Flag when they should see a dermatologist
- Never diagnose medical conditions
- Use Australian English
```

### 4.6 Progress Tracking
**Screens:** Timeline view, Before/After comparison, Trend charts

**Timeline View:**
- Scrollable timeline of check-ins and analyses
- Colour-coded entries by skin feeling
- Streak counter (consecutive check-in days)

**Before/After:**
- Side-by-side photo comparison with date picker
- Interactive slider overlay
- Score delta badges ("+5 hydration", "-3 acne")

**Trend Charts:**
- Line charts per metric over time (recharts style)
- Filter by timeframe: 1W, 1M, 3M, 6M, All
- AI trend summary: "Your hydration has improved 15% over the last month since starting hyaluronic acid serum"

### 4.7 Product Discovery
**Screens:** Browse catalogue, Product detail, AI-curated "For You" feed

**Browse:**
- Category filters (cleansers, serums, moisturisers, sunscreens, tools, treatments)
- Sort by: relevance to user, price, rating
- "AI Match Score" badge per product (how well it fits their profile)

**Product Detail:**
- Name, brand, image, price
- Key ingredients with brief explanations
- AI compatibility note ("Great for your combination skin and acne concerns")
- Affiliate buy button
- Reviews/ratings

### 4.8 Notifications & Engagement
| Trigger | Notification | Timing |
|---------|-------------|--------|
| Morning routine | "Good morning! Time for your AM routine ☀️" | Configurable (default 7am) |
| Evening routine | "Wind down with your PM skincare 🌙" | Configurable (default 9pm) |
| Missed check-in | "How's your skin today? Quick 30-sec check-in" | 12pm if not checked in |
| Streak milestone | "🔥 7-day streak! Your consistency is paying off" | On achievement |
| Weekly analysis prompt | "Weekly scan time! Let's see your progress" | Configurable day |
| AI insight | "New insight: Your texture score improved 8% this week!" | After analysis comparison |

---

## 5. Admin Dashboard Specification

### 5.1 Dashboard Home
- Total users, active users (DAU/MAU), new signups (chart)
- Total analyses performed, average skin score
- Subscription breakdown (free/premium/pro)
- Revenue metrics (MRR, conversion rate)
- Top concerns across user base (pie chart)

### 5.2 User Management
- Searchable user list with filters (subscription, join date, last active)
- User detail view: profile, analyses, routines, chat logs, check-in history
- Ability to flag/suspend accounts
- Export user data (GDPR compliance)

### 5.3 Product Catalogue Management
- CRUD interface for products
- Bulk import via CSV
- Ingredient database management
- Affiliate link management
- Product performance metrics (views, clicks, AI recommendation frequency)

### 5.4 AI Configuration
- System prompt editor (for chat, routine gen, analysis summary)
- Model selection (Claude model version)
- Analysis threshold configuration (what score triggers "concern" alerts)
- A/B test configuration for different prompt variants
- AI response audit log

### 5.5 Content Management
- Notification template editor
- In-app tips/articles CRUD
- Push notification campaign builder

### 5.6 Analytics
- Retention cohorts
- Feature usage heatmaps
- Skin improvement distribution across user base
- Product recommendation conversion rates
- AI chat engagement metrics

---

## 6. AI Integration Details

### 6.1 Skin Analysis AI Pipeline

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐     ┌──────────────┐
│ Camera       │────▶│ On-Device    │────▶│ Supabase Edge   │────▶│ Claude API   │
│ Capture      │     │ TFLite       │     │ Function        │     │ (Summary)    │
│              │     │ - Face detect│     │ - Vision API    │     │              │
│              │     │ - Quality    │     │ - Score extract │     │              │
│              │     │ - Crop       │     │ - Metrics calc  │     │              │
└─────────────┘     └──────────────┘     └─────────────────┘     └──────────────┘
```

**Vision API Prompt (for Google Cloud Vision or GPT-4V):**
```
Analyse this facial skin image. Provide scores from 0-100 (100 = healthiest) for:
- Acne severity
- Skin texture smoothness
- Pigmentation evenness
- Apparent hydration level
- Wrinkle/fine line presence
- Pore visibility
- Redness/inflammation
- Dark circles under eyes

Also identify:
- Visible skin conditions
- Areas of concern (mapped to face regions)
- Image quality assessment

Return as structured JSON.
```

**Claude Summary Prompt:**
```
Given these skin analysis metrics: {scores}
And user profile: {profile}

Generate:
1. A 2-3 sentence friendly summary of their skin health
2. Top 3 priority areas to address
3. One encouraging observation
4. Flag if anything warrants professional dermatological review

Tone: Warm, knowledgeable, Australian English. Never diagnostic.
```

### 6.2 Routine Generation Prompt
```
You are building a skincare routine for a user.

Analysis: {scores}
Profile: {skin_type, concerns, allergies, fitzpatrick_scale, climate, age_range}
Goals: {user_goals}
Budget: {budget_preference}
Available products: {product_catalogue_filtered}

Generate a morning and evening routine following these dermatological principles:
- Correct layering order (thinnest to thickest)
- No conflicting ingredients (e.g., retinol + AHA in same routine)
- Sunscreen always last step AM
- Actives introduced gradually
- Product recommendations from our catalogue

Return structured JSON:
{
  "morning": { "steps": [...] },
  "evening": { "steps": [...] },
  "reasoning": "...",
  "ingredient_warnings": [...],
  "when_to_reassess": "..."
}
```

### 6.3 AI Chat Context Window
Each chat message to Claude includes:
- System prompt with persona and guidelines
- User's skin profile (compact JSON)
- Latest analysis scores and date
- Current active routine steps
- Last 7 days of check-in data
- Last 10 messages in current conversation
- Product catalogue search results (if product query detected)

---

## 7. Monetisation Model

### 7.1 Subscription Tiers
| Feature | Free | Premium ($9.99/mo) | Pro ($19.99/mo) |
|---------|------|-------------------|-----------------|
| Skin analyses | 2/month | 8/month | Unlimited |
| AI chat messages | 10/day | 50/day | Unlimited |
| Routine generation | 1 routine | Unlimited regen | Unlimited + custom |
| Daily check-in | ✓ | ✓ | ✓ |
| Progress tracking | 30 days | Full history | Full history + export |
| Product recommendations | Basic | Personalised | Personalised + deals |
| Before/after comparison | ✓ | ✓ | ✓ + HD export |
| AI daily insights | ✗ | ✓ | ✓ |
| Priority AI response | ✗ | ✗ | ✓ |

### 7.2 Revenue Streams
- Subscriptions (RevenueCat)
- Affiliate product links (commission per sale)
- Sponsored product placements in catalogue (clearly labelled)

---

## 8. Security & Privacy

### 8.1 Data Protection
- All skin images encrypted at rest (Supabase storage encryption)
- Images transmitted over TLS only
- User can delete all their data (GDPR right to erasure)
- Skin images never used for model training without explicit opt-in consent
- AI analysis happens server-side, raw images not cached client-side beyond session
- Australian Privacy Act compliance (APP 1-13)

### 8.2 Authentication
- Supabase Auth (email/password, Google, Apple Sign-In)
- JWT-based session management
- Admin accounts require MFA
- Rate limiting on analysis and chat endpoints

---

## 9. MVP Scope & Phasing

### Phase 1 — MVP (8-12 weeks)
- [ ] Auth (email + social)
- [ ] Onboarding + skin profile questionnaire
- [ ] Camera capture with face guide overlay
- [ ] AI skin analysis (single front-facing photo)
- [ ] Analysis results display with scores + radar chart
- [ ] AI routine generation (AM + PM)
- [ ] Routine display with step checklist
- [ ] Daily check-in (quick mood + routine completion)
- [ ] Basic AI chat (context-aware)
- [ ] Simple progress timeline
- [ ] Product catalogue (read-only, pre-seeded)
- [ ] Push notifications (daily reminders)
- [ ] Basic admin dashboard (users, products CRUD, analytics overview)
- [ ] Subscription gates (RevenueCat)

### Phase 2 — Enhancement (post-MVP)
- Multi-angle analysis (front + profiles)
- Before/after comparison slider
- Trend charts with AI insights
- Product affiliate integration
- Advanced admin analytics
- A/B testing for AI prompts
- Community features (anonymised, opt-in)
- Dermatologist referral network

### Phase 3 — Scale
- Custom ML model trained on anonymised data (with consent)
- Ingredient conflict database
- Personalised product formulation suggestions
- Integration with smart mirrors / IoT devices
- Telehealth dermatologist booking
- White-label B2B for skincare brands

---

## 10. Claude Code Instructions

### 10.1 Project Init
```bash
flutter create --org com.ComplexionAI --project-name ComplexionAI ComplexionAI_app
cd ComplexionAI_app
```

### 10.2 Key Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  # State Management
  flutter_bloc: ^8.1.0
  equatable: ^2.0.5
  # Routing
  go_router: ^14.0.0
  # DI
  get_it: ^7.6.0
  injectable: ^2.3.0
  # Network
  dio: ^5.4.0
  # Supabase
  supabase_flutter: ^2.3.0
  # Camera
  camera: ^0.11.0
  # Image Processing
  image: ^4.1.0
  tflite_flutter: ^0.10.0
  google_mlkit_face_detection: ^0.11.0
  # UI
  fl_chart: ^0.68.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^3.1.0
  # Storage
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  # Payments
  purchases_flutter: ^6.0.0 # RevenueCat
  # Notifications
  firebase_messaging: ^14.0.0
  flutter_local_notifications: ^17.0.0
  # Utils
  intl: ^0.19.0
  uuid: ^4.3.0
  json_annotation: ^4.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  injectable_generator: ^2.4.0
  bloc_test: ^9.1.0
  mocktail: ^1.0.0
```

### 10.3 Build Order for Claude Code
1. **Core setup:** Theme, routing, DI, API client, Supabase init
2. **Auth feature:** Complete auth flow with Supabase
3. **Profile feature:** Skin profile questionnaire + persistence
4. **Skin Analysis feature:** Camera → API → Results display
5. **Routine feature:** AI generation → display → step tracking
6. **Daily Check-in feature:** Quick check-in form → persistence
7. **AI Chat feature:** Chat UI → Claude API integration
8. **Progress feature:** Timeline, basic charts
9. **Admin web app:** Dashboard, user management, product CRUD, AI config
10. **Notifications:** FCM setup, daily reminders
11. **Subscriptions:** RevenueCat integration, gating
12. **Polish:** Loading states, error handling, animations, onboarding

### 10.4 Environment Variables
```
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
ANTHROPIC_API_KEY=
GOOGLE_VISION_API_KEY=
REVENUECAT_API_KEY_IOS=
REVENUECAT_API_KEY_ANDROID=
POSTHOG_API_KEY=
```

---

## 11. Design System

### 11.1 Color Palette
```dart
// Primary
static const skinPrimary = Color(0xFF6B8F71);     // Sage green
static const skinPrimaryLight = Color(0xFFA8C5AD);
static const skinPrimaryDark = Color(0xFF3D5A42);

// Accent
static const skinAccent = Color(0xFFE8B4A2);       // Warm peach
static const skinAccentLight = Color(0xFFF5DDD3);

// Neutrals
static const skinBg = Color(0xFFFAF8F5);           // Warm off-white
static const skinSurface = Color(0xFFFFFFFF);
static const skinText = Color(0xFF2D2D2D);
static const skinTextSecondary = Color(0xFF7A7A7A);

// Scores
static const scoreExcellent = Color(0xFF4CAF50);
static const scoreGood = Color(0xFF8BC34A);
static const scoreAverage = Color(0xFFFFC107);
static const scorePoor = Color(0xFFFF9800);
static const scoreBad = Color(0xFFF44336);
```

### 11.2 Typography
- Display: Playfair Display (headings, scores)
- Body: DM Sans (body text, UI)
- Mono: JetBrains Mono (data values)

### 11.3 Key Design Principles
- Clean, spa-like aesthetic — not clinical
- Generous whitespace, rounded corners (16px radius)
- Soft shadows (elevation 2-4)
- Micro-animations on score reveals and transitions
- Progress visualisations use gradients (sage → peach)
- Photos always have soft rounded borders
- Dark mode: deep warm grey (#1A1A1A) not pure black
