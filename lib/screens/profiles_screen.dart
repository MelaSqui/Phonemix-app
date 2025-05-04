import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'view_report_screen.dart';

class ProfilesScreen extends StatefulWidget {
  final int specialistId;

  ProfilesScreen({required this.specialistId});

  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  bool isLoading = true;
  List<dynamic> usersData = [];

  @override
  void initState() {
    super.initState();
    _fetchUsersData();
  }

  Future<void> _fetchUsersData() async {
    try {
      Uri uri = Uri.http('192.168.0.6:3000', '/specialist/users?specialist_id=${widget.specialistId}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          usersData = jsonDecode(response.body);
          isLoading = false;
        });
        print("✅ Usuarios obtenidos: $usersData");
      } else {
        print("❌ Error al obtener usuarios. Código: ${response.statusCode}");
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
            Text('Última conexión: ${child['ultima_conexion']}'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewReportScreen(ninoId: child["id"]), // 🔥 Redirección al reporte
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
      appBar: AppBar(title: Text('Perfiles')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                final user = usersData[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['user_name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("Correo: ${user['user_email']}"),
                        SizedBox(height: 10),
                        Text("Niños registrados:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Column(
                          children: (user['children'] as List<dynamic>)
                              .map<Widget>((child) => ListTile(
                                    title: Text(child['nombre']),
                                    subtitle: Text('Última conexión: ${child['ultima_conexion']}'),
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
    );
  }
}
