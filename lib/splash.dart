import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicplry/database.dart';
import 'package:musicplry/home.dart';

class Splash extends StatefulWidget {
   Splash({ Key? key }) : super(key: key);

  

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigatetohome();
  }

  navigatetohome()async{
   
    await Future.delayed(const Duration(milliseconds:3000 ),(){});
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const Home()));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top:200 ),
              height:150 ,
              width: 150,
              decoration: BoxDecoration(
              
                // ignore: prefer_const_constructors
                image:DecorationImage(
                  image: AssetImage('assets/38533148948342036b1f9c9027735ce1.jpg'
                       ), ),
                          color: Colors.black,
              ),
              
            ),
              SizedBox(
                height:200 ,
              ),
            Container(
            
              child: Text('MUSICBOX',style: const TextStyle(color: Colors.white,fontSize:25,fontWeight:FontWeight.w400 ),),
            )
          ],
        ),
        

        
      ),
      
    );
  }
}