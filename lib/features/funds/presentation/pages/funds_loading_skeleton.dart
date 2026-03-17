import 'package:flutter/material.dart';

class FundsLoadingSkeleton extends StatelessWidget {
  const FundsLoadingSkeleton({super.key});

  Widget _skeletonCard(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 18, width: 160, color: color),
            const SizedBox(height: 8),
            Container(height: 14, width: 250, color: color),
            const SizedBox(height: 12),
            Row(
              children: [Expanded(child: Container(height: 14, color: color))],
            ),
            const SizedBox(height: 12),
            Row(
              children: [Expanded(child: Container(height: 40, color: color))],
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceHeaderSkeleton(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 14, width: 124, color: color),
          const SizedBox(height: 4),
          Container(height: 28, width: 160, color: color),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _balanceHeaderSkeleton(context),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) => _skeletonCard(context),
          ),
        ),
      ],
    );
  }
}
