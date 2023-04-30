// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> response2 = [];
List<String> response = [];
List<Container> listofleaderboard = [];
read_file() async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  listofleaderboard = [];
  response2 = pre.getString("puan").toString().split(",");
  response2.sort((a, b) => a.toString().compareTo(b.toString()));
  response = response2.reversed.toList();
  for (var i = 0; i < response.length - 1; i++) {
    listofleaderboard.add(
      Container(
        child: Container(
          child: Row(
            children: [
              Icon(
                Icons.people_alt,
                color: Colors.white,
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
              Text(
                response[i].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class deneme {
  readfile();
}

class Gameoverscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 158, 3, 29),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                ),
                const SizedBox(width: 20.0, height: 40.0),
                Center(
                  child: const Text(
                    'GAME',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Horizon',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0, height: 40.0),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Horizon',
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                          speed: Duration(milliseconds: 240),
                          curve: Curves.bounceInOut,
                          'OVER'),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic),
                  'Leaderboard'),
            ),
            Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(top: 20, right: 120, left: 120),
                children: listofleaderboard,
              ),
            ),
            const SizedBox(width: 20.0, height: 40.0),
            Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                IconButton(
                  alignment: Alignment.topRight,
                  iconSize: 40,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_circle_left),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ));
  }
}
