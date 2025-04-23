import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; // URL del backend

  // Método para enviar solicitudes POST
  static Future<http.Response> post(String endpoint, Map<String, dynamic>? body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body != null ? body : null, // He corregido los problemas de comparación
    );
  }

  // Método para enviar solicitudes GET
  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url, headers: {'Content-Type': 'application/json'});
  }
}

