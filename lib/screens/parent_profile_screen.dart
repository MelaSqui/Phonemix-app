import 'package:flutter/material.dart';
import 'register_child_screen.dart';

class ParentProfileScreen extends StatelessWidget {
  final Map<String, dynamic> parentData = {
    'nombre': 'Carlos López',
    'correo': 'carlos.lopez@example.com',
    'rol': 'Padre',
    'fechaNacimiento': '1980-05-12',
    'fechaRegistro': '2023-01-15',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Padre'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Datos Personales',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Nombre: ${parentData['nombre']}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Correo: ${parentData['correo']}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Rol: ${parentData['rol']}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Fecha de Nacimiento: ${parentData['fechaNacimiento']}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Fecha de Registro: ${parentData['fechaRegistro']}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterChildScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Updated parameter
                  foregroundColor: Colors.blueAccent, // Text color
                  minimumSize: Size(double.infinity, 50), // Button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Registrar Niño'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
