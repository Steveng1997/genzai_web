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
                _buildFeaturesSection(isMobile),
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
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
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
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.white,
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: const [
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
            children: const [
              PlanCard(
                name: "Riley Start",
                price: "150k",
                description:
                    "Para emprendedores que están dando sus primeros pasos.",
              ),
              PlanCard(
                name: "Riley Business",
                price: "265k",
                description:
                    "Automatización completa para negocios con flujo constante.",
                highlight: true,
              ),
              PlanCard(
                name: "Riley Pro",
                price: "395k",
                description: "IA avanzada, reportes detallados y soporte VIP.",
              ),
              PlanCard(
                name: "Riley Enterprise",
                price: "550k",
                description:
                    "Escala masiva, API dedicada y máxima prioridad para tu empresa.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      // Corrección del borde usando BoxDecoration
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: const Center(
        child: Text(
          "© 2026 Genzai AI - Innovación en Agentes de IA",
          style: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }
}
