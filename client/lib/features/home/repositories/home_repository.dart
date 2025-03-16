import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong(File selectedImage, File selectedAudio) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('${ServerConstants.serverURL}/song/upload'));

    request
      ..files.addAll(
        [
          await http.MultipartFile.fromPath(
              'thumbnail', selectedImage.path),
          await http.MultipartFile.fromPath('song',
              selectedAudio.path),
        ],
      )
      ..fields.addAll(
        {
          'artist': 'Arijit Singh',
          'song_name': 'Kesariya Brahmastra',
          'hex_code': 'FFFFFF'
        },
      )
      ..headers.addAll(
        {
          'x-auth-token':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijc4YzU5ODVjLTRhOWUtNDg3YS04M2Y4LTgwODVmNDU4NDQ0MyJ9.xHG_fWuyMFoL9xV8EY3NqAw42hfuT15AOa2k09yu1Ho'
        },
      );

    final res = await request.send();
    print(res);
  }
}
