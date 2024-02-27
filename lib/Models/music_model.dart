import 'package:flutter/material.dart';

import 'lyrics_model.dart';

class Music {
  Duration? duration;
  String trackId;
  String? artistName;
  String? songName;
  String? songImage;
  String? artistImage;
  Color? songColor;
  List<Lyrics>?lyric;
  Music(
      {this.duration,
        required this.trackId,
        this.artistName,
        this.songName,
        this.songImage,
        this.artistImage,
        this.songColor,
        this.lyric
      });
}
