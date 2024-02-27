import 'dart:convert';

import 'package:spotify/spotify.dart' as Spotify;
import 'package:spotify/spotify.dart';
import '../strings.dart';
class PlayList {
  final String title;
  final String imgUrl;
  String playlistid;
  List<String> tracks = [];

  PlayList({required this.title,
    required this.imgUrl, required this.playlistid});

  static List<PlayList> playlist = [
    PlayList(
        title: 'Lord Shiva',
        imgUrl: "img/SHIV.png",
        playlistid: "4K4ZMalXTKR9MFP9iUkG0i?si=b2ebc85881644711"
    ),
    PlayList(
        title: 'Lord Ganesh',
        imgUrl: "img/Ganesha.png",
        playlistid: "5eUYVtP58AHwj7AyACwqxL?si=33af6db0bc1e44f2"
    ),
    PlayList(
        title: 'Lord Krishna',
        imgUrl: "img/Krishna.png",
        playlistid: "4ZduhLcJORaMCL3FTNcsNp?si=3dfb08bf47a446e4"
    ),
    PlayList(
        title: 'Lord Murugan',
        imgUrl: "img/Murugan.png",
        playlistid: "3a8vuZph9RQsd2uLSVQ6PN?si=af51348286e64690"
    ),
    PlayList(
        title: 'Lord Perumal',
        imgUrl: "img/Perumal.png",
        playlistid: "5aEfv6pvCrXxGWuVbR4cYz?si=561452272430466b"
    ),
    PlayList(
        title: 'Lord Ayyappa',
        imgUrl: "img/ayyapan.jpg",
        playlistid: "2Pzr1QDUUjnlzhPxwMfa6z?si=38b1c71389174373"
    ),

  ];


  static Future<List<String>> getTracks(String playlistid) async {
    List<String> trackList = [];
    final credentials = SpotifyApiCredentials(
      CustomString.clientId, CustomString.clientSecretId,
    );
    final spotify = Spotify.SpotifyApi(credentials);

    try {
      final playlist = await spotify.playlists.get(playlistid);

      // Check if the playlist and its tracks are not null
      if (playlist != null && playlist.tracks != null) {
        // Check if itemsNative is not null before iterating
        if (playlist.tracks!.itemsNative != null) {
          // Iterate over the raw JSON representation of items
          for (var item in playlist.tracks!.itemsNative!) {
            // Check if 'track' property and 'id' property are present
            if (item.containsKey('track') && item['track'] != null &&
                item['track']['id'] != null) {
              var trackId = item['track']['id'];
              trackList.add(trackId);
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching playlist tracks: $e');
    }

    //print('Playlist Tracks: $trackList');
    return trackList;
  }
}