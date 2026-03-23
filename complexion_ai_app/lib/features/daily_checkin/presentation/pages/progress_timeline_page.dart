import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class ProgressTimelinePage extends StatelessWidget {
  const ProgressTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Column(
        children: [
          // Streak card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.skinPrimaryBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text('12', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.skinPrimary)),
                    Text('day streak', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          // Timeline entries
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _TimelineEntry(date: 'Today', feeling: 'good', note: 'Skin feels hydrated', color: AppColors.success),
                _TimelineEntry(date: 'Yesterday', feeling: 'great', note: 'Clear skin, no breakouts', color: AppColors.skinPrimary),
                _TimelineEntry(date: '2 days ago', feeling: 'okay', note: 'Minor redness on cheeks', color: AppColors.warning),
                _TimelineEntry(date: '3 days ago', feeling: 'good', note: 'Texture improving', color: AppColors.success),
                _TimelineEntry(date: '4 days ago', feeling: 'bad', note: 'New breakout on chin', color: AppColors.danger),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final String date;
  final String feeling;
  final String note;
  final Color color;

  const _TimelineEntry({
    required this.date,
    required this.feeling,
    required this.note,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(date, style: Theme.of(context).textTheme.labelMedium),
                      Text(feeling, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(note, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
