import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportesService {
  final Dio _dio = Dio();
  static const String baseUrl = "http://localhost:3000"; // 🔥 Cambia esto con la URL real del backend

  Future<String?> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  Future<List<dynamic>> obtenerReportes(int specialistId) async {
    try {
      String? token = await _obtenerToken();
      if (token == null) throw Exception("❌ No se encontró el token.");

      final response = await _dio.get(
        "$baseUrl/specialist/reports/specialist?specialist_id=$specialistId",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 🔥 Token extraído automáticamente
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("❌ Error al obtener reportes.");
      }
    } catch (e) {
      throw Exception("❌ Error de conexión: $e");
    }
  }

  Future<bool> crearReporte(Map<String, dynamic> data) async {
    try {
      String? token = await _obtenerToken();
      if (token == null) throw Exception("❌ No se encontró el token.");

      final response = await _dio.post(
        "$baseUrl/specialist/reports",
        data: jsonEncode(data),
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 🔥 Token extraído automáticamente
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true; // ✅ Reporte creado exitosamente
      } else {
        throw Exception("❌ Error al crear el reporte.");
      }
    } catch (e) {
      throw Exception("❌ Error de conexión: $e");
    }
  }
}
