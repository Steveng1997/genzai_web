import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _methodIcon(Icons.credit_card, 'Tarjeta'),
                      _methodIcon(Icons.account_balance, 'PSE'),
                      _methodIcon(Icons.payments, 'Efectivo'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildCurrentForm(),
                  ),
                  const SizedBox(height: 40),
                  _buildPayButton(context),
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
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            method,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentForm() {
    if (selectedMethod == 'Tarjeta') {
      return Column(
        key: const ValueKey('c'),
        children: [
          _inputField(
            Icons.credit_card,
            "Número de Tarjeta",
            limit: 16,
            type: TextInputType.number,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              // FECHA: Aquí está el cambio clave
              Expanded(
                child: _inputField(
                  Icons.calendar_today,
                  "MM/AA",
                  limit: 5, // 5 caracteres totales: 12/26
                  isDate: true,
                  type: TextInputType.number,
                ),
              ),
              const SizedBox(width: 15),
              // CVC: Máximo 3 números
              Expanded(
                child: _inputField(
                  Icons.lock_outline,
                  "CVC",
                  limit: 3,
                  type: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (selectedMethod == 'PSE') {
      return _inputField(
        Icons.account_balance,
        "Nombre del Banco / Nequi",
        key: const ValueKey('p'),
      );
    }
    return const Text(
      "Recibirás un PIN para pagar en Efecty.",
      style: TextStyle(color: Colors.white70),
      key: ValueKey('e'),
    );
  }

  Widget _inputField(
    IconData icon,
    String hint, {
    Key? key,
    int? limit,
    bool isDate = false,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      key: key,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      inputFormatters: [
        if (limit != null) LengthLimitingTextInputFormatter(limit),
        if (isDate) _DateFormatter(),
        if (type == TextInputType.number && !isDate)
          FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white54, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AF37),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: () => _showSuccessDialog(context),
      child: const Text(
        "FINALIZAR PROCESO",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
          "Procesando tu solicitud para Genzai AI.",
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

// 2. FORMATEADOR DE FECHA MEJORADO
class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = newValue.text;

    // Si el usuario está borrando, permitimos la acción sin cambios
    if (oldValue.text.length > newText.length) {
      return newValue;
    }

    // Solo permitir números y el slash
    final regExp = RegExp(r'^[0-9/]*$');
    if (!regExp.hasMatch(newText)) return oldValue;

    // Lógica de auto-slash
    if (newText.length == 2 && !newText.contains('/')) {
      newText += '/';
    } else if (newText.length == 3 && !newText.contains('/')) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
