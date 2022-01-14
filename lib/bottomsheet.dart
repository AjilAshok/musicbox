import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/playlistsc.dart';

class Bottomsheet extends StatefulWidget {
  int ind;
  String mus = "";

  Bottomsheet({Key? key, required this.ind}) : super(key: key);

  @override
  State<Bottomsheet> createState() => _bottomsheetState();
}

class _bottomsheetState extends State<Bottomsheet> {
  final TextEditingController Searchcontroler = TextEditingController();

  final _box = Hive.box("muciss");

  final playlist = ValueNotifier([]);

  List<musicList> allSongs = [];
  List playList = [];

  @override
  Widget build(BuildContext context) {
    List keys = _box.keys.toList();
    keys.remove("allSongs");

    allSongs = _box.get("allSongs");
    keys.remove("fav");
    playlist.value = keys;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade200, Colors.deepPurple.shade400]),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: InkWell(
        child: Column(
          children: [
            TextButton.icon(
              onPressed: () async {
                await opendi();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: Text('Add playlist',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
            ValueListenableBuilder(
                valueListenable: playlist,
                builder: (BuildContext context, List<dynamic> newPlaylis, _) {
                  return Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(newPlaylis[index]),
                                onTap: () async {
                                  List onePlaylist =
                                      _box.get(playlist.value[index]);
                                  print(widget.ind);
                                  if (onePlaylist
                                      .where((element) =>
                                          element.id.toString() ==
                                          allSongs[widget.ind].id.toString())
                                      .isEmpty) {
                                    onePlaylist.add(allSongs[widget.ind]);
                                    await _box.put(
                                        playlist.value[index], onePlaylist);

                                    Get.snackbar(
                                        "Successuly  added to playlist", "",
                                        snackPosition: SnackPosition.TOP,
                                        colorText: Colors.white,
                                        backgroundColor: Colors.green,
                                        animationDuration:
                                            const Duration(milliseconds: 50),
                                        duration:
                                            const Duration(milliseconds: 800));

                                    Navigator.pop(context);
                                  } else {
                                    Get.snackbar("Already added", "",
                                        snackPosition: SnackPosition.TOP,
                                        colorText: Colors.white,
                                        backgroundColor:
                                           Colors.red,
                                        animationDuration:
                                            const Duration(milliseconds: 50),
                                        duration:
                                            const Duration(milliseconds: 800));
                                    Navigator.pop(context);
                                  }
                                });
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                          itemCount: newPlaylis.length));
                })
          ],
        ),
      ),
    );
  }

  Future opendi() {
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('New Playlist'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: Searchcontroler,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter the name';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      widget.mus = value;
                    });
                  },
                  decoration:
                      const InputDecoration(hintText: 'Create a playlist'),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            playList.add(allSongs[widget.ind]);

                            await _box.put(widget.mus, playList);

                            Navigator.pop(context);
                            Get.snackbar("Successuly  added to playlist", "",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.green,
                                animationDuration: Duration(milliseconds: 50),
                                duration: const Duration(milliseconds: 800));
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.black),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                )
              ],
            ));
  }
}
