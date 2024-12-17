import 'package:flutter/material.dart';
import 'package:music_visualizer/music_visualizer.dart';

class SongWave extends StatelessWidget {
  SongWave({super.key});

  final List<Color> colors = [
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.brown[900]!
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 250,// Reduce the height to control the size
      child: MusicVisualizer(
        barCount: 30,
        colors: colors,
        duration: duration,
      ),
    );
  }
}
