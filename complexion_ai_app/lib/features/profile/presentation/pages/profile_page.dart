import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/di.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()
        ..add(ProfileLoadRequested(user?.id ?? '')),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Failed to load profile: ${state.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User avatar + email
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.skinPrimaryBg,
                          child: Text(
                            _initials(user?.email),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.skinPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.email ?? 'Unknown user',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (state.loadedProfile == null)
                    Center(
                      child: Text(
                        'No skin profile found. Complete the setup to personalise your experience.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else ...[
                    _ProfileSection(
                      title: 'Skin type',
                      value: state.skinType ?? '—',
                    ),
                    _ProfileSection(
                      title: 'Age range',
                      value: state.ageRange ?? '—',
                    ),
                    _ProfileSection(
                      title: 'Climate',
                      value: state.climate ?? '—',
                    ),
                    if (state.fitzpatrickScale != null)
                      _ProfileSection(
                        title: 'Fitzpatrick scale',
                        value: 'Type ${state.fitzpatrickScale}',
                      ),
                    if (state.selectedConcerns.isNotEmpty)
                      _ProfileChipsSection(
                        title: 'Skin concerns',
                        items: state.selectedConcerns,
                      ),
                    if (state.selectedGoals.isNotEmpty)
                      _ProfileChipsSection(
                        title: 'Goals',
                        items: state.selectedGoals,
                      ),
                    if (state.allergies.isNotEmpty)
                      _ProfileChipsSection(
                        title: 'Allergies',
                        items: state.allergies,
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _initials(String? email) {
    if (email == null || email.isEmpty) return '?';
    return email[0].toUpperCase();
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileSection({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.skinTextSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileChipsSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _ProfileChipsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.skinTextSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: items
                .map((item) => Chip(
                      label: Text(item, style: const TextStyle(fontSize: 12)),
                      backgroundColor: AppColors.skinPrimaryBg,
                      labelStyle: TextStyle(color: AppColors.skinPrimary),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
