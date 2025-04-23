import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage_helper.dart'; // 🔹 Asegúrate de importar StorageHelper

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final url = Uri.parse("http://192.168.40.172:3000/auth/login"); // Cambia localhost por la IP del backend

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Por favor, complete todos los campos.");
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Inicio de sesión exitoso: Token -> ${responseData['token']}');

        // 🔹 Guardar el padre_id en StorageHelper
        if (responseData.containsKey('padre_id')) {
          String parentId = responseData["padre_id"].toString(); // Asegura que es String
          await StorageHelper.saveParentId(parentId);
          print("✅ Parent ID guardado correctamente: $parentId");
        } else {
          print("❌ Error: No se encontró `padre_id` en la respuesta.");
        }

        // 🔹 Verifica el tipo de usuario devuelto por el backend
        final userType = responseData['type'];
        if (userType == 'usuario') {
          Navigator.pushReplacementNamed(context, '/father_home'); // Ruta para usuarios
        } else if (userType == 'especialista') {
          Navigator.pushReplacementNamed(context, '/specialist_dashboard'); // Ruta para especialistas
        } else {
          _showErrorDialog("Tipo de usuario desconocido: $userType.");
        }
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
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
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
                    Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                    SizedBox(height: 20),
                    Text('Iniciar Sesión', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/child_login');
                      },
                      child: Text(
                        '¿Eres un niño? Haz clic aquí para acceder.',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
