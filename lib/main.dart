import 'package:flip_app/models.dart';
import 'package:flip_app/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game_dashboard.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/game': (context) => GameDashboard(),
        '/categories': (context) => GameDashboard(),
      },
      title: 'Flip Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class Home extends StatelessWidget {

  _renderRaisedButton(context, color, background, text, fontSize, route) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 55),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: background,
      ),
      child: FlatButton(
        onPressed: () => Navigator.pushNamed(context, route) ,
        child: Text(
          '$text',
          style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize)),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flippo', style: GoogleFonts.kaushanScript(
            textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 34)),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        shadowColor: Colors.grey,),
      body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [BoxShadow(
          color: Colors.blue.withOpacity(0.5),
          spreadRadius: 6,
          blurRadius: 7,
          offset: Offset(0, 2),) ],
        ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _renderRaisedButton(context, Colors.white,
                    Colors.blueAccent, 'Play', 30.0, '/game'),
                _renderRaisedButton(context, Colors.white,
                    Colors.blueAccent, 'Options', 30.0, '/game'),
                _renderRaisedButton(context, Colors.white,
                    Colors.blueAccent, 'Settings', 30.0, '/game')
              ],

            ),

      ),
    );
  }
}


// Spinner
// Center(
// child: Container(
// decoration: BoxDecoration(
// image: DecorationImage(
// image: AssetImage('assets/loading.gif'), fit: BoxFit.cover),
// ),
// ),
// );