import 'dart:convert';
import 'dart:io';
import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';


@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong(
      {required File selectedAudio,
      required File selectedThumbnail,
      required String songName,
      required String artist,
      required String hexCode,
      required String token}) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${ServerConstants.serverURL}/song/upload'));

      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath(
                'thumbnail', selectedThumbnail.path),
            await http.MultipartFile.fromPath('song', selectedAudio.path),
          ],
        )
        ..fields.addAll(
          {
            'artist': artist,
            'song_name': songName,
            'hex_code': hexCode,
          },
        )
        ..headers.addAll(
          {
            'x-auth-token': token,
          },
        );

      final res = await request.send();

      if (res.statusCode != 201) {
        return Left(AppFailure(message: await res.stream.bytesToString()));
      }
      return Right(
        await res.stream.bytesToString(),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs(
      {required String token}) async {
    try {
      final response = await http
          .get(Uri.parse('${ServerConstants.serverURL}/song/list'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });

      var resBodyMap = jsonDecode(response.body);

      if (response.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(message: resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as List;
      List<SongModel> songs = [];

      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
