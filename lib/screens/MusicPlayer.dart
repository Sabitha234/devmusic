
import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../Models/PlayListModel.dart';
import '../Models/lyrics_model.dart';
import '../Models/music_model.dart';
import '../Widgets/ArtWorkImage.dart';
import '../screens/HomeScreen.dart';
import '../strings.dart';


import 'package:http/http.dart' as http;

import 'LyricsPage.dart';
class MusicPlayer extends StatefulWidget {
  final String trackId;
  const MusicPlayer({super.key,required this.trackId});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String? artistName;
  String? songName;
  late Music music=Music(trackId: widget.trackId);
  final  player =AudioPlayer();
  String? artistImage;
  Duration? duration;
  String? songImage="";
  Color? songColor;
  bool loading = true;
  List<Lyrics>? lyricList;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
  ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
  ScrollOffsetListener.create();
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    loadSongsandLyrics();
  }
  Future<void> loadSongsandLyrics() async {
    Music m = await playSong();
    await getLyrics(m);
    print("lyrics");
    for (Lyrics l in lyricList!) {
      print(l.words);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return loading
        ? Center(child: CircularProgressIndicator()): Scaffold(
      backgroundColor:Colors.orange.shade200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(

            children: [
              lyricList != null
                  ? Container(

                height:MediaQuery.of(context).size.height/1.7,
                    child: StreamBuilder<Duration>(
                        stream: player.onPositionChanged,
                        builder: (context, snapshot) {
                          return ScrollablePositionedList.builder(
                            itemCount: lyricList!.length,
                            itemBuilder: (context, index) {
                              Duration duration =
                                  snapshot.data ?? const Duration(seconds: 0);
                              DateTime dt = DateTime(1970, 1, 1).copyWith(
                                  hour: duration.inHours,
                                  minute: duration.inMinutes.remainder(60),
                                  second: duration.inSeconds.remainder(60));
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  lyricList![index].words,
                                  style: TextStyle(
                                    color: lyricList![index].timeStamp.isAfter(dt)
                                        ? Colors.white
                                        : Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            itemScrollController: itemScrollController,
                            scrollOffsetController: scrollOffsetController,
                            itemPositionsListener: itemPositionsListener,
                            scrollOffsetListener: scrollOffsetListener,
                          );
                        }),
                  )
                  :  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                                    height:MediaQuery.of(context).size.height/1.8,
                                    //  color: Colors.black26,
                                    // child: Center(child: Text("No Lyrics")),

                                  ),
                  ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //const SizedBox(height: 16),
                    StreamBuilder(
                        stream: player.onPositionChanged,
                        builder: (context, data) {
                          return ProgressBar(
                            progress: data.data ?? const Duration(seconds: 0),
                            total: duration ?? const Duration(minutes: 4),
                            bufferedBarColor: Colors.white38,
                            baseBarColor: Colors.white10,
                            thumbColor: Colors.white,
                            timeLabelTextStyle:
                            const TextStyle(color: Colors.white),
                            progressBarColor: Colors.white,
                            onSeek: (duration) {
                              player.seek(duration);
                            },
                          );
                        }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        IconButton(
                            onPressed: ()async {

                            },
                            icon: const Icon(Icons.skip_previous,
                                color: Colors.white, size: 30)),
                        IconButton(
                            onPressed: () async {
                              if (player.state == PlayerState.playing) {
                                await player.pause();
                              } else {
                                await player.resume();
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              player.state == PlayerState.playing
                                  ? Icons.pause
                                  : Icons.play_circle,
                              color: Colors.white,
                              size: 50,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white, size: 30)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon:
          IconButton(icon:Icon(Icons.home),
            onPressed: () { Get.to(HomeScreen()) ;},),label: "home"),
          BottomNavigationBarItem(icon:
          Icon(Icons.favorite_outlined),label: "fovorite"),
          BottomNavigationBarItem(icon:
          Icon(Icons.play_circle_outline),label: "play"),
          BottomNavigationBarItem(icon:
          Icon(Icons.people_outlined),label: "profile"),
        ],
      ),
    );
  }
  Future<Music> playSong() async {
    try {
      final credentials = SpotifyApiCredentials(
          CustomString.clientId, CustomString.clientSecretId);
      final spotify = SpotifyApi(credentials);
      final track = await spotify.tracks.get(widget.trackId);

      String tempSongName = track.name!;
      String tempArtistName = track.artists?.first.name ?? "";

      if (tempSongName.isNotEmpty && tempArtistName.isNotEmpty) {
        setState(() {
          music.songName = tempSongName;
          music.artistName = tempArtistName;
        });
      }

      final yt = YoutubeExplode();
      final video = (await yt.search.search(music.songName!)).first;
      final videoId = video.id.value;
      duration = video.duration;
      music.duration = duration;

      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.last.url;

      player.play(UrlSource(audioUrl.toString()));
    } catch (e) {
      print("Error fetching track details: $e");
    }

    return music;
  }

  // getLyrics(Music m){
  //   print(m.artistName);
  //   // streamSubscription = player.onPositionChanged.listen((duration) {
  //   //   DateTime dt = DateTime(1970, 1, 1).copyWith(
  //   //       hour: duration.inHours,
  //   //       minute: duration.inMinutes.remainder(60),
  //   //       second: duration.inSeconds.remainder(60));
  //   //   if(lyrics != null) {
  //   //     for (int index = 0; index < lyrics!.length; index++) {
  //   //       if (index > 4 && lyrics![index].timeStamp.isAfter(dt)) {
  //   //         itemScrollController.scrollTo(
  //   //             index: index - 3, duration: const Duration(milliseconds: 600));
  //   //         break;
  //   //       }
  //   //     }
  //   //   }
  //   // });
  //   get(Uri.parse(
  //       'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${m.songName} ${m.artistName}&type=default'))
  //       .then((response) {
  //     String data = response.body;
  //     lyrics = data
  //         .split('\n')
  //         .map((e) => Lyrics(e.split(' ').sublist(1).join(' '),
  //         DateFormat("[mm:ss.SS]").parse(e.split(' ')[0])))
  //         .toList();
  //
  //     for (Lyrics l in lyrics!) {
  //       print(l.words);
  //     }
  //
  //     setState(() {
  //
  //     });
  //   });
  // }
  Future<void> getLyrics(Music m) async {
    print(m.songName);
    print(m.artistName);
    try {
      String encodedSongName = Uri.encodeComponent(m.songName!);
      String encodedArtistName = Uri.encodeComponent(m.artistName!);

      http.Response response = await http.get(
        Uri.parse(
            'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=$encodedSongName%20$encodedArtistName&type=default'),
      );

      if (response.statusCode == 200) {
        String data = response.body;
        lyricList = await processData(data);
        setState(() {
          loading = false;
        });

      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error during HTTP request: $e");
      print("Stack trace: $stackTrace");
    }
  }

  List<Lyrics> processData(String data) {
    try {
      List<Lyrics> lyricsList = [];
      List<String> lines = LineSplitter.split(data).toList();
      for (String line in lines) {
        if (line.contains('[') && line.contains(']')) {
          int startIndex = line.indexOf('[') + 1;
          int endIndex = line.indexOf(']');
          String timestampString = line.substring(startIndex, endIndex);
          String words = line.substring(endIndex + 1).trim();
          Duration? timestamp = parseTimestampString(timestampString);

          if (timestamp != null) {
            DateTime startOfDay = DateTime(1970, 1, 1);
            DateTime dateTime = startOfDay.add(timestamp);

            lyricsList.add(Lyrics(words, dateTime));
          }
        }
      }

      return lyricsList;
    } catch (e) {
      print("Error parsing lyrics data: $e");
      return [];
    }
  }

  Duration? parseTimestampString(String timestampString) {
    try {
      List<String> parts = timestampString.split(':');

      if (parts.length == 2) {
        int minutes = int.tryParse(parts[0]) ?? 0;
        double seconds = double.tryParse(parts[1]) ?? 0.0;

        // Check if the timestamp is valid
        if (minutes >= 0 && seconds >= 0) {
          // Convert seconds to milliseconds (rounding if necessary)
          int milliseconds = (seconds * 1000).round();
          return Duration(minutes: minutes, milliseconds: milliseconds);
        }
      }

      // Handle invalid timestamp format
      print("Invalid timestamp format: $timestampString");
    } catch (e) {
      // Handle parsing errors
      print("Error parsing timestamp: $e");
    }

    // Return null if parsing fails or the format is invalid
    return null;
  }
}




