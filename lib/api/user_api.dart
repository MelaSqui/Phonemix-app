import 'dart:convert';
import 'api_service.dart';

class UserApi {
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await ApiService.post('/user/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Devuelve el token y el nombre del usuario
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }
}
