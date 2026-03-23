import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.category,
    super.description,
    super.keyIngredients,
    super.suitableSkinTypes,
    super.targetsConcerns,
    super.priceAud,
    super.imageUrl,
    super.affiliateUrl,
    super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      keyIngredients: (json['key_ingredients'] as List<dynamic>?)?.cast<String>() ?? [],
      suitableSkinTypes: (json['suitable_skin_types'] as List<dynamic>?)?.cast<String>() ?? [],
      targetsConcerns: (json['targets_concerns'] as List<dynamic>?)?.cast<String>() ?? [],
      priceAud: (json['price_aud'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
      affiliateUrl: json['affiliate_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }
}
