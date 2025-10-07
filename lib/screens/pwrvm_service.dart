// lib/screens/pwrvm_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PwrvmService {
  // Change to your backend IP later (e.g., http://192.168.1.50:3000)
  final String baseUrl;
  PwrvmService({this.baseUrl = 'http://127.0.0.1:3000'});

  Future<Map<String, dynamic>> getStatus() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/status'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        return json.decode(res.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    // Fallback so UI runs even if backend is down
    return {
      'paperDetected': false,
      'temperature': 25.0,
      'timeLeft': 0,
      'cycle': 'idle',
    };
  }

  Future<bool> startCycle() async {
    try {
      final res = await http
          .post(Uri.parse('$baseUrl/cycle/start'))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> stopCycle() async {
    try {
      final res = await http
          .post(Uri.parse('$baseUrl/cycle/stop'))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
