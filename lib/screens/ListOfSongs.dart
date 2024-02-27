import 'dart:convert';
import 'dart:core';
import 'package:devmusic/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spotify/spotify.dart';
import '../Models/lyrics_model.dart';
import '../Models/music_model.dart';
import '../strings.dart';
import 'MusicPlayer.dart';

class ListOfSongs extends StatefulWidget {
  final playlistName;
  final List<String> tracks;

  const ListOfSongs({Key? key, required this.playlistName, required this.tracks})
      : super(key: key);

  @override
  State<ListOfSongs> createState() => _ListOfSongsState();
}

class _ListOfSongsState extends State<ListOfSongs> {
  Map<String, Music> tracksMap = {};
  List<Lyrics> lyricsList = [];
  String? artistImage;
  Duration? duration;
  String? songImage = "";
  Color? songColor;
  bool loading = true;
  Music? m;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  Future<void> _fetchTracks() async {
    for (String trackId in widget.tracks) {
      Music music = Music(trackId: trackId);
      String artistName = "";
      String songName = "";

      final credentials =
      SpotifyApiCredentials(CustomString.clientId, CustomString.clientSecretId);
      final spotify = SpotifyApi(credentials);

      try {
        var track = await spotify.tracks.get(trackId);
        String? tempSongName = track.name;

        if (tempSongName != null) {
          songName = tempSongName;
          music.songName = songName;
          artistName = track.artists?.first.name ?? "";
          music.artistName = artistName;
         tracksMap.addIf(tempSongName != null, trackId, music);

        }
      } catch (e) {
        print("Error fetching track details: $e");
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final songCount = widget.tracks.length;
    return loading == false
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.playlistName,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$songCount songs",
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.orange.shade300,
      body: Column(
        children: [
          _DiscoverMusic(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.tracks.length,
              itemBuilder: (context, index) {
                if (index < tracksMap.length) {
                  final trackid = widget.tracks[index];
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange.shade100,
                      ),
                      child: ListTile(
                          title: Text(
                            tracksMap[trackid]!.songName!,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            tracksMap[trackid]!.artistName!,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Get.to(MusicPlayer(
                              trackId: trackid,
                            ));
                          },
                          trailing: Icon(
                            Icons.play_circle,
                            color: Colors.white,
                          )),
                    ),
                  );
                } else {
                  // Handle the case where index is out of bounds
                  return Container();
                }
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Get.to(HomeScreen());
                },
              ),
              label: "home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outlined), label: "favorite"),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline), label: "play"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined), label: "profile"),
        ],
      ),
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}



class _DiscoverMusic extends StatelessWidget {
  const _DiscoverMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //const SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(
                  filled:true,
                  isDense: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  helperStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none
                  )
              ),
            )
          ],
        )
    );
  }
}
