import 'package:flutter/material.dart';
import 'package:quiz_app/components/PlaySongAppBar.dart';
import 'package:quiz_app/components/SongButton.dart';
import 'package:quiz_app/components/SongDetails.dart';
import 'package:quiz_app/components/SongVolume.dart';
import 'package:quiz_app/components/SongWave.dart';
import 'package:quiz_app/components/TabBar.dart';

class PlaySongPage extends StatelessWidget {
  final String songImage;

  const PlaySongPage({super.key,required this.songImage});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: PlaySongAppBar(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Songvolume(songImage: songImage),
                const SizedBox(height: 50),
                const SongDetails(),
                const SizedBox(height: 20),
                const Spacer(),
                SongWave(),
                const SizedBox(height: 17),
                const SongButton(),
                const SizedBox(height: 20),
                TabBarr(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}