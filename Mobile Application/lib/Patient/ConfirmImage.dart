import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pascathon/Patient/DoctorList.dart';
import 'package:pascathon/Patient/Questionaire.dart';
import 'dart:io';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ConfirmImage extends StatefulWidget {
  File _file;
  ConfirmImage(this._file);
  @override
  _ConfirmImageState createState() => _ConfirmImageState();
}

class _ConfirmImageState extends State<ConfirmImage> {

  bool val=false;
  bool succ=false;
  String diseaseName;
   RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  final picker = ImagePicker();



  addDetails(String dis)async{
    CollectionReference collectionReference;
    String uid=FirebaseAuth.instance.currentUser.uid;
    Map<String,String>mapp={'disease_name':"$dis","date":"${DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now())}"};
   await FirebaseFirestore.instance.collection('Patients').doc(uid).collection('Tests').add(mapp).then((value) =>
   print(value.id));

  }




  Future getImagefromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      succ=false;
      val=false;
      widget._file = File(pickedFile.path);
    });
  }
  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    Navigator.pop(context);

    setState(() {
      succ=false;
      val=false;
      widget._file = File(pickedFile.path);
//      _btnController.reset();
    });
  }

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

  void _doSomething() async {
    var uri = Uri.parse('https://dermetology.herokuapp.com/predict');
    var request=http.MultipartRequest('POST',uri);
    print('1');
    request.files.add(await http.MultipartFile.fromPath('image', widget._file.path));
    print('2');
    var response = await request.send();
    print('3');
    print(response.statusCode);
    if (response.statusCode == 200){
      var respStr = await response.stream.bytesToString();
      print(respStr);
      await addDetails(jsonDecode(respStr)['predictions'][0]);
      setState(() {
        diseaseName=jsonDecode(respStr)['predictions'][0];
        print(diseaseName);
        succ=true;
      });
      _btnController.success();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
        backgroundColor: Color(0xFFea9b72),
        title: Text('Confirm Image',style: GoogleFonts.aBeeZee(fontSize: 20.0, color: Colors.white,),),
        actions: [
          IconButton(icon:Icon(Icons.refresh),color: Colors.white,onPressed: (){
            showSheet();
          },),
        ],
      ),
      body: Column(
        children: [
//          GradientAppBar('Confirm Image'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(widget._file),
                )
              ),
            ),
          ),
          succ==false?CheckboxListTile(onChanged: (bool value) {
            setState(() {

              val=value;
            });
          }, value: val,
            subtitle: Text('Please check to confirm',style: TextStyle(
                color: Colors.black,fontFamily: 'MontserratReg',
            )),
            title: Text('We are not storing these images anywhere',style: TextStyle(
              color: Colors.black,fontFamily: 'MontserratReg',fontSize: 14
            ),),
            activeColor: Color(0xFFea9b72),

          ):Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text('The disease identified by the training model is:', style: TextStyle(
              color: Colors.black,fontFamily: 'MontserratReg',fontSize: 15
            ),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(diseaseName,style: TextStyle(
                    color: Colors.black,fontFamily: 'MontserratReg',
                    fontSize: 20,fontWeight: FontWeight.bold
                  )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            child: Align(
              alignment: Alignment.centerRight,
//              child: InkWell(
//                onTap: ()async{
////                              await a
//                },
//                child: Container(
//                  width: 100,
//                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),  gradient: LinearGradient(
//                      colors: [
//                        Color(0xFFea9b72),
//                        Color(0xFFff9e33)
//                      ]
//                  )),
//                  child: Padding(
//                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
//                    child: Center(child: Text('Predict',style: TextStyle( fontSize: 15,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
//                  ),
//                ),
//              ),
            child: succ==true?Padding(
              padding: const EdgeInsets.only(right: 10,top: 10),
              child: Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>QuestionAire(diseaseName)));
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),  gradient: LinearGradient(
                        colors: [
                          Color(0xFFea9b72),
                          Color(0xFFff9e33)
                        ]
                    )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      child: Center(child: Text('Consult with Doctor',style: TextStyle( fontSize: 15,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
                    ),
                  ),
                ),
              ),
            ):RoundedLoadingButton(
              controller: _btnController,
              onPressed: val?_doSomething:null,
              color: Color(0xFFea9b72),
              child: Center(child: Text('Predict',style: TextStyle( fontSize: 15,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
            ),
            ),
          ),
        ],
      ),
    );
  }
}



class GradientAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 50.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: Icon(Icons.keyboard_backspace,color: Colors.white,),onPressed: (){
            Navigator.pop(context);
          },),
          Center(
            child: Text(
              title,
              style: GoogleFonts.aBeeZee(fontSize: 20.0, color: Colors.white,),
            ),
          ),
          IconButton(icon: Icon(Icons.refresh,color: Colors.white),onPressed: (){
          },),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFea9b72), Color(0xFFff9e33)],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
      ),
    );
  }
}