import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewReportScreen extends StatefulWidget {
  final int ninoId;

  ViewReportScreen({required this.ninoId});

  @override
  _ViewReportScreenState createState() => _ViewReportScreenState();
}

class _ViewReportScreenState extends State<ViewReportScreen> {
  bool isLoading = true;
  Map<String, dynamic>? reportData;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    try {
      Uri uri = Uri.http('192.168.0.6:3000', '/specialist/child-report', {'nino_id': widget.ninoId.toString()});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          reportData = jsonDecode(response.body);
          isLoading = false;
        });
        print("✅ Reporte obtenido: $reportData");
      } else {
        print("❌ Error al obtener el reporte. Código: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error de conexión con el backend: $e");
    }
  }

  void _downloadCertificate() {
    if (reportData?["certificado"] != null) {
      print("📥 Descargando certificado: ${reportData!["certificado"]}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Descargando certificado...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay certificado disponible.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reporte del Niño")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("📊 Progreso", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(reportData?["progreso_json"] ?? "No disponible"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _downloadCertificate,
                    child: Text("Descargar Certificado"),
                  ),
                ],
              ),
            ),
    );
  }
}
