import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/recognition_response.dart';

class ApiService {
  // Use 'http://127.0.0.1:5000/api' for Physical Android Phone connected via USB with 'adb reverse'
  // Or your PC's local Wi-Fi IP (e.g., 'http://192.168.1.100:5000/api')
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  /// Uploads photo taken from camera to Node.js Express backend
  static Future<RecognitionResponse> uploadAndRecognize(File imageFile) async {
    final uri = Uri.parse('$baseUrl/recognize');
    final request = http.MultipartRequest('POST', uri);

    // Attach image
    final multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );
    request.files.add(multipartFile);

    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 25),
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 404) {
        final Map<String, dynamic> data = json.decode(response.body);
        return RecognitionResponse.fromJson(data);
      } else {
        throw Exception(
          'Server returned status code: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }
}

