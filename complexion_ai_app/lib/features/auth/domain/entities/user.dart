import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String subscriptionTier;
  final DateTime? subscriptionExpiresAt;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.subscriptionTier = 'free',
    this.subscriptionExpiresAt,
    required this.createdAt,
  });

  bool get isPremium => subscriptionTier == 'premium' || subscriptionTier == 'pro';
  bool get isPro => subscriptionTier == 'pro';
  bool get isAdmin => subscriptionTier == 'admin';

  @override
  List<Object?> get props => [id, email, displayName, subscriptionTier];
}
