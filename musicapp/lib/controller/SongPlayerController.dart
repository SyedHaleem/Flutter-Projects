import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongPlayerController extends GetxController {
  final player = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxString currentTime = "0".obs;
  RxString totalTime = "0".obs;
  RxDouble sliderValue = 0.0.obs;
  RxDouble songMaxValue = 0.0.obs;
  RxString songTitle = "".obs;
  RxString songArtist = "".obs;
  RxBool isLooping = false.obs;
  RxInt selectedTabIndex = 0.obs;
  RxBool isShuffle = false.obs;
  RxDouble volumeLevel= 0.2.obs;

  List<SongModel> songList = []; // Add this to hold your list of songs

  void playLocalAudio(SongModel song) async {
    songTitle.value = song.title;
    songArtist.value = song.artist!;
    isPlaying.value = true;
    await player.setAudioSource(AudioSource.uri(Uri.parse(song.data)));
    player.play();
    updatePosition();
  }

  void resumePlaying() async {
    isPlaying.value = true;
    await player.play();
  }

  void pausePlaying() async {
    isPlaying.value = false;
    await player.pause();
  }

  void updatePosition() {
    try {
      player.durationStream.listen((d) {
        totalTime.value = d.toString().split(".")[0];
        songMaxValue.value = d!.inSeconds.toDouble();
      });
      player.positionStream.listen((p) {
        currentTime.value = p.toString().split(".")[0];
        sliderValue.value = p.inSeconds.toDouble();
      });
    } catch (e) {
      print(e);
    }
  }

  void seekTo(double value) {
    Duration newPosition = Duration(seconds: value.toInt());
    player.seek(newPosition);
  }

  void setLooping() async {
    if (isLooping.value) {
      await player.setLoopMode(LoopMode.off);
    } else {
      await player.setLoopMode(LoopMode.one);
    }
    isLooping.value = !isLooping.value;
  }

  void playRandomSong() async {
    if (songList.isEmpty) {
      print("No songs in playlist to shuffle");
      return;
    }

    if (!isShuffle.value) {
      List<AudioSource> audioSources = songList
          .map((song) => AudioSource.uri(Uri.parse(song.data)))
          .toList();
      await player.setAudioSource(ConcatenatingAudioSource(children: audioSources));
      await player.setShuffleModeEnabled(true);
      player.shuffle(); // Shuffle the playlist order
    } else {
      await player.setShuffleModeEnabled(false);
    }
    isShuffle.value = !isShuffle.value;
  }

  void changeVolume(double volume){
    volumeLevel.value = volume;
    player.setVolume(volumeLevel.value);
  }
}
