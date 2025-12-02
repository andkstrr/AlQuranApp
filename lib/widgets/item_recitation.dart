import 'package:flutter/material.dart';

class ItemRecitation extends StatelessWidget {
  const ItemRecitation({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.channel,
    required this.views,
    required this.time,
  });

  final String imageUrl;
  final String title;
  final String channel;
  final String views;
  final String time;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // batas lebar untuk title wrapping
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            channel,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                views,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(width: 5),
              Text(
                '•',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(width: 5),
              Text(
                time,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
