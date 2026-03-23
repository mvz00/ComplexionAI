import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../app/router.dart';
import '../../../../shared/extensions/string_extensions.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class SkinProfileSetupPage extends StatefulWidget {
  const SkinProfileSetupPage({super.key});

  @override
  State<SkinProfileSetupPage> createState() => _SkinProfileSetupPageState();
}

class _SkinProfileSetupPageState extends State<SkinProfileSetupPage> {
  final _pageController = PageController();
  int _currentStep = 0;
  final _allergiesController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      context.go(Routes.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.error != null && !state.isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.danger),
            );
          }
          if (state.isSaved) {
            context.go(Routes.home);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _prevStep,
            ),
            title: const Text('Skin profile'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'Step ${_currentStep + 1} of 3',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentStep + 1) / 3,
                backgroundColor: AppColors.skinSurfaceAlt,
                color: AppColors.skinPrimary,
                minHeight: 3,
              ),
              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _Step1SkinBasics(onContinue: _nextStep),
                    _Step2SkinDetails(
                      allergiesController: _allergiesController,
                      onContinue: _nextStep,
                    ),
                    const _Step3FirstScan(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Step 1: Skin type, concerns, age range
class _Step1SkinBasics extends StatelessWidget {
  final VoidCallback onContinue;
  const _Step1SkinBasics({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("What's your skin type?",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.skinTypes.map((type) {
                  final selected = state.skinType == type;
                  return ChoiceChip(
                    label: Text(type.capitalize),
                    selected: selected,
                    onSelected: (_) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileSkinTypeSelected(type));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Primary concerns',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.skinConcerns.map((concern) {
                  final selected = state.selectedConcerns.contains(concern);
                  return FilterChip(
                    label: Text(concern.snakeToTitle),
                    selected: selected,
                    onSelected: (_) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileConcernToggled(concern));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Age range',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: AppConstants.ageRanges.map((range) {
                  final selected = state.ageRange == range;
                  return ChoiceChip(
                    label: Text(range),
                    selected: selected,
                    onSelected: (_) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileAgeRangeSelected(range));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Step 2: Fitzpatrick scale, climate, allergies, goals
class _Step2SkinDetails extends StatelessWidget {
  final TextEditingController allergiesController;
  final VoidCallback onContinue;

  const _Step2SkinDetails({
    required this.allergiesController,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fitzpatrick skin tone',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: List.generate(6, (index) {
                  final scale = index + 1;
                  final selected = state.fitzpatrickScale == scale;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileFitzpatrickSelected(scale));
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(AppConstants.fitzpatrickColors[index]),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? AppColors.skinPrimary
                                : AppColors.skinBorder,
                            width: selected ? 2.5 : 1,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Text('Your climate',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: AppConstants.climates.map((climate) {
                  final selected = state.climate == climate;
                  return ChoiceChip(
                    label: Text(climate.capitalize),
                    selected: selected,
                    onSelected: (_) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileClimateSelected(climate));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Known allergies',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: allergiesController,
                decoration: const InputDecoration(
                  hintText: 'Fragrance, essential oils...',
                ),
                onChanged: (value) {
                  final allergies = value
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  context
                      .read<ProfileBloc>()
                      .add(ProfileAllergiesUpdated(allergies));
                },
              ),
              const SizedBox(height: 24),
              Text('Your goals',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.skinGoals.map((goal) {
                  final selected = state.selectedGoals.contains(goal);
                  return FilterChip(
                    label: Text(goal.snakeToTitle),
                    selected: selected,
                    onSelected: (_) {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileGoalToggled(goal));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Step 3: First scan prompt
class _Step3FirstScan extends StatelessWidget {
  const _Step3FirstScan();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Face guide placeholder
              Container(
                width: 150,
                height: 195,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(
                    color: AppColors.skinBorderStrong,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Face preview',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Let's take your first scan",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "We'll analyse your skin and build a personalised routine",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<ProfileBloc>().add(ProfileSaveRequested());
                        },
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Open camera'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: state.isLoading ? null : () => context.go(Routes.home),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        );
      },
    );
  }
}
