import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(child: Icon(Icons.image_outlined, size: 48, color: AppColors.skinTextTertiary)),
            ),
            const SizedBox(height: 16),
            Text('CeraVe Hydrating Cleanser', style: Theme.of(context).textTheme.headlineSmall),
            Text('CeraVe', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text('\$18.99 AUD', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.skinPrimary)),
            const SizedBox(height: 16),
            Text('Key ingredients', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Ceramides', 'Hyaluronic Acid', 'Glycerin']
                  .map((i) => Chip(label: Text(i)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.skinPrimaryBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.skinPrimary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Great for your combination skin and dehydration concerns',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.skinPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Buy now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
