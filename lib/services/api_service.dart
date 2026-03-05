import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  static const String _baseUrl = 'https://swapi.dev/api';

  Future<ApiResponse> fetchCharacters(int page) async {
    try {
      final uri = Uri.parse('$_baseUrl/people/?page=$page');
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse.fromJson(json);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not reach the server. Try again later.');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}