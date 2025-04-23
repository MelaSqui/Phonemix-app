import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecoveryScreen extends StatefulWidget {
  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  TextEditingController emailController = TextEditingController();

  // Función para recuperar la contraseña
  Future<void> recoverPassword() async {
    String email = emailController.text.trim();

    // Validación del campo de correo
    if (email.isEmpty) {
      showMessage("Por favor ingrese su correo.", Colors.red);
      return;
    }

    try {
      var url = Uri.parse("http://localhost:3000/users/recover"); // Asegúrate de usar el puerto correcto
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        showMessage("Revisa tu correo para restablecer la contraseña.", Colors.green);
      } else {
        var responseBody = jsonDecode(response.body);
        showMessage(responseBody["message"] ?? "Error al recuperar la contraseña.", Colors.red);
      }
    } catch (e) {
      showMessage("Error al conectar con el servidor. Por favor, inténtalo de nuevo.", Colors.red);
    }
  }

  // Función para mostrar mensajes
  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recuperar Contraseña"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para el correo electrónico
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Botón para enviar la solicitud de recuperación
            ElevatedButton(
              onPressed: recoverPassword,
              child: Text("Enviar Correo"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
