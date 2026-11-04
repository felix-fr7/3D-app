import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/recognition_response.dart';

class ApiService {
  // Candidate endpoints: USB (adb reverse), Laptop Wi-Fi IP, and Android Emulator
  static const List<String> candidateBaseUrls = [
    'http://127.0.0.1:5000/api',
    'http://192.168.1.34:5000/api',
    'http://10.0.2.2:5000/api',
  ];

  static String baseUrl = candidateBaseUrls.first;

  /// Uploads photo taken from camera to Node.js Express backend
  static Future<RecognitionResponse> uploadAndRecognize(File imageFile) async {
    dynamic lastException;

    for (final candidate in candidateBaseUrls) {
      try {
        final uri = Uri.parse('$candidate/recognize');
        final request = http.MultipartRequest('POST', uri);

        // Attach image
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        );
        request.files.add(multipartFile);

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 15),
        );
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200 || response.statusCode == 404) {
          baseUrl = candidate; // Cache the working endpoint
          final Map<String, dynamic> data = json.decode(response.body);
          return RecognitionResponse.fromJson(data);
        } else {
          throw Exception(
            'Server returned status code: ${response.statusCode} - ${response.body}',
          );
        }
      } catch (e) {
        lastException = e;
        // Try next candidate endpoint if it's a connection / socket failure
        continue;
      }
    }

    throw Exception(
      'Failed to connect to backend on any endpoint (USB & Wi-Fi): $lastException',
    );
  }
}

