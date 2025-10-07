import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://YOUR_BACKEND_IP:PORT';

  static Future<String> getPaperStatus() async {
    final response = await http.get(Uri.parse('$baseUrl/api/status'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch status');
    }
  }
}
