import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/storage_helper.dart';

class FatherHomeScreen extends StatefulWidget {
  @override
  _FatherHomeScreenState createState() => _FatherHomeScreenState();
}

class _FatherHomeScreenState extends State<FatherHomeScreen> {
  bool isLoading = true;
  List<dynamic> childrenData = [];
  List<dynamic> recentMessages = [];
  String? parentId;

  @override
  void initState() {
    super.initState();
    _loadParentId();
  }

  Future<void> _loadParentId() async {
    String? storedParentId = await StorageHelper.getParentId();
    print("Valor guardado en StorageHelper: $storedParentId");

    if (storedParentId != null) {
      setState(() {
        parentId = storedParentId;
      });
      _fetchData();
    } else {
      print("Error: No se encontró el ID del padre en StorageHelper.");
    }
  }

  Future<void> _fetchData() async {
    if (parentId == null) {
      print("Error: No hay un parentId válido.");
      return;
    }

    try {
      Uri uriChildren = Uri.http('192.168.0.6:3000', '/control-parental/children', {'padre_id': parentId});
      Uri uriMessages = Uri.http('192.168.0.6:3000', '/control-parental/mensajes-especialista', {'padre_id': parentId});

      final childrenResponse = await http.get(uriChildren);
      final messagesResponse = await http.get(uriMessages);
      print("🔹 Respuesta del backend en Flutter: ${childrenResponse.body}");


      print("Solicitud enviada con padre_id: $parentId");

      if (childrenResponse.statusCode == 200 && messagesResponse.statusCode == 200) {
        setState(() {
          childrenData = jsonDecode(childrenResponse.body);
          recentMessages = jsonDecode(messagesResponse.body);
          isLoading = false;
        });
      } else {
        print("Error al obtener los datos. Código: ${childrenResponse.statusCode}");
      }
    } catch (e) {
      print("Error de conexión con el backend: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Control Parental', style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecentMessages(),
                  SizedBox(height: 20),
                  Text('👶 Niños registrados',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildChildrenList(),
                ],
              ),
            ),
    );
  }

  Widget _buildRecentMessages() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✉️ Mensajes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Column(
              children: recentMessages.map((msg) => ListTile(
                    leading: Icon(Icons.volume_up, color: Colors.blue),
                    title: Text(msg["mensaje"]), 
                    subtitle: Text("Fecha: ${msg["fecha"]}"),
                  )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenList() {
    return Column(
      children: childrenData.map((child) {
        return Card(
          elevation: 5,
          child: ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text("Niño ID: ${child["child_id"]}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Niño ID: ${child["child_id"] ?? "Sin ID"}"),
                Text("Progreso: ${child["progress"] ?? 0} minutos"),
                Text("Hora permitida: ${child["hora_inicio"] ?? "No definida"} - ${child["hora_fin"] ?? "No definida"}"),
                Text("Activo: ${(child["activo"] ?? false) ? "Sí" : "No"}"),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }
}
