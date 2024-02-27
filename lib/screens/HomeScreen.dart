
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Models/PlayListModel.dart';
import '../Models/SongModel.dart';
import '../Widgets/PlaylistCard.dart';
import '../Widgets/SectionHeader.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Song> songs=Song.songs;
    List<PlayList> playlists=PlayList.playlist;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade200,
                Colors.orangeAccent.shade100,
              ])
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: const Icon(Icons.grid_view_rounded),
          backgroundColor: Colors.orangeAccent.shade100,
          elevation: 0,
          title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome",
                style: Theme.of(context).textTheme.bodyLarge
            ),
            const SizedBox(height: 5,),
            Text("Hear Devotional Songs",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
            Icon(Icons.home),label: "home"),
            BottomNavigationBarItem(icon:
            Icon(Icons.favorite_outlined),label: "fovorite"),
            BottomNavigationBarItem(icon:
            Icon(Icons.play_circle_outline),label: "play"),
            BottomNavigationBarItem(icon:
            Icon(Icons.people_outlined),label: "profile"),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _TrendingMusic( pl:playlists,),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Column(
              //     children: [
              //        SectionHeader(title: "PlayLists"),
              //        ListView.builder(
              //             shrinkWrap: true,
              //             itemCount:playlists.length,
              //            // physics: const NeverScrollableScrollPhysics(),
              //             padding: EdgeInsets.only(top: 20),
              //             itemBuilder: (context,index){
              //                return PlayListCard(playlist: playlists[index],);
              //             }),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingMusic extends StatelessWidget {
  const _TrendingMusic({super.key, required this.pl});
  final List<PlayList> pl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: "Playlists"),
          ),
          const SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height ,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pl.length,
              itemBuilder: (context, index) {
                return PlayListCard( playlist: pl[index],);
              },
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

