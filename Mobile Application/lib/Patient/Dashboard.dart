import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pascathon/Patient/ConfirmImage.dart';
import 'package:pascathon/Patient/UserProfile.dart';
import 'package:pascathon/loader.dart';
import 'package:pascathon/main.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  User _user;
  int selectedIndex=0;
  FirebaseAuth auth=FirebaseAuth.instance;
  File _image;
  Color mainColour=Color(0xFFea9b72);
  bool load=true;
  var userInfo;
  final picker = ImagePicker();
  List<QueryDocumentSnapshot>sna;
  List<QueryDocumentSnapshot>sna1;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[  Color(0xFFea9b72),
      Color(0xFFff9e33)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 100.0, 70.0));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user=auth.currentUser;
    getData();
  }

  getData()async{
    userInfo=await FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser.uid).get();
    var snapshot=await FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser.uid).collection('Tests').get();
    var snapshot1=await FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser.uid).collection('Appointments').get();
//    var snapshot=await FirebaseFirestore.instance.collection('Patients').get();
    setState(() {
      sna=snapshot.docs;
      sna1=snapshot1.docs;
      load=false;
    });
  }


  Future getImagefromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
    Navigator.pop(context);
    setState(() {
      selectedIndex=0;
    });
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ConfirmImage(_image)));
  }
  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ConfirmImage(_image)));
    setState(() {
      selectedIndex=0;
    });
  }



