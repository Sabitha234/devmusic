import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/SongModel.dart';

class SongCard extends StatelessWidget {
  const SongCard({super.key, required this.song});
  final Song song;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.toNamed('/song',arguments: song);
      },
      child: Container(

        margin: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              //height: MediaQuery.of(context).size.height*0.25,
              width: MediaQuery.of(context).size.width*0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(image: AssetImage(
                    song.coverurl,
                  ),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width*0.45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white.withOpacity(0.6)
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Text(
                            song.title,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Text(
                            song.description,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
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
