import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  SongModel? build() {
    null;
  }

  void updatesong(SongModel song) async {
    audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
    );
    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }
}
