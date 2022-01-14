import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplry/playinfgsc.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<Audio> playli = [];

class playlistscreen extends StatefulWidget {
  String titleName;
  playlistscreen({Key? key, required this.titleName}) : super(key: key);

  @override
  State<playlistscreen> createState() => _playlistscreenState();
}

class _playlistscreenState extends State<playlistscreen> {
  final _box = Hive.box("muciss");
  final playlistSongs = ValueNotifier([]);
  List<Audio> songlist = [];
  @override
  Widget build(BuildContext context) {
    // List <musicList>hello = _box.get(widget.titleName);
    playlistSongs.value = _box.get(widget.titleName);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          widget.titleName,
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
          valueListenable: playlistSongs,
          builder: (BuildContext context, List newPlaylistSongs, _) {
            List newpl = newPlaylistSongs.toList();
            return ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 30, right: 5, left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white60),
                    child: ListTile(
                      onTap: () {
                        for (var lis in newpl) {
                          songlist.add(Audio.file(lis.uri.toString(),
                              metas: Metas(
                                  title: lis.title, id: lis.id.toString())));
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Playingsc(
                                newMus: songlist,
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
                            id: newpl[index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Image(
                              image: AssetImage('assets/download.jpeg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(newPlaylistSongs[index].title),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Text(
                            getTimeString(newPlaylistSongs[index].duration),
                            // newPlaylistSongs[index].duration.toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        child: InkWell(
                                      child: const Text('Remove from playlist'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        playlistSongs.value
                                            .remove(playlistSongs.value[index]);
                                        playlistSongs.notifyListeners();
                                        await _box.put(widget.titleName,
                                            playlistSongs.value);
                                      },

                                      //                   onLongPress: (){
                                      //                      Get.defaultDialog(
                                      // title: "Delete",
                                      // middleText: "Are you sure",
                                      // textCancel: "No",
                                      // textConfirm: "Yes",
                                      // onCancel: () {
                                      //   Navigator.pop(context);
                                      // },
                                      // onConfirm: () {
                                      //   _box.deleteAt(index);
                                      // },
                                      // cancelTextColor: Colors.black,
                                      // confirmTextColor: Colors.black);
                                      //                   },
                                    )),
                                  ]),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: newPlaylistSongs.length);
          },
        ),
        //     ListView(
        //     children: [
        //

        //     ],
        // ),
      ),
    );
  }

  // Future deletee() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: const Text('Are you sure '),
  //             actions: [
  //               TextButton(onPressed: () {}, child: const Text('Yes')),
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('No')),
  //             ],
  //           ));
  // }
  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sce =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sce";
  }
}
