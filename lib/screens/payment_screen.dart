import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'Tarjeta';
  bool isLoading = false;

  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _posCtrl = TextEditingController();
  final _prodCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();

  final _cardNumCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cvcCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _companyCtrl.dispose();
    _posCtrl.dispose();
    _prodCtrl.dispose();
    _addrCtrl.dispose();
    _cardNumCtrl.dispose();
    _dateCtrl.dispose();
    _cvcCtrl.dispose();
    super.dispose();
  }

  Future<void> _processPayment(Map<String, dynamic> planData) async {
    if (_emailCtrl.text.trim().isEmpty || _companyCtrl.text.trim().isEmpty) {
      _showMsg("Atención", "Email y Empresa son obligatorios.");
      return;
    }

    setState(() => isLoading = true);

    try {
      String cleanPrice = planData['price'].toString().replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      int finalAmount = int.tryParse(cleanPrice) ?? 0;

      if (finalAmount <= 0) {
        throw Exception("El monto calculado es inválido");
      }

      final String generatedTenantId =
          "TEN-${DateTime.now().millisecondsSinceEpoch}";

      final Map<String, dynamic> requestBody = {
        "tenantId": generatedTenantId,
        "paymentId": "PAY-${DateTime.now().millisecondsSinceEpoch}",
        "email": _emailCtrl.text.trim().toLowerCase(),
        "company": _companyCtrl.text.trim(),
        "position": _posCtrl.text.trim(),
        "sellingProduct": _prodCtrl.text.trim(),
        "address": _addrCtrl.text.trim(),
        "amount": finalAmount,
        "planId": planData['planId'],
        "minutesPurchased": finalAmount,
        "paymentDate": DateTime.now().toUtc().toIso8601String(),
        "expirationDate": DateTime.now()
            .toUtc()
            .add(const Duration(days: 30))
            .toIso8601String(),
      };

      final res = await http.post(
        Uri.parse(
          'https://fn5q3yfyrc.us-east-1.awsapprunner.com/api/business/confirm-payment',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showMsg(
          "¡Éxito!",
          "Pago registrado. Tu ID de Empresa es: $generatedTenantId",
          success: true,
        );
      } else {
        final errorResponse = jsonDecode(res.body);
        _showMsg(
          "Error de Servidor",
          errorResponse['message'] ?? "Error desconocido",
        );
      }
    } catch (e) {
      _showMsg("Error de Proceso", "No se pudo procesar el pago: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    if (args == null)
      return const Scaffold(body: Center(child: Text("Error al cargar plan")));
    final planData = args as Map<String, dynamic>;

    return Scaffold(
      body: Stack(
        children: [
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
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    Text(
                      "Pago: ${planData['title']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Total: \$${planData['price']} COP",
                      style: const TextStyle(
                        color: Color(0xFFE9B949),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _input(Icons.email, "Email del negocio", _emailCtrl),
                    _input(
                      Icons.business,
                      "Nombre de la Empresa",
                      _companyCtrl,
                    ),
                    _input(Icons.work, "Tu Cargo", _posCtrl),
                    _input(
                      Icons.shopping_bag,
                      "¿Qué producto vendes?",
                      _prodCtrl,
                    ),
                    _input(Icons.location_on, "Dirección física", _addrCtrl),
                    const Divider(color: Colors.white24, height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _payIcon("Tarjeta", Icons.credit_card),
                        _payIcon("PSE", Icons.account_balance),
                        _payIcon("Efectivo", Icons.payments),
                      ],
                    ),
                    const SizedBox(height: 25),
                    if (selectedMethod == "Tarjeta") ...[
                      _input(
                        Icons.credit_card,
                        "Número de Tarjeta",
                        _cardNumCtrl,
                        isNum: true,
                        limit: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _input(
                              Icons.calendar_today,
                              "MM/AA",
                              _dateCtrl,
                              isNum: true,
                              isDate: true,
                              limit: 5,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _input(
                              Icons.lock,
                              "CVC",
                              _cvcCtrl,
                              isNum: true,
                              limit: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 25),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFFE9B949),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE9B949),
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () => _processPayment(planData),
                            child: const Text(
                              "FINALIZAR PAGO",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
    bool isNum = false,
    bool isDate = false,
    int? limit,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (isNum && !isDate) FilteringTextInputFormatter.digitsOnly,
        if (limit != null) LengthLimitingTextInputFormatter(limit),
        if (isDate) _DateMaskFormatter(),
      ],
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(i, color: Colors.white70),
        hintText: h,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _payIcon(String label, IconData icon) {
    bool active = selectedMethod == label;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = label),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFE9B949) : Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: active ? Colors.black : Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFFE9B949) : Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

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
            if (success) Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

class _DateMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldV,
    TextEditingValue newV,
  ) {
    var text = newV.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4) text = text.substring(0, 4);
    var out = "";
    for (var i = 0; i < text.length; i++) {
      out += text[i];
      if (i == 1 && text.length > 2) out += "/";
    }
    return TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: out.length),
    );
  }
}
