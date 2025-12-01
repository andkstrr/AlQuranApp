import 'package:flutter/material.dart';

class ItemFeature extends StatelessWidget {
  const ItemFeature({super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label
        ),
      ],
    );
  }
}
