class AppConstants {
  AppConstants._();

  // Skin types
  static const List<String> skinTypes = [
    'oily',
    'dry',
    'combination',
    'normal',
    'sensitive',
  ];

  // Skin concerns
  static const List<String> skinConcerns = [
    'acne',
    'texture',
    'wrinkles',
    'dark_spots',
    'redness',
    'large_pores',
    'dullness',
    'dark_circles',
    'dehydration',
  ];

  // Age ranges
  static const List<String> ageRanges = [
    '18-24',
    '25-34',
    '35-44',
    '45+',
  ];

  // Climate options
  static const List<String> climates = [
    'tropical',
    'arid',
    'temperate',
    'cold',
  ];

  // Goals
  static const List<String> skinGoals = [
    'clear_acne',
    'smooth_texture',
    'anti_ageing',
    'glow',
    'even_tone',
    'hydration',
    'reduce_redness',
    'minimise_pores',
  ];

  // Skin feelings for check-in
  static const List<String> skinFeelings = [
    'great',
    'good',
    'okay',
    'bad',
    'terrible',
  ];

  static const List<String> skinFeelingEmojis = [
    '\u{1F929}', // star-struck
    '\u{1F60A}', // smiling
    '\u{1F610}', // neutral
    '\u{1F615}', // confused
    '\u{1F629}', // weary
  ];

  // Fitzpatrick scale colors (for UI circles)
  static const List<int> fitzpatrickColors = [
    0xFFFDEBD0,
    0xFFF5CBA7,
    0xFFD4A574,
    0xFFA0785A,
    0xFF6B4423,
    0xFF3D2314,
  ];

  // Routine step types
  static const List<String> routineStepTypes = [
    'cleanser',
    'toner',
    'serum',
    'moisturiser',
    'sunscreen',
    'treatment',
    'mask',
    'tool',
  ];

  // Product categories
  static const List<String> productCategories = [
    'cleanser',
    'moisturiser',
    'serum',
    'sunscreen',
    'toner',
    'exfoliant',
    'mask',
    'eye_cream',
    'tool',
    'treatment',
  ];

  // Subscription tiers
  static const String tierFree = 'free';
  static const String tierPremium = 'premium';
  static const String tierPro = 'pro';

  // Free tier limits
  static const int freeAnalysesPerMonth = 2;
  static const int freeChatMessagesPerDay = 10;
  static const int freeRoutineGenerations = 1;
  static const int freeProgressDays = 30;

  // Premium tier limits
  static const int premiumAnalysesPerMonth = 8;
  static const int premiumChatMessagesPerDay = 50;
}
