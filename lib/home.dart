import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplry/favourites.dart';
import 'package:musicplry/homescreen.dart';
import 'package:musicplry/playinfgsc.dart';
import 'package:musicplry/playlistsc.dart';
import 'package:musicplry/playlistscreen.dart';
import 'package:musicplry/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool issearch = false;
  int crctindex = 0;
  final pages = [
    const Homescreen(),
    const Playlist(),
    const Favourites(),
    const Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      
      // pages[crctindex],
      
       Stack(children: [
       
         pages[crctindex],
        Container(
            child: Align(
          alignment: Alignment.bottomCenter,
          // child: bottomplayingsc(),
          child: 
          
          Container(
            
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                    // topLeft:
                    Radius.circular(20),
                    // topRight: Radius.circular(20)
                    ),
                color: Colors.grey),
            child: const BottomPlayingsc(),
          ),
        )

           
            ),
      ]),
      //  pages[crctindex]
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: crctindex,
          onTap: (index) {
            setState(() {
              crctindex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.blue,
          backgroundColor: Colors.black54,
          elevation: 0,
          showUnselectedLabels: true,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              // title: Text('Favorites',style: TextStyle(color:Colors.black ),),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add),
                // title: Text('Favorites',style: TextStyle(color:Colors.black ),),
                label: 'Playlist'),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.heart),
                // title: Text('Favorites',style: TextStyle(color:Colors.black ),),
                label: 'Favourites'),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.cog),
                // title: Text('Favorites',style: TextStyle(color:Colors.black ),),
                label: 'Settings'),
          ]),
          
    );
  }
}
