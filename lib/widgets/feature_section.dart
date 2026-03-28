import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.desc,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF025192), size: 40),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF011627),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.3),
          ),
        ],
      ),
    );
  }
}
