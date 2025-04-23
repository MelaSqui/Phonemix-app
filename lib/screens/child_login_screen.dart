import 'dart:convert'; // Para manejar JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Para realizar solicitudes HTTP

class LoginNinoScreen extends StatefulWidget {
  @override
  _LoginNinoScreenState createState() => _LoginNinoScreenState();
}

class _LoginNinoScreenState extends State<LoginNinoScreen> {
  final TextEditingController pinController = TextEditingController();

  Future<void> handleChildLogin() async {
    final pin = pinController.text.trim();
    final url = Uri.parse("http://192.168.40.172:3000/auth/login-child"); // Endpoint exclusivo para niños

    if (pin.isEmpty) {
      _showErrorDialog("Por favor, ingresa tu PIN.");
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pin': pin}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Inicio de sesión exitoso: Token -> ${responseData['token']}');
        Navigator.pushReplacementNamed(context, '/child_home'); // Redirige al dashboard de niños
      } else {
        final errorData = jsonDecode(response.body);
        _showErrorDialog(errorData['message'] ?? "Error desconocido del servidor.");
      }
    } catch (e) {
      _showErrorDialog("Error en la solicitud: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.child_care, size: 80, color: Colors.blue),
                  SizedBox(height: 20),
                  Text('Acceso Niño', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 20),
                  TextField(
                    controller: pinController,
                    decoration: InputDecoration(
                      labelText: 'Ingresa tu PIN',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleChildLogin,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Entrar', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
