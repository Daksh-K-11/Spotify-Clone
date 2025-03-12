import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<Map<String, String>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.103.228:8000/auth/signup",
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
        ),
      );
      if (response.statusCode != 201) {
        print('Error: ${response.statusCode} - ${response.body}');
        throw {};
      }
      final user = jsonDecode(response.body) as Map<String, String>;
      return user;
    } catch (e) {
      throw '';
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.103.228:8000/auth/login",
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      throw '';
    }
  }
}