//  showDialog1(BuildContext context){
////    showDialog(context: context,
////    builder: (BuildContext context){
////      return Center(
////        child: Padding(
////          padding: const EdgeInsets.symmetric(horizontal: 20),
////          child: Container(
////            height: 80,
////            decoration: BoxDecoration(
////              color: Colors.white,
////              borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
////            ),
////            child: Scaffold(
////              body: Center(
////                child: Column(
////                  mainAxisAlignment: MainAxisAlignment.center,
////                  crossAxisAlignment: CrossAxisAlignment.center,
////                  children: [
////                    Text('Pick Image',style: GoogleFonts.aBeeZee(color: Colors.grey.shade600,fontSize: 18),),
////                    Spacer(),
////                    Row(
////                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                      children: [
////                    Expanded(
////                      child: Container(
////                        height: 40,
////                      width: MediaQuery.of(context).size.width,
////                        decoration: BoxDecoration(  gradient: LinearGradient(
////                            colors: [
////                              Color(0xFFea9b72),
////                              Color(0xFFff9e33)
////                            ]
////                        )),
////                        child: Padding(
////                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
////                          child: Center(child: Text('Gallery',style: TextStyle( fontSize: 18,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
////                        ),),
////                    ),
////                        Expanded(
////                          child: Container(
////                            height: 40,
////                            width: MediaQuery.of(context).size.width,
////                            decoration: BoxDecoration( gradient: LinearGradient(
////                                colors: [
////                                  Color(0xFFff9e33),
////                                  Color(0xFFea9b72),
////                                ]
////                            )),
////                            child: Padding(
////                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
////                              child: Center(child: Text('Camera',style: TextStyle( fontSize: 18,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
////                            ),),
////                        ),
////                      ],
////                    ),
////                  ],
////                ),
////              ),
////            )
////          ),
////        ),
////      );
////    });
////  }
  showSheet(){
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: ()async{
              await getImagefromCamera();
//              setState(() {
//                selectedIndex=0;
//              });

            },
            leading: Icon(Icons.camera),
            title: Text('Camera',style: GoogleFonts.aBeeZee(color: Colors.black),),
          ),
          ListTile(
            onTap: ()async{
              await getImagefromGallery();
//              setState(() {
//                selectedIndex=0;
//              });
            },
            leading: Icon(Icons.photo),
            title: Text('Gallery',style: GoogleFonts.aBeeZee(color: Colors.black),),
          ),
        ],
      );
    },
    );
  }


  showDialog1(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                    height: 120.0,
                    child: Center(
                      child: Scaffold(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 30, left: 8, right: 8),
                                child: Text(
                                  'Are you sure you want to logout?',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'MontserratReg',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(48, 48, 48, 1)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Center(
                                            child: Text(
                                              'CANCEL',
                                              style: TextStyle(
                                                color: mainColour,
                                                fontSize: 14,
                                                fontFamily: 'MontserratReg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()), (route) => false);
//                            await storage.deleteAll();
//                            Navigator.pushAndRemoveUntil(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (BuildContext context) => Home()),
//                                    (Route<dynamic> route) => false);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: mainColour,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(5.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Center(
                                            child: Text(
                                              'CONFIRM',
                                              style: TextStyle(
                                                color: Color(0xFFF0F0F0),
                                                fontSize: 14,
                                                fontFamily: 'MontserratReg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            );
          },
          );
        });
  }

  @override
  Widget build(BuildContext context) {




    return load==true?Container(child: loader1,color: Colors.white,):SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: selectedIndex==0?Stack(
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
              Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.exit_to_app,color: Colors.white,),
                      onPressed: (){
                        showDialog1(context);
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _user.photoURL==null?AssetImage('assets/images/placeholder.jpg'):NetworkImage(_user.photoURL)
                          )
//                  image: widget._user.photoURL==null?AssetImage('assets/images/placeholder.jpg'):NetworkImage(widget._user.photoURL)
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Center(child: Text(userInfo.data()['name'],style: TextStyle( fontSize: 16,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratReg'),))
                ],
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
                                  Text('${sna.length}',style: GoogleFonts.aBeeZee( fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('APPOINTMENTS',style: GoogleFonts.aBeeZee( fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),),
                                  SizedBox(height: 5,),
                                  Text('${sna1.length}',style: GoogleFonts.aBeeZee( fontSize: 18,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,foreground: Paint()..shader = linearGradient),),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                ),
              ),
              sna.length==0? Positioned(
                top: 280,
                child: Column(
                  children: [
                    Image.asset('assets/images/dashboardimage.jpg',width: MediaQuery.of(context).size.width,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Text('No medical history yet',style: GoogleFonts.aBeeZee(color: Colors.grey.shade600,fontSize: 18),),
                        Text('Click on the camera icon to start',style: GoogleFonts.aBeeZee( fontSize: 18 ,color: Colors.black,fontStyle: FontStyle.normal,),)
                      ],
                    ),
                  ],
                ),
              ):Positioned(
                top: 290,
                child: Column(
                  children: [
                    Align(child: Text('Tests',style: GoogleFonts.aBeeZee(color: Colors.black,fontSize: 18),textAlign: TextAlign.start,)),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(

                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int pos){
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(child: sna[pos].data()['fireBaseUrl']==null?Image.asset('assets/images/placeholder.jpg',height: 100,width: 100,):FadeInImage.assetNetwork(placeholder:'assets/images/placeholder.jpg', image: sna[pos].data()['fireBaseUrl'],height: 100,width: 100,imageCacheHeight: 100,imageCacheWidth: 100,)),
                                  SizedBox(height: 10,),
                                  Center(child: Text(sna[pos].data()['disease_name'],style: TextStyle(color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),textAlign: TextAlign.center,)),
                                  SizedBox(height: 5,),
                                  Text(DateFormat.yMMMd().format(DateFormat('dd-MM-yyyy HH:mm:ss').parse(sna[pos].data()['date'])),style: TextStyle(color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed')),
                                ],
                              ),
                            );
                          },
                          itemCount: sna.length,shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),),
                      ),
                    )
                  ],
                ),
              )
            ],
          ):UserProfile(_user),
          bottomNavigationBar: CurvedNavigationBar(
            index: selectedIndex,
            height: 60,
            color: Color(0xFFea9b72),
            backgroundColor: Colors.white,
            items: [
              Icon(Icons.home,color: Colors.white,),
              Icon(Icons.camera_alt,color: Colors.white,),
              Icon(Icons.event_note,color: Colors.white,),
            ],
            onTap: (int x)async{
              print(x);
              switch (x){
                case 0:setState(() {
                  selectedIndex=0;
                });
                break;
                case 1:showSheet();
                break;
              }
            },
          )
      ),
    );
  }
}