import 'package:flutter/material.dart';

class ItemFeature extends StatelessWidget {
  const ItemFeature({
    super.key,
    required this.routeName,
    required this.icon,
    required this.label,
  });

  final String routeName;
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
            onPressed: () {
              Navigator.pushNamed(context, routeName);
            }, 
            icon: Icon(
              icon,
              size: 28,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 13)),
      ],
    );
  }
}
