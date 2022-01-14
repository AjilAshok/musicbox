
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/home.dart';
import 'package:musicplry/splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main()async{
  await Hive.initFlutter();
  Hive.registerAdapter(musicListAdapter());
  await Hive.openBox("muciss");
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.red
      ),
      home: Splash(),
      
    );
  }
}