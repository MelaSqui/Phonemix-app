import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EvaluationScreen extends StatefulWidget {
  final int childId;
  EvaluationScreen({required this.childId});

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final TextEditingController evaluationController = TextEditingController();
  bool isLoading = false;

  Future<void> sendEvaluation() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri uri = Uri.http('192.168.0.6:3000', '/specialist/evaluation');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "specialist_id": "1", // 🔹 Reemplázalo con el ID real del especialista
          "padre_id": "1",      // 🔹 Reemplázalo con el ID real del padre
          "mensaje": evaluationController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("✅ Evaluación enviada exitosamente."),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("❌ Error al enviar la evaluación."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print("❌ Error al conectar con el backend: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enviar Evaluación")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: evaluationController,
              decoration: InputDecoration(labelText: "Escribe la evaluación fonológica"),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: sendEvaluation,
                    child: Text("Enviar Evaluación"),
                  ),
          ],
        ),
      ),
    );
  }
}
