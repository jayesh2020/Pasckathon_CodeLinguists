import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pascathon/Patient/ConfirmImage.dart';
import 'package:pascathon/Patient/UserProfile.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

    User _user;
    int selectedIndex=0;
    FirebaseAuth auth=FirebaseAuth.instance;
    File _image;
    final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user=auth.currentUser;
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

  @override
  Widget build(BuildContext context) {




    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: selectedIndex==0?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
//            SizedBox(height: 30,),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 15),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text('Hello',style: GoogleFonts.aBeeZee(color: Colors.grey.shade600,fontSize: 18),),
//                  Text(_user.displayName.split(' ')[0],style: GoogleFonts.aBeeZee( fontSize: 22 ,color: Colors.black,fontStyle: FontStyle.normal,),)
//                ],
//              ),
//            ),
          Image.asset('assets/images/dashboardimage.jpg'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Text('No medical history yet',style: GoogleFonts.aBeeZee(color: Colors.grey.shade600,fontSize: 18),),
                Text('Click on the camera icon to start',style: GoogleFonts.aBeeZee( fontSize: 18 ,color: Colors.black,fontStyle: FontStyle.normal,),)
              ],
            ),
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
            Icon(Icons.person,color: Colors.white,),
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
              case 3:setState(() {
                selectedIndex=3;
              });
              break;
            }
          },
        )
      ),
    );
  }
}
