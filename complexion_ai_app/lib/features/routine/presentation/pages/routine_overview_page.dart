import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class RoutineOverviewPage extends StatefulWidget {
  const RoutineOverviewPage({super.key});
  @override
  State<RoutineOverviewPage> createState() => _RoutineOverviewPageState();
}

class _RoutineOverviewPageState extends State<RoutineOverviewPage> {
  int _selectedTab = 0;
  final _tabs = ['Morning', 'Evening', 'Weekly'];

  // Mock steps matching wireframe
  final _mockSteps = [
    _MockStep('Gentle cleanser', 'CeraVe Hydrating Cleanser', 60, true),
    _MockStep('Vitamin C serum', 'The Ordinary Vit C 23%', 30, true),
    _MockStep('Moisturiser', 'La Roche-Posay Toleriane', 30, false),
    _MockStep('Sunscreen SPF50+', 'Cancer Council Face Day Wear', 30, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My routine')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tab pills
            Row(
              children: List.generate(_tabs.length, (i) {
                final selected = _selectedTab == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected ? AppColors.skinPrimary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabs[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                        color: selected ? AppColors.skinPrimary : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            // Steps
            ...List.generate(_mockSteps.length, (i) {
              final step = _mockSteps[i];
              return _StepRow(
                title: step.title,
                product: step.product,
                duration: step.duration,
                isDone: step.isDone,
                onTap: () => setState(() => step.isDone = !step.isDone),
              );
            }),
            const Divider(height: 24),
            // AI reasoning card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
                border: const Border(left: BorderSide(color: AppColors.skinAccent, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Why this routine?', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Vit C targets your pigmentation while HA in the moisturiser addresses dehydrated cheeks. SPF is non-negotiable for Vit C use.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Regenerate routine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockStep {
  final String title;
  final String product;
  final int duration;
  bool isDone;
  _MockStep(this.title, this.product, this.duration, this.isDone);
}

class _StepRow extends StatelessWidget {
  final String title;
  final String product;
  final int duration;
  final bool isDone;
  final VoidCallback onTap;

  const _StepRow({
    required this.title,
    required this.product,
    required this.duration,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Check circle
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.successBg : Colors.transparent,
                border: Border.all(
                  color: isDone ? AppColors.success : Theme.of(context).colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: AppColors.success)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(product, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Text('${duration}s', style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
