import 'package:flutter/material.dart';

class ItemPrayer extends StatelessWidget {
  const ItemPrayer({
    super.key,
    required this.label,
    required this.icon,
    required this.time,
  });

  final String label;
  final IconData icon;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary
          ),
        ),
        const SizedBox(height: 7),
        Icon(
          icon, 
          color: Theme.of(context).colorScheme.onPrimary
        ),
        const SizedBox(height: 7),
        Text(
          time,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ],
    );
  }
}
