import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/controller/SongPlayerController.dart';

class SongDataController extends GetxController {
  SongPlayerController songPlayerController = Get.put(SongPlayerController());
  final audioQuery = OnAudioQuery();
  RxInt currentIndex = 0.obs;
  RxList<SongModel> localSongList = <SongModel>[].obs;
  RxBool isDeviceSong = false.obs;

  @override
  void onInit() {
    super.onInit();
    storagePermission();
  }

  void getLocalSongs() async {
    localSongList.value = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );
    // print(localSongList.value);
  }

  void storagePermission() async {
    try {
      var perm = await Permission.storage.request();
      if (perm.isGranted) {
        print("Storage Permission Granted!");
        getLocalSongs();
      } else {
        print("Storage Permission Denied!");
        var manageExternalStoragePerm = await Permission.manageExternalStorage.request();
        if (manageExternalStoragePerm.isGranted) {
          print("Manage External Storage Permission Granted!");
          getLocalSongs();
        } else {
          print("Manage External Storage Permission Denied!");
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  void findCurrentIndex(int songId) {
    var index = 0;
    for (var e in localSongList) {
      if (e.id == songId) {
        currentIndex.value = index;
      }
      index++;
    }
  }

  void playNextSong() {
    if (currentIndex.value < localSongList.length - 1) {
      SongModel nextSong = localSongList[++currentIndex.value];
      songPlayerController.playLocalAudio(nextSong);
    }
  }

  void playPreviousSong() {
    if (currentIndex.value > 0) {
      SongModel previousSong = localSongList[--currentIndex.value];
      songPlayerController.playLocalAudio(previousSong);
    }
  }
}