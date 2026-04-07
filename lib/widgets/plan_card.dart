import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final List<String> features;
  final bool highlight;
  final String? planId;
  final VoidCallback? onTap;

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.features,
    this.highlight = false,
    this.planId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String displayPrice = price.startsWith('\$') ? price : "\$$price";

    return Container(
      width: 300,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: highlight ? Colors.amber : Colors.white10,
          width: highlight ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  displayPrice,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "COP / mes",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 40),
          ...features
              .where((f) => f.isNotEmpty)
              .map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        feature.contains("Sin") ||
                                feature.contains("No incluido")
                            ? Icons.block
                            : Icons.check_circle_outline,
                        color:
                            feature.contains("Sin") ||
                                feature.contains("No incluido")
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: highlight
                  ? Colors.amber
                  : const Color(0xFF009869),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: onTap,
            child: Text(
              "ELEGIR PLAN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: highlight ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
