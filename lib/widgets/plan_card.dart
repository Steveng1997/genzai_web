import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final bool highlight;

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        // Color oscuro profundo para resaltar el estilo tech
        color: const Color(0xFF1B263B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? Colors.amber : Colors.white10,
          width: highlight ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Evita el error de altura infinita
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "\$$price",
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 35,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            "COP / mes",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 25),
          // Altura fija para la descripción para mantener simetría
          SizedBox(
            height: 80,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: highlight
                  ? Colors.amber
                  : const Color(0xFF009869),
              minimumSize: const Size(double.infinity, 50),
              shape: const StadiumBorder(),
              elevation: highlight ? 5 : 0,
            ),
            onPressed: () {
              // Navegación a la pantalla de pago que ya tienes creada
              Navigator.pushNamed(context, '/pago', arguments: name);
            },
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
