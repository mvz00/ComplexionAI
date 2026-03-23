import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String? description;
  final List<String> keyIngredients;
  final List<String> suitableSkinTypes;
  final List<String> targetsConcerns;
  final double? priceAud;
  final String? imageUrl;
  final String? affiliateUrl;
  final double? rating;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.description,
    this.keyIngredients = const [],
    this.suitableSkinTypes = const [],
    this.targetsConcerns = const [],
    this.priceAud,
    this.imageUrl,
    this.affiliateUrl,
    this.rating,
  });

  @override
  List<Object?> get props => [id, name, brand];
}
