import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profiles_screen.dart';
import 'view_report_screen.dart';

class SpecialistDashboardScreen extends StatefulWidget {
  final String specialistId;

  SpecialistDashboardScreen({required this.specialistId});

  @override
  _SpecialistDashboardScreenState createState() => _SpecialistDashboardScreenState();
}

class _SpecialistDashboardScreenState extends State<SpecialistDashboardScreen> {
  bool isLoading = true;
  int childrenCount = 0;
  double averageProgress = 0;
  int completedActivities = 0;
  List<dynamic> assignedChildren = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      Uri uriStats = Uri.http('192.168.0.6:3000', '/specialist/stats', {'specialist_id': widget.specialistId});
      Uri uriChildren = Uri.http('192.168.0.6:3000', '/specialist/children', {'specialist_id': widget.specialistId});

      final statsResponse = await http.get(uriStats);
      final childrenResponse = await http.get(uriChildren);

      if (statsResponse.statusCode == 200 && childrenResponse.statusCode == 200) {
        final statsData = jsonDecode(statsResponse.body);
        final childrenData = jsonDecode(childrenResponse.body);

        setState(() {
          childrenCount = statsData["children_count"] ?? 0;
          averageProgress = statsData["average_progress"] ?? 0.0;
          completedActivities = statsData["completed_activities"] ?? 0;
          assignedChildren = childrenData;
          isLoading = false;
        });
      } else {
        print("❌ Error al obtener datos del Dashboard.");
      }
    } catch (e) {
      print("❌ Error de conexión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard del Especialista'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilesScreen(specialistId: widget.specialistId)));
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📊 Estadísticas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      StatsCard(icon: Icons.people, title: 'Niños Asignados', value: '$childrenCount', color: Colors.blue),
                      StatsCard(icon: Icons.timeline, title: 'Progreso Promedio', value: '${averageProgress.toStringAsFixed(1)}%', color: Colors.green),
                      StatsCard(icon: Icons.check_circle, title: 'Actividades Completadas', value: '$completedActivities', color: Colors.amber),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('👦 Niños Asignados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildChildrenList(),
                ],
              ),
            ),
    );
  }

  Widget _buildChildrenList() {
    return Column(
      children: assignedChildren.map((child) {
        return Card(
          elevation: 5,
          child: ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text("Nombre: ${child["nombre"] ?? "Desconocido"}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Edad: ${child["edad"] ?? "No especificada"} años"),
                Text("Última Evaluación: ${child["ultima_evaluacion"] ?? "No disponible"}"),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReportScreen(ninoId: child["id"])));
            },
          ),
        );
      }).toList(),
    );
  }
}

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  StatsCard({required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
