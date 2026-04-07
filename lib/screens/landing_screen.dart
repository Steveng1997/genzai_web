import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:genzai_web/widgets/navbar.dart';
import 'package:genzai_web/widgets/feature_section.dart'; // Asegúrate que este sea el nombre correcto
import 'package:genzai_web/widgets/plan_card.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<dynamic> _planesDynamic = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    try {
      final response = await http.get(
        Uri.parse('https://fn5q3yfyrc.us-east-1.awsapprunner.com/api/plan'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _planesDynamic = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error cargando planes: $e");
      setState(() => _isLoading = false);
    }
  }

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
                _buildPricingSection(), // Aquí se cargan los datos de AWS
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
          _isLoading
              ? const CircularProgressIndicator(color: Color(0xFF009869))
              : Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: _planesDynamic.map((p) {
                    // Formateamos el precio de DynamoDB (ej: 200 -> 200k o lo que prefieras)
                    final double priceVal =
                        double.tryParse(p['price'].toString()) ?? 0;
                    String displayPrice = priceVal >= 1000
                        ? "${(priceVal / 1000).toStringAsFixed(0)}k"
                        : priceVal.toStringAsFixed(0);

                    return PlanCard(
                      name: p['title'] ?? 'Plan',
                      price: displayPrice,
                      description: "IA Agents",
                      features: [
                        p['whatsappApi']?.toString() ?? 'WhatsApp API',
                        "${p['leads'] ?? '0'} Leads",
                        "${p['minutes'] ?? '0'} Minutos Voz",
                        p['support']?.toString() ?? 'Soporte',
                      ],
                      highlight: p['planId'].toString().toLowerCase().contains(
                        'business',
                      ),
                      onTap: () {
                        // Enviamos el objeto p (que incluye el planId real)
                        Navigator.pushNamed(context, '/pago', arguments: p);
                      },
                    );
                  }).toList(),
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
