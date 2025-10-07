import 'dart:convert';
import 'package:http/http.dart' as http;

class PwrvmService {
  // ✅ Use localhost when testing on Chrome (same laptop as backend)
  final String baseUrl = "http://192.168.8.174:3000";

  Future<Map<String, dynamic>> getStatus() async {
    final res = await http.get(Uri.parse('$baseUrl/status'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load status (code: ${res.statusCode})");
    }
  }

  Future<void> startCycle() async {
    final res = await http.post(Uri.parse('$baseUrl/start'));
    if (res.statusCode != 200) {
      throw Exception("Failed to start cycle");
    }
  }

  Future<void> stopCycle() async {
    final res = await http.post(Uri.parse('$baseUrl/stop'));
    if (res.statusCode != 200) {
      throw Exception("Failed to stop cycle");
    }
  }
}
