import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  User _user;
  UserProfile(this._user);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final Shader linearGradient = LinearGradient(
    colors: <Color>[  Color(0xFFea9b72),
      Color(0xFFff9e33)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 100.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFea9b72),
                      Color(0xFFff9e33)
                    ]
                )
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
image: DecorationImage(
    image: widget._user.photoURL==null?AssetImage('assets/images/placeholder.jpg'):NetworkImage(widget._user.photoURL)
)
//                  image: widget._user.photoURL==null?AssetImage('assets/images/placeholder.jpg'):NetworkImage(widget._user.photoURL)
                ),
              )
            ),
          ),
          Positioned(
            top: 180,
            left: 20,
              right: 20,
            child: Material(
              elevation: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('TESTS',style: GoogleFonts.aBeeZee( fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),),
                            SizedBox(height: 5,),
                            Text('10',style: GoogleFonts.aBeeZee( fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),),
                          ],
                        ),
                        Column(
                          children: [
                            Text('APPOINTMENTS',style: GoogleFonts.aBeeZee( fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),),
                            SizedBox(height: 5,),
                            Text('5',style: GoogleFonts.aBeeZee( fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ),
            ),
          ),

        ],
      ),
    );
  }
}
