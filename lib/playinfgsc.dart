import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/bottomsheet.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/favourites.dart';
import 'package:musicplry/homescreen.dart';
import 'package:musicplry/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class Playingsc extends StatefulWidget {
  final index;
  List<Audio> newMus;

  Playingsc({Key? key, this.index, required this.newMus}) : super(key: key);

  @override
  State<Playingsc> createState() => _PlayingscState();
}

class _PlayingscState extends State<Playingsc> {
  bool playing = false;
  IconData plyBtn = FontAwesomeIcons.playCircle;
  Color icncolor = Colors.black;
  final _boxe = Hive.box("muciss");
  final favourites = ValueNotifier([]);
  final assetsAudioPlayer = AssetsAudioPlayer.withId("1");
  // bool isplay=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assetsAudioPlayer.open(
      //  Audio('assets/sound/epic-hollywood-trailer-9489.mp3'),showNotification: true,autoStart: false
      Playlist(audios: widget.newMus, startIndex: widget.index),
      loopMode: LoopMode.playlist, showNotification: isSwitched,
      autoStart: true,
      notificationSettings: const NotificationSettings(
        seekBarEnabled: false,
        stopEnabled: false,
      ),

      // ignore: prefer_const_constructors
    );
  }

  @override
  void dispose() {
    // assetsAudioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // favourites.value =_boxe.get("fav");
    List keys = _boxe.keys.toList();
    if (keys.where((element) => element == "fav").isNotEmpty) {
      favourites.value = _boxe.get("fav");
    }
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.blue[200],
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (playing) {
                      assetsAudioPlayer.stop();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
            ),
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade200, Colors.black54])),
                child: Center(child: assetsAudioPlayer
                    .builderRealtimePlayingInfos(builder: (BuildContext context,
                        RealtimePlayingInfos realTimeInfo) {
                  if (realTimeInfo != null) {
                    return Column(children: [
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(600),
                              child: QueryArtworkWidget(
                                id: int.parse(realTimeInfo
                                    .current!.audio.audio.metas.id
                                    .toString()),
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Image(
                                  image: AssetImage('assets/download.jpeg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              realTimeInfo.current!.audio.audio.metas.title
                                  .toString(),
                              style: const TextStyle(fontSize: 30),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Expanded(
                          child: Container(
                        //  margin: EdgeInsets.only(top: 150),

                        width: MediaQuery.of(context).size.width * 1.0,
                        height: MediaQuery.of(context).size.width * 0.3,
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              // ignore: prefer_const_constructors
                              topRight: Radius.circular(35),
                            ),
                            color: Color(0xFF3366CC)),

                        child: assetsAudioPlayer.builderRealtimePlayingInfos(
                            builder: (BuildContext context,
                                RealtimePlayingInfos realTimeInfo) {
                          if (realTimeInfo != null) {
                            return Column(children: [
                              SizedBox(
                                height: 50,
                              ),
                              slider(
                                  realTimeInfo.currentPosition.inSeconds
                                      .toDouble(),
                                  realTimeInfo.duration.inSeconds.toDouble()),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // PlayerBuilder.current(player:assetsAudioPlayer,
                                  //  builder:(context,duration){final time = duration.index;
                                  //    return  Container(
                                  //   padding: const EdgeInsets.only(left:25),
                                  // child: Text(time.toString()));

                                  //  }),
                                  assetsAudioPlayer.builderCurrentPosition(
                                      builder: (context, duration) {
                                    return Container(
                                      padding: const EdgeInsets.only(left: 23),
                                      child: Text(getTimeString(
                                          duration.inMilliseconds)),
                                    );
                                  }),

                                  Container(
                                      margin: const EdgeInsets.only(right: 25),
                                      child: Text(getTimeString(realTimeInfo
                                          .duration.inMilliseconds)))
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: ValueListenableBuilder(
                                        valueListenable: favourites,
                                        builder: (BuildContext context,
                                            List<dynamic> newfav, _) {
                                          return favourites.value
                                                  .where((element) =>
                                                      element.id.toString() ==
                                                      realTimeInfo.current!
                                                          .audio.audio.metas.id
                                                          .toString())
                                                  .isEmpty
                                              ? IconButton(
                                                  onPressed: () async {
                                                    List favsong =
                                                        _boxe.get("allSongs");
                                                          var intx = await favsong
                                                        .indexWhere((element) =>
                                                            element.id
                                                                .toString() ==
                                                            realTimeInfo
                                                                .current!
                                                                .audio
                                                                .audio
                                                                .metas
                                                                .id
                                                                .toString());
                                                    if (favourites.value
                                                        .where((element) =>
                                                            element.id
                                                                .toString() ==
                                                            hivelist
                                                                .value[intx].id
                                                                .toString())
                                                        .isEmpty) {
                                                      favourites.value.add(
                                                          hivelist.value[intx]);
                                                      favourites
                                                          .notifyListeners();
                                                      await _boxe.put("fav",
                                                          favourites.value);
                                                    }

                                                    print('hhh');
                                                    Get.snackbar(
                                                        "Add to Favorites", "",
                                                        snackPosition:
                                                            SnackPosition
                                                                .TOP,
                                                        colorText: Colors.white,
                                                        backgroundColor: Colors
                                                            .green,
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    100),
                                                                    duration: const Duration(milliseconds: 600)
                                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: icncolor,
                                                  ))
                                              : IconButton(
                                                  onPressed: () async {
                                                    List favsong =
                                                        _boxe.get("fav");
                                                    var intx = await favsong
                                                        .indexWhere((element) =>
                                                            element.id
                                                                .toString() ==
                                                            realTimeInfo
                                                                .current!
                                                                .audio
                                                                .audio
                                                                .metas
                                                                .id
                                                                .toString());
                                                    favourites.value.remove(
                                                        favourites.value[intx]);
                                                    favourites
                                                        .notifyListeners();

                                                    await _boxe.put("fav",
                                                        favourites.value);
                                                  },
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ));
                                        }),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: IconButton(
                                        onPressed: () async {
                                          List allSongs = _boxe.get("allSongs");
                                          print(allSongs);
                                          var ind = await allSongs.indexWhere(
                                              (element) =>
                                                  element.id.toString() ==
                                                  realTimeInfo.current!.audio
                                                      .audio.metas.id
                                                      .toString());
                                          await Get.bottomSheet(Bottomsheet(
                                            ind: ind,
                                          ));
                                        },
                                        icon: const Icon(Icons.add)),
                                  )
                                ],
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.width *
                                        0.1),
                                child: assetsAudioPlayer.builderIsPlaying(
                                    builder: (context, isplaying) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: IconButton(
                                          onPressed: () {
                                            assetsAudioPlayer.shuffle;
                                          },
                                          icon: const Icon(
                                              FontAwesomeIcons.random),
                                          iconSize: 25,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: IconButton(
                                            onPressed: () {
                                              assetsAudioPlayer.previous();
                                            },
                                            icon: const Icon(
                                                FontAwesomeIcons.backward),
                                            iconSize: 30),
                                      ),
                                      IconButton(
                                        iconSize: 55,
                                        color: Color(0xFF00FF99),
                                        icon: Icon(isplaying
                                            ? FontAwesomeIcons.pauseCircle
                                            : FontAwesomeIcons.playCircle),
                                        onPressed: () => isplaying
                                            ? assetsAudioPlayer.pause()
                                            : assetsAudioPlayer.play(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: IconButton(
                                            onPressed: () {
                                              assetsAudioPlayer.next();
                                            },
                                            icon: const Icon(
                                                FontAwesomeIcons.forward),
                                            iconSize: 30),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: IconButton(
                                            onPressed: () {
                                              assetsAudioPlayer.loopMode;
                                            },
                                            icon: const Icon(
                                                FontAwesomeIcons.redo),
                                            iconSize: 23),
                                      ),
                                    ],
                                  );
                                }),
                              ))
                            ]);
                          } else {
                            return Container();
                          }
                        }),
                      ))
                    ]);
                  } else {
                    return Container();
                  }
                })))));
  }

  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sce =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sce";
  }

  slider(double value1, double value2) {
    return Slider.adaptive(
        activeColor: const Color(0xFF00FF99),
        inactiveColor: Colors.grey,
        value: value1,
        min: 0,
        max: value2,
        onChanged: (value1) {
          seektosec(value1.toDouble());
        });
  }

  seektosec(double sec) {
    Duration pos = Duration(seconds: sec.toInt());
    assetsAudioPlayer.seek(pos);
  }
}

class BottomPlayingsc extends StatefulWidget {
  const BottomPlayingsc({Key? key}) : super(key: key);

  @override
  _BottomPlayingscState createState() => _BottomPlayingscState();
}

class _BottomPlayingscState extends State<BottomPlayingsc> {
  final assetsAudioPlayer = AssetsAudioPlayer.withId("1");

  @override
  Widget build(BuildContext context) {
    return assetsAudioPlayer.builderRealtimePlayingInfos(
      builder: (context, realtimePlayingInfos) {
        if (realtimePlayingInfos != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  realtimePlayingInfos.current!.audio.audio.metas.title
                      .toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: () {
                    assetsAudioPlayer.previous();
                  },
                  icon: Icon(FontAwesomeIcons.backward)),
              assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                return IconButton(
                  iconSize: 30,
                  // color: Colors.blue,
                  icon:
                      Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                  onPressed: () => isPlaying
                      ? assetsAudioPlayer.pause()
                      : assetsAudioPlayer.play(),
                );
              }),
              IconButton(
                  onPressed: () {
                    assetsAudioPlayer.next();
                  },
                  icon: Icon(FontAwesomeIcons.forward)),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
