import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Asegúrate de importar tu pantalla de configuración
// import 'setup_riley_screen.dart';

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
  // TIP: Si usas celular físico, asegúrate de que esta IP sea la de tu PC
  final String _apiUrl =
      'http://192.168.40.7:8080/api/business/confirm-payment';

  // LIBERAR MEMORIA: Muy importante en Flutter
  @override
  void dispose() {
    _emailCtrl.dispose();
    _companyCtrl.dispose();
    _posCtrl.dispose();
    _prodCtrl.dispose();
    _addrCtrl.dispose();
    _cardNumCtrl.dispose();
    _cardExpCtrl.dispose();
    _cardCvcCtrl.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    // 1. Validación básica mejorada
    if (_emailCtrl.text.trim().isEmpty || _companyCtrl.text.trim().isEmpty) {
      _showMsg(
        "Atención",
        "El Email y el Nombre de la Empresa son obligatorios.",
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final double finalMonto = widget.monto ?? 50000.0;
      final String emailUser = _emailCtrl.text.trim().toLowerCase();
      final String nameCompany = _companyCtrl.text.trim();

      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": emailUser,
          "company": nameCompany,
          "position": _posCtrl.text.trim(),
          "sellingProduct": _prodCtrl.text.trim(),
          "address": _addrCtrl.text.trim(),
          "paymentId": "PAY-${DateTime.now().millisecondsSinceEpoch}",
          "minutes":
              finalMonto / 1000.0, // Regla de negocio: 1 min x cada $1000
          "amount": finalMonto,
        }),
      );

      if (!mounted) return;
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // --- CAMBIO CLAVE: NAVEGACIÓN ---
        _showMsg(
          "¡Éxito!",
          "Pago procesado para $nameCompany.",
          success: true,
          onConfirm: () {
            // Reemplazamos la pantalla actual por la de configuración de archivos
            /* Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SetupRileyScreen(
                  businessId: emailUser,
                  businessName: nameCompany,
                ),
              ),
            );
            */
          },
        );
      } else {
        _showMsg("Error", data['message'] ?? "Error en el servidor");
      }
    } catch (e) {
      _showMsg(
        "Error",
        "No se pudo conectar con el servidor (192.168.40.7). Verifique que el backend esté corriendo.",
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fondo Degradado Genzai Style
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
                    _input(
                      Icons.email,
                      "Email del negocio",
                      _emailCtrl,
                      type: TextInputType.emailAddress,
                    ),
                    _input(
                      Icons.business,
                      "Nombre de la Empresa (Ej: Autos Cali)",
                      _companyCtrl,
                    ),
                    _input(Icons.work, "Tu Cargo", _posCtrl),
                    _input(
                      Icons.shopping_bag,
                      "¿Qué producto vendes?",
                      _prodCtrl,
                    ),
                    _input(Icons.location_on, "Dirección física", _addrCtrl),
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

  // --- WIDGETS DE APOYO ---

  Widget _input(
    IconData i,
    String h,
    TextEditingController c, {
    List<TextInputFormatter>? f,
    TextInputType? type,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextField(
      controller: c,
      inputFormatters: f,
      keyboardType: type,
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
        "Número de Tarjeta",
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

  void _showMsg(
    String t,
    String c, {
    bool success = false,
    VoidCallback? onConfirm,
  }) => showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1B263B),
      title: Text(t, style: const TextStyle(color: Colors.white)),
      content: Text(c, style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            if (onConfirm != null) onConfirm();
          },
          child: const Text("OK", style: TextStyle(color: Colors.amber)),
        ),
      ],
    ),
  );
}

// Formateador de fecha MM/AA
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
