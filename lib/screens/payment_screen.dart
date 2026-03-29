import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final String? plan;
  final double? monto;
  const PaymentScreen({super.key, this.plan, this.monto});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'Tarjeta';
  bool isLoading = false;

  // Controladores de Texto
  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _posCtrl = TextEditingController();
  final _prodCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();

  final _cardNumCtrl = TextEditingController();
  final _cardExpCtrl = TextEditingController();
  final _cardCvcCtrl = TextEditingController();

  // Configuración de API
  final String _apiUrl =
      'http://192.168.40.7:8080/api/business/confirm-payment';

  Future<void> _processPayment() async {
    // Validación básica
    if (_emailCtrl.text.isEmpty || _companyCtrl.text.isEmpty) {
      _showMsg("Atención", "Email y Empresa son obligatorios.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final double finalMonto = widget.monto ?? 50000.0;

      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _emailCtrl.text.trim().toLowerCase(),
          "company": _companyCtrl.text.trim(),
          "position": _posCtrl.text.trim(),
          "sellingProduct": _prodCtrl.text.trim(),
          "address": _addrCtrl.text.trim(),
          "paymentId": "PAY-${DateTime.now().millisecondsSinceEpoch}",
          // Sincronizado con Backend: availableMinutes y amount
          "minutes": finalMonto / 1000.0,
          "amount": finalMonto,
        }),
      );

      if (!mounted) return;
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        _showMsg(
          "¡Éxito!",
          "Pago procesado. Regresa a la App para activar tu perfil.",
          success: true,
        );
      } else {
        _showMsg("Error", data['message'] ?? "Error en el servidor");
      }
    } catch (e) {
      _showMsg("Error", "No se pudo conectar con el servidor (192.168.40.7).");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Color de respaldo
      body: Stack(
        children: [
          // Fondo Degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF025192), Color(0xFF009869)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Pago: Riley Business",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _input(Icons.email, "Email", _emailCtrl),
                    _input(Icons.business, "Empresa", _companyCtrl),
                    _input(Icons.work, "Cargo", _posCtrl),
                    _input(Icons.shopping_bag, "¿Qué vendes?", _prodCtrl),
                    _input(Icons.location_on, "Dirección", _addrCtrl),
                    const Divider(height: 30, color: Colors.white24),
                    _buildMethods(),
                    const SizedBox(height: 15),
                    if (selectedMethod == 'Tarjeta') _buildCardFields(),
                    const SizedBox(height: 25),
                    _btn(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    IconData i,
    String h,
    TextEditingController c, {
    List<TextInputFormatter>? f,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextField(
      controller: c,
      inputFormatters: f,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        prefixIcon: Icon(i, color: Colors.white54, size: 16),
        hintText: h,
        hintStyle: const TextStyle(color: Colors.white30),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _buildMethods() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: ['Tarjeta', 'PSE', 'Efectivo'].map((m) {
      bool isS = selectedMethod == m;
      return GestureDetector(
        onTap: () => setState(() => selectedMethod = m),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isS ? Colors.amber : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isS ? Icons.check_circle : Icons.payment,
                color: isS ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              m,
              style: TextStyle(
                color: isS ? Colors.amber : Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );

  Widget _buildCardFields() => Column(
    children: [
      _input(
        Icons.credit_card,
        "Número (16 dígitos)",
        _cardNumCtrl,
        f: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _input(
              Icons.date_range,
              "MM/AA",
              _cardExpCtrl,
              f: [_DateFormatter()],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _input(
              Icons.lock,
              "CVC",
              _cardCvcCtrl,
              f: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  Widget _btn() => isLoading
      ? const CircularProgressIndicator(color: Colors.amber)
      : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _processPayment,
          child: const Text(
            "FINALIZAR PAGO",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        );

  void _showMsg(String t, String c, {bool success = false}) => showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1B263B),
      title: Text(t, style: const TextStyle(color: Colors.white)),
      content: Text(c, style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            if (success)
              Navigator.pop(
                context,
              ); // Cierra la pantalla de pago al tener éxito
          },
          child: const Text("OK", style: TextStyle(color: Colors.amber)),
        ),
      ],
    ),
  );
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) {
    var s = n.text.replaceAll('/', '');
    if (s.length > 4) return o;
    var b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      b.write(s[i]);
      if (i == 1 && s.length > 2) b.write('/');
    }
    return n.copyWith(
      text: b.toString(),
      selection: TextSelection.collapsed(offset: b.length),
    );
  }
}
