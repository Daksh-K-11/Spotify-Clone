import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hexToColor(currentSong!.hex_code),
            const Color(0xff121212),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Pallete.transparentColor,
              focusColor: Pallete.transparentColor,
              splashColor: Pallete.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Hero(
                tag: 'music-image',
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(currentSong.thumbnail_url),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'song-name',
                            child: Text(
                              currentSong.song_name,
                              style: const TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'song-artist',
                            child: Text(
                              currentSong.artist,
                              style: const TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () async {
                          await ref
                            .read(homeViewModelProvider.notifier)
                            .favSong(songId: currentSong.id);
                        },
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration =
                          songNotifier.audioPlayer!.duration ?? Duration.zero;

                      double streamSliderValue = duration.inMilliseconds > 0
                          ? position.inMilliseconds / duration.inMilliseconds
                          : 0.0;

                      return _SliderWithTime(
                        initialSliderValue: streamSliderValue,
                        duration: duration,
                        onSeek: songNotifier.seek,
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/shuffle.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/previus-song.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: songNotifier.playPause,
                        icon: Icon(
                          songNotifier.isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                        ),
                        iconSize: 80,
                        color: Pallete.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/next-song.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/repeat.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/connect-device.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/playlist.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderWithTime extends StatefulWidget {
  final double initialSliderValue;
  final Duration duration;
  final Function(double) onSeek;

  const _SliderWithTime({
    required this.initialSliderValue,
    required this.duration,
    required this.onSeek,
  });

  @override
  _SliderWithTimeState createState() => _SliderWithTimeState();
}

class _SliderWithTimeState extends State<_SliderWithTime> {
  late double sliderValue;
  bool isDragging = false;

  @override
  void initState() {
    sliderValue = widget.initialSliderValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _SliderWithTime oldWidget) {
    if (!isDragging) {
      sliderValue = widget.initialSliderValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final displayedPosition = Duration(
        milliseconds: (widget.duration.inMilliseconds * sliderValue).round());

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Pallete.whiteColor,
            inactiveTrackColor: Pallete.whiteColor.withOpacity(0.117),
            thumbColor: Pallete.whiteColor,
            trackHeight: 4,
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: sliderValue,
            min: 0,
            max: 1,
            onChangeStart: (val) {
              setState(() {
                isDragging = true;
              });
            },
            onChanged: (val) {
              setState(() {
                sliderValue = val;
              });
            },
            onChangeEnd: (val) {
              setState(() {
                isDragging = false;
              });
              widget.onSeek(val);
            },
          ),
        ),
        Row(
          children: [
            Text(
              formatDuration(displayedPosition),
              style: const TextStyle(
                color: Pallete.subtitleText,
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Expanded(child: SizedBox()),
            Text(
              formatDuration(widget.duration),
              style: const TextStyle(
                color: Pallete.subtitleText,
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
