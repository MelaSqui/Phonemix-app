import 'package:flutter/material.dart';

class ChildHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activities = [
    {
      'nombre': 'Memorizar palabras nuevas',
      'progreso': 100,
      'completada': true,
      'icono': Icons.stars,
      'color': Colors.amber,
    },
    {
      'nombre': 'Leer una historia corta',
      'progreso': 100,
      'completada': true,
      'icono': Icons.book,
      'color': Colors.green,
    },
    {
      'nombre': 'Identificar sonidos',
      'progreso': 60,
      'completada': false,
      'icono': Icons.hearing,
      'color': Colors.blue,
    },
    {
      'nombre': 'Resolver acertijos',
      'progreso': 40,
      'completada': false,
      'icono': Icons.psychology,
      'color': Colors.purple,
    },
    {
      'nombre': 'Juego de memoria',
      'progreso': 80,
      'completada': false,
      'icono': Icons.memory,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    int totalProgreso = activities.fold<int>(0, (sum, activity) => sum + (activity['progreso'] as int));
    double progresoGeneral = totalProgreso / (activities.length * 100);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio del Niño'),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Marcador Gamificado
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progreso Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${(progresoGeneral * 100).toStringAsFixed(1)}% completado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    CircularProgressIndicator(
                      value: progresoGeneral,
                      backgroundColor: Colors.grey[300],
                      color: Colors.purpleAccent,
                      strokeWidth: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Actividades',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return Card(
                      elevation: 8,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: activity['completada'] ? Colors.green[100] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: activity['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                activity['icono'],
                                size: 40,
                                color: activity['completada']
                                    ? Colors.green
                                    : activity['color'],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity['nombre'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: activity['completada']
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  if (!activity['completada'])
                                    LinearProgressIndicator(
                                      value: activity['progreso'] / 100,
                                      backgroundColor: Colors.grey[300],
                                      color: activity['color'],
                                    ),
                                  SizedBox(height: 5),
                                  Text(
                                    activity['completada']
                                        ? '¡Completada!'
                                        : 'Progreso: ${activity['progreso']}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
