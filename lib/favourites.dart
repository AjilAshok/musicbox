import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/playinfgsc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final _boxe = Hive.box("muciss");
  final favoutiesSongs = ValueNotifier([]);
  List<Audio> songs = [];

  @override
  Widget build(BuildContext context) {
    // favoutiesSongs.value = _boxe.get("fav");
    List _keys=_boxe.keys.toList();
    if(_keys.where((element) => element=="fav").isNotEmpty){
      favoutiesSongs.value=_boxe.get("fav");
    }
    

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            'Favourites',
            style: TextStyle(fontSize: 26),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade200, Colors.black54])),
          child: ValueListenableBuilder(
            valueListenable: favoutiesSongs,
            builder: (context, List newfavourites, _) {
              List newfav = newfavourites.toList();
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 30, right: 5, left: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white60),
                      child: ListTile(
                        onTap: () {
                          for (var favli in newfav) {
                            songs.add(Audio.file(favli.uri.toString(),
                                metas: Metas(
                                    title: favli.title,
                                    id: favli.id.toString())));
                                    
                         }
                        // print(favoutiesSongs.value);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Playingsc(
                                  newMus: songs,
                                  index: index,
                                ),
                              ));
                        },
                        leading: Container(
                          height: 45,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(250),
                            child: QueryArtworkWidget(
                              id: newfav[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Image(
                                image: AssetImage('assets/download.jpeg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(newfavourites[index].title)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Text(
                              getTimeString(newfavourites[index].duration),
                              // newPlaylistSongs[index].duration.toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            PopupMenuButton(
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child:
                                             InkWell
                                             (
                                               child: Text('Remove from Favourites'),
                                               onTap: ()async{
                                                 Navigator.pop(context);
                                                 favoutiesSongs.value.remove(favoutiesSongs.value[index]);
                                                 favoutiesSongs.notifyListeners();
                                                    await _boxe.put("fav", favoutiesSongs.value);

                                               },
                                               
                                               ),
                                      ),
                                    ]),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: newfavourites.length);
            },
          ),
        
        ));
  }

  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sce =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sce";
  }
}
