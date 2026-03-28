import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final List<String> features;
  final bool highlight;

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.features,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // Quitamos el Spacer y manejamos el tamaño con Padding y constraints
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
        mainAxisSize: MainAxisSize.min, // Importante: ajustarse al contenido
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "\$$price",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "COP / mes",
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 40),

          // Lista de beneficios
          ...features
              .map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        feature.contains("Sin")
                            ? Icons.block
                            : Icons.check_circle_outline,
                        color: feature.contains("Sin")
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
              )
              .toList(),

          const SizedBox(height: 30), // Espacio fijo en lugar de Spacer

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: highlight
                  ? Colors.amber
                  : const Color(0xFF009869),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () =>
                Navigator.pushNamed(context, '/pago', arguments: name),
            child: Text(
              "ELEGIR PLAN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: highlight ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
