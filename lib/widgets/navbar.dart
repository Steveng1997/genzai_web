import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final bool isMobile;
  const CustomNavbar({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 50,
        vertical: 20,
      ),
      child: Row(
        children: [
          const Text(
            "GENZAI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            TextButton(
              onPressed: () {},
              child: const Text(
                "Soluciones",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(width: 20),
          ],
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009869),
              shape: const StadiumBorder(),
            ),
            onPressed: () => Navigator.pushNamed(context, '/pago'),
            child: const Text("PROBAR AHORA"),
          ),
        ],
      ),
    );
  }
}
