import 'package:flutter/material.dart';
import 'package:genzai_web/widgets/navbar.dart';
import 'package:genzai_web/widgets/feature_section.dart';
import 'package:genzai_web/widgets/plan_card.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011627),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;
          return SingleChildScrollView(
            child: Column(
              children: [
                CustomNavbar(isMobile: isMobile),
                _buildHero(isMobile),
                _buildFeaturesSection(),
                _buildPricingSection(),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHero(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 120,
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF025192), Color(0xFF009869)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Agentes de IA que transforman tu Negocio",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 32 : 55,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          const Text(
            "Automatiza ventas por WhatsApp y genera tu propia APK personalizada.",
            style: TextStyle(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.white,
      child: const Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: [
          FeatureCard(
            title: "Atención 24/7",
            desc: "IA que nunca duerme.",
            icon: Icons.auto_awesome,
          ),
          FeatureCard(
            title: "WhatsApp API",
            desc: "Conexión directa.",
            icon: Icons.chat_outlined,
          ),
          FeatureCard(
            title: "App Propia",
            desc: "APK personalizada.",
            icon: Icons.android_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    final List<Map<String, dynamic>> planes = [
      {
        "name": "Riley Start",
        "price": "150k",
        "desc": "Empezar a Escalar",
        "features": [
          "WhatsApp API",
          "1.000 Leads",
          "Citas Manuales",
          "30 Minutos Voz",
          "Soporte Chat",
        ],
      },
      {
        "name": "Riley Business",
        "price": "265k",
        "desc": "Organizar mi Negocio",
        "highlight": true,
        "features": [
          "WhatsApp API",
          "10.000 Leads",
          "Citas Automáticas",
          "30 Minutos Voz",
          "Soporte VIP 1 a 1",
        ],
      },
      {
        "name": "Riley Pro",
        "price": "395k",
        "desc": "Cerrar como Élite",
        "features": [
          "WhatsApp API",
          "3.000 Leads",
          "Citas Automáticas",
          "300 Minutos Voz",
          "Soporte Prioritario",
        ],
      },
      {
        "name": "Riley Premium", // Cambiado de Enterprise a Premium
        "price": "550k",
        "desc": "Ser Vendedor Supremo",
        "features": [
          "WhatsApp API",
          "Leads Ilimitados",
          "Prioridad Total",
          "500 Minutos Voz",
          "Protocolo Fortress",
        ],
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Nuestros Planes",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: planes
                .map(
                  (p) => PlanCard(
                    name: p['name'],
                    price: p['price'],
                    description: p['desc'],
                    features: List<String>.from(p['features']),
                    highlight: p['highlight'] ?? false,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Text(
          "© 2026 Genzai AI - Innovación en Agentes de IA",
          style: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }
}
