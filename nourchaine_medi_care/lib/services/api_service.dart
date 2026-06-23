import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/session_record.dart';

class ApiService {
  // Change this to your server IP / hostname
  static const String _baseUrl = 'http://192.168.0.123';
  static const String _endpoint = '/api/get_data.php';
  static const Duration _timeout = Duration(seconds: 10);

  /// Fetches all session records from the PHP API.
  static Future<List<SessionRecord>> fetchRecords() async {
    final uri = Uri.parse('$_baseUrl$_endpoint');

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          list = decoded['data'] as List<dynamic>;
        } else {
          throw ApiException('Unexpected response format from server.');
        }

        return list
            .whereType<Map<String, dynamic>>()
            .map(SessionRecord.fromJson)
            .toList();
      } else {
        throw ApiException(
          'Server returned status ${response.statusCode}.',
        );
      }
    } catch (e) {
      throw ApiException(
        'Could not reach the server. Check your connection.\n($e)',
      );
    }
  }

  // =========================================================
  // NEW: Get assigned video for a user
  // =========================================================
  static Future<String?> getUserVideo(String email) async {
    final uri = Uri.parse('$_baseUrl/api/get_user_video.php?email=$email');

    try {
      final response = await http.get(uri).timeout(_timeout);

      debugPrint("RAW RESPONSE = ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['video_url'];
      } else {
        debugPrint("HTTP ERROR: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("API ERROR: $e");
      return null;
    }
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}