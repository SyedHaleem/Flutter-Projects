import 'package:dartz/dartz.dart';

abstract class SongRepository {
  Future <Either> getNewsSongs();
}