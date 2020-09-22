import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pascathon/main.dart';

import 'ChooseRole.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String _email;
  String _password;
  String _name;
  String _phone;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future signUp()async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "$_email",
          password: "$_password",
      );
      User user=userCredential.user;
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ChooseRole(_name,_email,_password,user.uid)));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg:'The password provided is too weak.',backgroundColor: Colors.grey[900],textColor: Colors.white);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg:'The account already exists for that email.',backgroundColor: Colors.grey[900],textColor: Colors.white);
      }else{
        Fluttertoast.showToast(msg:e.code.toUpperCase(),backgroundColor: Colors.grey[900],textColor: Colors.white);
      }
    }
  }

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
                  child:Text('DERMOSOLUTIONS',
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
//          crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Text('Sign Up',
                          style: TextStyle(
                            fontFamily: 'MontserratSemi',
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFff9e33),width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15),
                              child: TextFormField(
                                  onChanged: (val){
                                    setState(() {
                                      _name=val;
                                    });
                                  },
                                  style: TextStyle( fontSize: 16,color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),
                                  decoration: InputDecoration.collapsed(hintText: 'Name',hintStyle:  TextStyle( fontSize: 16,color: Colors.grey,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFff9e33),width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                  onChanged: (val){
                                    setState(() {
                                      _phone=val;
                                    });
                                  },
                                  style: TextStyle( fontSize: 16,color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),
                                  decoration: InputDecoration.collapsed(hintText: 'Phone',hintStyle:  TextStyle( fontSize: 16,color: Colors.grey,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFff9e33),width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15),
                              child: TextFormField(
                                  onChanged: (val){
                                    setState(() {
                                      _email=val;
                                    });
                                  },
                                  style: TextStyle( fontSize: 16,color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),
                                  decoration: InputDecoration.collapsed(hintText: 'Email',hintStyle:  TextStyle( fontSize: 16,color: Colors.grey,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFff9e33),width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15),
                              child: TextFormField(
                                obscureText: true,
                                  onChanged: (val){
                                    setState(() {
                                      _password=val;
                                    });
                                  },
                                  style: TextStyle( fontSize: 16,color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),
                                  decoration: InputDecoration.collapsed(hintText: 'Password',hintStyle:  TextStyle( fontSize: 16,color: Colors.grey,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: ()async{
                              await signUp();
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
                                child: Center(child: Text('Sign Up',style: TextStyle( fontSize: 20,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Already signed in, ',style: TextStyle(color: Color(0xFFff9e33),fontFamily: 'MontserratMed',fontSize:   15),),
                            Text('Log In',style: TextStyle(color: Color(0xFFff9e33),fontFamily: 'MontserratSemi',decoration: TextDecoration.underline,fontSize: 15),),
                          ],
                        ),onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()));
                        },)
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


