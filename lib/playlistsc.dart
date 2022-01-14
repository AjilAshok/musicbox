import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/bottomsheet.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/playlistscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final TextEditingController createcontroler = TextEditingController();
  String music = '';
  List<SongModel> playList = [];
  List allplaylist = [];

  final box = Hive.box("muciss");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Playlist',
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
          valueListenable: box.listenable(),
          builder: (context, Box value, child) {
            List keys = box.keys.toList();
            keys.remove("allSongs");
            keys.remove("fav");
            List playlistkey = keys;
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => playlistscreen(
                                  titleName: playlistkey[index],
                                ))),
                    onLongPress: () {
                      // box.delete("allSongs");
                      Get.defaultDialog(
                          title: "Delete",
                          middleText: "Are you sure",
                          textCancel: "No",
                          textConfirm: "Yes",
                          onCancel: () {
                            Navigator.pop(context);
                          },
                          onConfirm: () {
                            box.delete(playlistkey[index]);
                            Navigator.pop(context);
                          },
                          cancelTextColor: Colors.black,
                          confirmTextColor: Colors.black);
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Center(
                            child: Image(
                                image: const AssetImage('assets/download.png'),
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: 100),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.1),
                              child: Text(playlistkey[index].toString()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: playlistkey.length,

              //
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            opendilogue();
          },
          label: const Text(
            'Create a playlist',
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future opendilogue() {
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('New Playlist'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: createcontroler,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the playlist name";
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      music = value;
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
                            await box.put(music, allplaylist);
                            Navigator.pop(context);
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
