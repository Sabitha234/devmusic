

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../Models/SongModel.dart';
class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer=AudioPlayer();
    Song song=Song.songs[0];
    @override
    void initState(){
      super.initState();
      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: [
        AudioSource.uri(Uri.parse("asset///${song.url}"))
      ])
      );
    }
    @override
    void dispose(){
      audioPlayer.dispose();
      super.dispose();
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body:Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(song.coverurl,
              fit: BoxFit.cover,
            ),
            ShaderMask(
              shaderCallback:(rect){
                return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops:const [0.0,0.4,0.6]
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black,
                          Colors.blue.shade200,
                        ])
                ),

              ),
            )
          ],
        )
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
