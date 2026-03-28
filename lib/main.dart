import 'package:flutter/material.dart';
import 'package:genzai_web/screens/landing_screen.dart';
import 'package:genzai_web/screens/payment_screen.dart';

void main() {
  runApp(const GenzaiWeb());
}

class GenzaiWeb extends StatelessWidget {
  const GenzaiWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Genzai AI Agents',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/pago': (context) => const PaymentScreen(),
      },
    );
  }
}
