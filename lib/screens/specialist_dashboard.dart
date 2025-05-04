import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:phoneme/api/reportes_service.dart';
import 'package:phoneme/screens/profiles_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int specialistId; // 🔥 Recibe el ID directamente

  DashboardScreen({required this.specialistId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ReportesService _service = ReportesService();
  List<dynamic> reportes = [];

  @override
  void initState() {
    super.initState();
    cargarReportes();
  }

  Future<void> cargarReportes() async {
    var datos = await _service.obtenerReportes(widget.specialistId);
    setState(() {
      reportes = datos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Especialista'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {}, // Acción opcional
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilesScreen(specialistId: widget.specialistId)), 
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Bienvenido al Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Especialista ID: ${widget.specialistId}"),

            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Text('📊 Progreso por Actividad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: reportes.isEmpty
                        ? Center(child: Text("No hay datos disponibles"))
                        : LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: true),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: reportes.isNotEmpty 
                                    ? reportes.map((r) => FlSpot(
                                        double.parse(r['fecha'].split('-')[2]), 
                                        double.parse(r['progreso_json']['avance'].toString())
                                      )).toList()
                                    : [FlSpot(0, 0)], // 🔥 Evita errores de lista vacía
                                  isCurved: true,
                                  color: Colors.blue,
                                  dotData: FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reportes.length,
                      itemBuilder: (context, index) {
                        var reporte = reportes[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text("Fecha: ${reporte['fecha']}"),
                            subtitle: Text("Avance: ${reporte['progreso_json']['avance']}%"),
                            trailing: Text("Intentos: ${reporte['progreso_json']['intentos']}"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
