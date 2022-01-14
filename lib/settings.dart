import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

bool isSwitched = true;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Settings',
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
        padding: EdgeInsets.only(top: 30, left: 10),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.bell),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Notification ',
                  style: const TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 180,
                ),
                Switch(
                  value: isSwitched,
                  onChanged: toogleSwitch,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.stickyNote),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Terms and Conditions',
                    style: const TextStyle(fontSize: 20),
                  ),
                  // SizedBox(
                  //   width: 150
                  // ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.user),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'About',
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.appStoreIos),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Privacy and policy',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),

                  Container(
                      child: Text(
                    'Version',
                    style: const TextStyle(fontSize: 20),
                  )),
                  // ignore: prefer_const_constructors
                  Container(
                      margin: const EdgeInsets.only(
                        right: 25,
                      ),
                      child: Text(
                        '1.0.0',
                        style: const TextStyle(fontSize: 10),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toogleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;

        Get.snackbar("Notification ", "Turned on",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.green,
            animationDuration: const Duration(milliseconds: 50),
            duration: const Duration(milliseconds: 600));
      });
    } else {
      setState(() {
        isSwitched = false;

        Get.snackbar("Notification", "Turned off",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red[200],
            animationDuration: Duration(milliseconds: 50),
            duration: const Duration(milliseconds: 600));
      });
    }
  }
}
