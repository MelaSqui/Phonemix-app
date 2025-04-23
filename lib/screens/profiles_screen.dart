import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'view_report_screen.dart';

class ProfilesScreen extends StatefulWidget {
  final String specialistId;

  ProfilesScreen({required this.specialistId});

  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  bool isLoading = true;
  List<dynamic> parentsData = [];

  @override
  void initState() {
    super.initState();
    _fetchParentsData();
  }

  Future<void> _fetchParentsData() async {
    try {
      Uri uri = Uri.http('192.168.0.6:3000', '/specialist/parents');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          parentsData = jsonDecode(response.body);
          isLoading = false;
        });
        print("✅ Padres obtenidos: $parentsData");
      } else {
        print("❌ Error al obtener los datos. Código: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error de conexión con el backend: $e");
    }
  }

  void _showChildrenModal(BuildContext context, Map<String, dynamic> child) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Información de ${child['nombre']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Última conexión: ${child['ultimaConexion']}'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewReportScreen(ninoId: child["id"]),
                  ),
                );
              },
              child: Text('Ver Reporte'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfiles'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: parentsData.length,
                itemBuilder: (context, index) {
                  final parent = parentsData[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parent['nombre'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('Correo: ${parent['email']}'),
                          SizedBox(height: 10),
                          Text('Niños registrados:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: parent['children']
                                .map<Widget>((child) => ListTile(
                                      title: Text(child['nombre']),
                                      subtitle: Text('Última conexión: ${child['ultimaConexion']}'),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        _showChildrenModal(context, child);
                                      },
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
