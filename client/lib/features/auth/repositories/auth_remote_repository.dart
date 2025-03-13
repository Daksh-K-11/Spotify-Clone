import 'dart:async';
import 'dart:convert';

import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../core/failure/failure.dart';

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
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
      final Map<String, dynamic> resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(message: resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap));

    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.29.115:8000/auth/login",
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
      print(e);
      throw '';
    }
  }
}
