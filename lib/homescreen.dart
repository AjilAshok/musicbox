// ignore_for_file: prefer_const_construc

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplry/bottomsheet.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/favourites.dart';
import 'package:musicplry/playinfgsc.dart';
import 'package:musicplry/search.dart';

import 'package:on_audio_query/on_audio_query.dart';

List<Audio> newlis = [];
final hivelist = ValueNotifier(<musicList>[]);

final assetsAudioPlayer = AssetsAudioPlayer.withId("1");

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool issearch = false;
  String search = "";
  String Searchtext = "";
  TextEditingController textEditingController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final box = Hive.box("muciss");
  List<SongModel> fechsongsall = [];
  List favourites = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fecthsongs();
  }

  @override
  Widget build(BuildContext context) {
    List _keys = box.keys.toList();
    if (_keys.where((element) => element == "fav").isNotEmpty) {
      favourites = box.get("fav");
    }
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: !issearch
              ? Text(
                  'Home',
                  style: TextStyle(fontSize: 30),
                )
              : TextFormField(
                  style: TextStyle(color: Colors.red),
                  decoration: InputDecoration(
                    hintText: "Search Songs",
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) {
                    setState(() {
                      Searchtext = value;
                    });
                  },
                ),
          backgroundColor: Colors.black,
          leading: Image(
              image: AssetImage('assets/38533148948342036b1f9c9027735ce1.jpg')),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    this.issearch = !this.issearch;
                  });
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(sortType: null),
            builder: (context, snapshot) => Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade200, Colors.black54])),
                child: ValueListenableBuilder(
                  valueListenable: hivelist,
                  builder:
                      (BuildContext ctx, List<musicList> result, Widget? _) {
                    var songlist = Searchtext.isEmpty
                        ? hivelist.value.toList()
                        : hivelist.value
                            .where((element) => element.title
                                .toLowerCase()
                                .contains(Searchtext.toLowerCase().toString()))
                            .toList();

                    return ListView.separated(
                        itemBuilder: (BuildContext cntx, int index) {
                          var getIndex = hivelist.value.toList();
                          var get = hivelist.value
                              .where(
                                (c) => c.title.contains(songlist[index].title),
                              )
                              .toList();

                          final ind = getIndex.indexOf(get.first);

                          return
                              // bodylist(newMus,index);
                              Container(
                            margin: EdgeInsets.only(top: 30, right: 5, left: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white60),
                            child: ListTile(
                              onTap: () {
                                // result "some error"
                                for (var list in result) {
                                  newlis.add(Audio.file(list.uri.toString(),
                                      metas: Metas(
                                        title: list.title,
                                        id: list.id.toString(),
                                      )));
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Playingsc(
                                      index: ind,
                                      newMus: newlis,
                                    ),
                                  ),
                                );
                              },
                              leading: Container(
                                height: 45,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(250),
                                  child: QueryArtworkWidget(
                                    id: songlist[index].id,
                                    type: ArtworkType.AUDIO,
                                    // prin
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    // child: Text(newMus[index].metas.title.toString())
                                    child: Text(songlist[index].title),
                                    // child: Text(Searchtext[index].title),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: hivelist,
                                      builder: (BuildContext context,
                                          List<musicList> list, _) {
                                        return Text(getTimeString(
                                            songlist[index].duration));
                                      }),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  PopupMenuButton(
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              // child: Text('Asuper.initState();dd to playlist')
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Get.bottomSheet(Bottomsheet(
                                                    ind: index,
                                                  ));
                                                  // Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.add),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text('Add to playlist')
                                                  ],
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              // child: Text('Add to favorites')
                                              child: InkWell(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  if (favourites
                                                      .where((element) =>
                                                          element.id
                                                              .toString() ==
                                                          hivelist
                                                              .value[index].id
                                                              .toString())
                                                      .isEmpty) {
                                                    favourites.add(
                                                        hivelist.value[index]);
                                                    await box.put(
                                                        "fav", favourites);
                                                    print(favourites);
                                                    Get.snackbar(
                                                        "Added to favourites",
                                                        "",
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        colorText: Colors.white,
                                                        backgroundColor:
                                                            Colors.green,
                                                        animationDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    50),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    600));
                                                  } else {
                                                    print("songe inside");

                                                    Get.snackbar(
                                                        "Already add to Favourites",
                                                        "",
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        colorText: Colors.white,
                                                        backgroundColor:
                                                            Colors.red,
                                                        animationDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    50),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    600));
                                                  }

                                                  print('ontap');

                                                  //  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      FontAwesomeIcons.heart,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text('Add to Favourites')
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext cntx, int index) =>
                            // ignore: prefer_const_constructors
                            SizedBox(
                              height: 1,
                            ),
                        itemCount: songlist.length);
                  },
                ))));
  }

  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sce =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sce";
  }

  fecthsongs() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
        List<SongModel> allfechsong = await _audioQuery.querySongs();
        fechsongsall = allfechsong;
        await addsonglist();
      } else {
        List<SongModel> allfechsong = await _audioQuery.querySongs();
        fechsongsall = allfechsong;
        await addsonglist();
      }
    }
  }

 

  addsonglist() async {
    hivelist.value = fechsongsall
        .map((e) => musicList(
            title: e.title,
            uri: e.uri.toString(),
            id: e.id,
            duration: e.duration!.toInt()))
        .toList();
    await box.put("allSongs", hivelist.value);
    print(box);
  }

//
}
