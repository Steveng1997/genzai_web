import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String? plan;

  const PaymentScreen({super.key, this.plan});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'Tarjeta';

  @override
  Widget build(BuildContext context) {
    // Recupera el nombre del plan desde los argumentos o el constructor
    final String planName =
        widget.plan ??
        (ModalRoute.of(context)?.settings.arguments as String? ??
            "Plan Seleccionado");

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF025192), Color(0xFF009869)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pago: $planName",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Selecciona tu método de pago preferido",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 35),

                  // SELECTOR DE MÉTODOS (Iconos)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _methodIcon(Icons.credit_card, 'Tarjeta'),
                      _methodIcon(Icons.account_balance, 'PSE'),
                      _methodIcon(Icons.payments, 'Efectivo'),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // FORMULARIO DINÁMICO SEGÚN SELECCIÓN
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildCurrentForm(),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () {
                      // AQUÍ LÓGICA: Procesar pago -> Generar ID de Compra -> Descargar APK
                      _showSuccessDialog(context);
                    },
                    child: const Text(
                      "PROCESAR PAGO",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Volver a planes",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _methodIcon(IconData icon, String method) {
    bool isSelected = selectedMethod == method;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = method),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            method,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentForm() {
    switch (selectedMethod) {
      case 'Tarjeta':
        return _buildCardForm();
      case 'PSE':
        return _buildPSEForm();
      case 'Efectivo':
        return _buildCashForm();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCardForm() {
    return Column(
      key: const ValueKey('card'),
      children: [
        _inputField(Icons.credit_card, "Número de Tarjeta"),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _inputField(Icons.calendar_today, "MM/AA")),
            const SizedBox(width: 15),
            Expanded(child: _inputField(Icons.lock_outline, "CVV")),
          ],
        ),
      ],
    );
  }

  Widget _buildPSEForm() {
    return Column(
      key: const ValueKey('pse'),
      children: [
        _inputField(Icons.person_outline, "Nombre del Titular"),
        const SizedBox(height: 15),
        _inputField(Icons.badge_outlined, "Cédula / NIT"),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF1B263B),
            hint: const Text(
              "Selecciona tu Banco",
              style: TextStyle(color: Colors.white38),
            ),
            style: const TextStyle(color: Colors.white),
            items: [
              "Bancolombia",
              "Nequi",
              "Daviplata",
              "Banco de Bogotá",
              "BBVA",
            ].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
            onChanged: (val) {},
          ),
        ),
      ],
    );
  }

  Widget _buildCashForm() {
    return Container(
      key: const ValueKey('cash'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        "Al confirmar, recibirás un PIN para pagar en puntos Efecty o SuRed. La APK se habilitará tras la validación del convenio.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
      ),
    );
  }

  Widget _inputField(IconData icon, String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white54, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text(
          "¡Pago Exitoso!",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Tu ID de compra es: GZ-99283.\nIniciando descarga de tu APK personalizada...",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
}
