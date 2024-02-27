

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/PlayListModel.dart';

import '../screens/ListOfSongs.dart';


class PlayListCard extends StatelessWidget {
  const PlayListCard({super.key, required this.playlist});

  final PlayList playlist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        List<String> tracks = await PlayList.getTracks(playlist.playlistid);
        Get.to(()=>ListOfSongs( playlistName: playlist.title, tracks: tracks));

      },
      child: Container(

        margin: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              //height: MediaQuery.of(context).size.height*0.25,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(image: AssetImage(
                    playlist.imgUrl,
                  ),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Container(
              height: 45,
              margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white.withOpacity(0.6)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            playlist.title,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const Icon(Icons.play_circle, color: Colors.deepPurple)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
