import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pascathon/Patient/BasicInfo.dart';
import 'Doctor/DoctorBasicInfo.dart';
import 'Patient/Dashboard.dart';

class ChooseRole extends StatefulWidget {
  final String _name;
  final String _email;
  final String _phone;
  final String _uid;

  ChooseRole(this._name,this._email,this._phone,this._uid);
  @override
  _ChooseRoleState createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  int x=2;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage=FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {





    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFFea9b72),
                    Color(0xFFff9e33)
                  ]
              )
          ),
          child: Column(
            children: <Widget>[
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
                child: Center(
                  child:Text('Choose Role',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'MontserratBold'
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(35),topLeft: Radius.circular(35)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                        children: <Widget>[
                          Expanded(child: GestureDetector(
                            onTap: (){
                              setState(() {
                                x=0;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
//                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Material(
                                    elevation: x==0?10:0,
                                    shape: CircleBorder(),
                                    child: Container(decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/dr.jpg'),
                                      ),
                                    ),
                                      height: 150,
                                      width: 100,),
                                  ),
                                  SizedBox(height: 10,),
                                  Text('I am a Doctor',style: TextStyle(
                                    fontFamily: x==0?'MontserratSemi':'MontserratMed',
                                    color:x==0?Color(0xFFff9e33):Colors.black,
                                    fontSize: 15,

                                  ),)
                                ],
                              ),
                            ),
                          )),
                          SizedBox(width: 20,),
                          Expanded(child: GestureDetector(
                            onTap: (){
                              setState(() {
                                x=1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Material(
                                    elevation: x==1?10:0,
                                    shape: CircleBorder(),
                                    child: Container(decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage('assets/images/patient.jpg')
                                      ),
                                    ),
                                      height: 150,
                                      width: 100,),
                                  ),
                                  SizedBox(height: 10,),
                                  Text('I am a Patient',style: TextStyle(
                                    fontFamily: x==1?'MontserratSemi':'MontserratMed',
                                    color:x==1?Color(0xFFff9e33):Colors.black,
                                    fontSize: 15,
                                  ),)
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: (){
//                              await addUser();if
                            if(x==1)
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>BasicInfo(widget._uid,widget._name,widget._phone,widget._email)));
                            else if(x==0)
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DoctorBasicInfo(widget._uid,widget._email,widget._name,widget._phone)));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),  gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFea9b72),
                                    Color(0xFFff9e33)
                                  ]
                              )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                child: Center(child: Text('Done',style: TextStyle( fontSize: 20,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),//// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}