import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(
        "http://192.168.29.115:8000/auth/signup",
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
    print(response.body);
    print(response.statusCode);
  }

  Future<void> login({required String email, required String password}) async {
    
  }
}
