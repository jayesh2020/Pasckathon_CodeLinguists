import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:pascathon/Patient/Dashboard.dart';

class BasicInfo extends StatefulWidget {
  @override
  _BasicInfoState createState() => _BasicInfoState();

  String _uid;
  String _name;
  String _phoneNumber;
  String _email;
  BasicInfo(this._uid,this._name,this._phoneNumber,this._email);
}

class _BasicInfoState extends State<BasicInfo> with SingleTickerProviderStateMixin{


  int selectedTabIndex = 0;
  AnimationController _controller;
  Animation<Offset> _animation;
  Animation<double> _fadeAnimation;
  bool load=false;
  User _user;
  String bloodGroup;
  String address;
  TextEditingController _addressController=TextEditingController();
  int height = 180;
  int weight =60;
  String genderValue;
  String skinToneValue;
  final picker = ImagePicker();
  String name;
  String phoneNumber;
  String email;
  String city;
  String dateOfBirth;
  String allergies;
  File _file;
  String otherDiseases;
  final storage=FlutterSecureStorage();



  onTabTap(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }





  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _file = File(pickedFile.path);
//      _btnController.reset();
    });
  }

  Future<void> addUser() async {
    CollectionReference collectionReference;
      collectionReference = FirebaseFirestore.instance.collection('Patients');
      DocumentSnapshot dS = await collectionReference.doc(widget._uid).get();
      if (!dS.exists) {
//        print('abcde${widget._email}');
        String downloadUrl;
        if(FirebaseAuth.instance.currentUser.photoURL!=null){
          if(_file!=null){
            StorageTaskSnapshot snapshot = await FirebaseStorage.instance
                .ref()
                .child('user')
                .child(FirebaseAuth.instance.currentUser.uid)
                .putFile(_file)
                .onComplete;
            if (snapshot.error == null) {
              downloadUrl = await snapshot.ref.getDownloadURL();
            }else{
              Fluttertoast.showToast(msg: snapshot.error.toString());
            }
            print('abcdef$downloadUrl');
          }else{
            downloadUrl=FirebaseAuth.instance.currentUser.photoURL;
          }
        }else{
          if(_file!=null){
            StorageTaskSnapshot snapshot = await FirebaseStorage.instance
                .ref()
                .child('user')
                .child(FirebaseAuth.instance.currentUser.uid)
                .putFile(_file)
                .onComplete;
            if (snapshot.error == null) {
              downloadUrl = await snapshot.ref.getDownloadURL();
            }else{
              Fluttertoast.showToast(msg: snapshot.error.toString());
            }
            print('abcdef$downloadUrl');
          }else{
            downloadUrl=FirebaseAuth.instance.currentUser.photoURL;
          }
        }
        Map<String, String> map = {
          "name": "$name",
          "phoneNumber": "$phoneNumber",
          "email": "$email",
          "dateOfBirth":"$dateOfBirth",
          "city":"$city",
          "gender":"$genderValue",
          "height":"$height",
          "weight":"$weight",
          "skinTone":"$skinToneValue",
          "bloodGroup":"$bloodGroup",
          "allergies":"$allergies",
          "otherDiseases":"$otherDiseases",
          "profilePic":"$downloadUrl"
        };
        await collectionReference.doc(widget._uid).set(map);
//          await storage.write(key: 'firstTime', value: 'true');
//          await storage.write(key: 'name', value: widget._name);
//          await storage.write(key: 'email', value: widget._email);
//          await storage.write(key: , value: 'true');
        await storage.write(key: 'firstTime', value: 'true');
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
      } // John Doe
    else{
      Fluttertoast.showToast(msg: 'Record already exist');
      }
  }


  getUserLocation() async {//call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    LocationData currentLocation = myLocation;
    final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    setState(() {
      address= addresses.first.toString();
    _addressController.text= addresses.first.locality;
    city=addresses.first.locality;
    });
  }

  @override
  void initState() {
    super.initState();
      _user=FirebaseAuth.instance.currentUser;
       name=widget._name;
       phoneNumber=widget._phoneNumber;
       email=widget._email;
    getUserLocation();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-0.05, 0)).animate(
            _controller);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

  }

  playAnimation() {
    _controller.reset();
    _controller.forward();
  }


  Widget _drawSlider() {
    return WeightBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : WeightSlider(
            minValue: 30,
            maxValue: 110,
            value: weight,
            onChanged: (val) => setState(() => weight = val),
            width: constraints.maxWidth,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          AppBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: IconButton(icon: Icon(Icons.arrow_back,color: Color(0xFFea9b72),),onPressed: (){Navigator.pop(context);},iconSize: 24,),
                        ),
                        color: Colors.white,
                        shape: CircleBorder(),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                height: 575.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -20,
                      bottom: 0,
                      top: 0,
                      width: 110.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            TabText(
                              text: "Personal\nInformation",
                              isSelected: selectedTabIndex == 0,
                              onTabTap: () {
                                onTabTap(0);
                              },
                            ),
                            SizedBox(height: 90,),
                            TabText(
                              text: "Medical\nHistory",
                              isSelected: selectedTabIndex == 1,
                              onTabTap: () {
                                onTabTap(1);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 65.0),
                      child: FutureBuilder(
                        future: playAnimation(),
                        builder: (context, snapshot) {
                          return selectedTabIndex==0?Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30,right: 15),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: _file==null?_user.photoURL!=null?ClipOval(
                                      child: FadeInImage.assetNetwork(placeholder: 'assets/images/placeholder.jpg', image: _user.photoURL,placeholderCacheHeight: 100,placeholderCacheWidth: 100,),
                                    ):Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage("assets/images/placeholder.jpg"),
                                          )
                                      ),
                                      height: 100,
                                      width: 100,
                                    ):Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: FileImage(_file),
                                          )
                                      ),
                                      height: 100,
                                      width: 100,
                                    ),
                                    onTap: ()async{
                                      await getImagefromGallery();
                                    },
                                  ),
                                  TextFormField(
                                    onChanged: (val){
                                      setState(() {
                                        name=val;
                                      });
                                    },
                                    initialValue: name,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
                                      setState(() {
                                        phoneNumber=val;
                                      });
                                    },
                                    initialValue: phoneNumber,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
                                      setState(() {
                                        email=val;
                                      });
                                    },
                                     initialValue: email,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  DateTimeField(
                                    onChanged: (dateTime){
                                      setState(() {
                                        dateOfBirth=DateFormat('yyyy-MM-dd').format(dateTime);
                                      });
                                    },
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Date of Birth',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    format: DateFormat("dd-MM-yyyy"),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
                                      setState(() {
                                        city=val;
                                      });
                                    },
                                    controller: _addressController,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: 'City',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  DropdownButtonFormField(
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                    disabledHint: Text('Gender',style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.grey.shade500,
                                    ),),
                                    hint: Text('Gender',style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),),
                                    value: genderValue,
                                    onChanged: (String val){
                                      setState(() {
                                        genderValue=val;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        child: Text('Male',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'Male',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Female',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'Female',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Other',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'Other',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: ()async{
//                              await addUser();
                                        setState(() {
                                          selectedTabIndex=1;
                                        });
                                        },
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),  gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFea9b72),
                                                Color(0xFFff9e33)
                                              ]
                                          )),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                            child: Center(child: Text('Next',style: TextStyle( fontSize: 20,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ):Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30,right: 15),
                              child: Column(
                                children: [
                                  ReusableCard(
                                    card: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'HEIGHT',
                                            style: TextStyle(
                                                fontFamily: 'MontserratSemi',
                                                color: Colors.black,
                                              ),
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            textBaseline: TextBaseline.alphabetic,
                                            children: <Widget>[
                                              Text(
                                                height.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'MontserratMed',
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                ' cms',
                                                style: TextStyle(
                                                  fontFamily: 'MontserratMed',
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              inactiveTrackColor: Colors.grey.shade400,
                                              activeTrackColor: Color(0xFFea9b72),
                                              thumbColor: Color(0xFFea9b72),
                                              thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 12.0,
                                              ),
                                              overlayShape: RoundSliderOverlayShape(
                                                overlayRadius: 30,
                                              ),
                                              overlayColor: Color(0x29EB1555),
                                            ),
                                            child: Slider(
                                              value: height.toDouble(),
                                              min: 120,
                                              max: 220,
                                              onChanged: (double newhieght) {
                                                setState(() {
                                                  height = newhieght.round();
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                _drawSlider(),
//                                  SizedBox(height: 10,),
                                  DropdownButtonFormField(
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                    disabledHint: Text('Gender',style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.grey.shade500,
                                    ),),
                                    hint: Text('Skin Tone',style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),),
                                    value: skinToneValue,
                                    onChanged: (String val){
                                      setState(() {
                                        skinToneValue=val;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        child: Text('Fair',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'Fair',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Medium',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'Medium',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Dark',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'Dark',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  DropdownButtonFormField(
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                    disabledHint: Text('Blood Group',style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.grey.shade500,
                                    ),),
                                    hint: Text('Blood Group',style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),),
                                    value: bloodGroup,
                                    onChanged: (String val){
                                      setState(() {
                                        bloodGroup=val;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        child: Text('A+',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'A+',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('A-',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'A-',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('B+',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'B+',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('B-',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'B-',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('O+',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'O+',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('O-',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'O-',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('AB+',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'AB+',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('AB-',style: TextStyle(
                                          fontFamily: 'MontserratMed',
                                          color: Colors.black,
                                        ),),
                                        value: 'AB-',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
                                      setState(() {
                                        allergies=val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Allergies',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
                                      setState(() {
                                        otherDiseases=val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Other Diseases',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: ()async{
                              await addUser();
                                        print(weight);
                                        },
                                        child: Container(
                                          width: 100,
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
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
//              Align(
//                alignment: Alignment.bottomRight,
//                child: Container(
//                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
//                  child: GestureDetector(
//                    child: Text('New Contact', style: buttonStyle,), onTap: () {
//                    Navigator.push(context, MaterialPageRoute(
//                        builder: (BuildContext context) => AddContact()));
//                  },),
//                  decoration: BoxDecoration(
//                    color: Colors.blue,
//                    borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(40)),
//                  ),
//                ),
//              )
            ],
          ),
        ],
      ),
    );
  }
}



class TabText extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function onTabTap;

  TabText({this.text, this.isSelected, this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -1.58,
      child: InkWell(
        onTap: onTabTap,
        child: AnimatedDefaultTextStyle(
          style: GoogleFonts.aBeeZee(fontSize: 18,color: Colors.black),
          duration: const Duration(milliseconds: 500),
          child: Text(
            text,
            style: isSelected==true?GoogleFonts.aBeeZee(fontSize: 18,color: Color(0xFFea9b72)):GoogleFonts.aBeeZee(fontSize: 16,color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final height = constraint.maxHeight;
        final width = constraint.maxWidth;

        return Stack(
          children: <Widget>[
            Container(
              color: Color(0xFFE4E6F1),
            ),
            Positioned(
              left: -(height/2 - width/2),
              bottom: height * 0.25,
              child: Container(
                height: height,
                width: height,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3)
                ),
              ),
            ),
            Positioned(
              left: width * 0.15,
              top: -width * 0.5,
              child: Container(
                height: width * 1.6,
                width: width * 1.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
            Positioned(
              right: -width * 0.2,
              top: -50,
              child: Container(
                height: width * 0.6,
                width: width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


class WeightBackground extends StatelessWidget {
  final Widget child;

  const WeightBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Weight',style: TextStyle(
                  fontFamily: 'MontserratSemi',),),
                Text(' (kgs)',style: TextStyle(
                  fontFamily: 'MontserratMed',),),
              ],
            ),
//            Text('Weight',style: TextStyle(
//              fontFamily: 'MontserratSemi',),),

            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                elevation: 2,
//color: Colors.transparent,
//                borderRadius:
//                new BorderRadius.circular(50),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: child,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_up)
          ],
        ),
      ],
    );
  }
}




class ReusableCard extends StatelessWidget {

  ReusableCard({@required this.colour,this.card,this.onPress});
  final Color colour;
  final Widget card;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: card,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
class RoundActionButton extends StatelessWidget {
  RoundActionButton({@required this.icon, @required this.onPressed});
  final IconData icon;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(icon,color: Color(0xFFea9b72),size: 12,),
      shape: CircleBorder(),
      fillColor: Colors.grey.shade400,
      constraints: BoxConstraints.tightFor(width: 30.0, height: 30.0),
//      elevation: 6.0,
      onPressed: onPressed,
    );
  }
}


class WeightSlider extends StatelessWidget {
  WeightSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.width,
    @required this.value,
    @required this.onChanged
  })  : scrollController = new ScrollController(initialScrollOffset: (value - minValue) * width / 3,),
        super(key: key);

  final int minValue;
  final int maxValue;
  final double width;
  final ScrollController scrollController;

  double get itemExtent => width / 3;
  final int value;
  final ValueChanged<int> onChanged;
  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int _indexToValue(int index) => minValue + (index - 1);
  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = _indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if(_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != value) {
        onChanged(middleValue); //update selection
      }
    }
    return true;
  }
  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }


  @override
  build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3;
    return NotificationListener(
      onNotification: _onNotification,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemExtent: itemExtent,
        itemCount: itemCount,
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final int value = _indexToValue(index);
          bool isExtra = index == 0 || index == itemCount - 1;

          return isExtra
              ? new Container() //empty first and last element
              : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _animateTo(value, durationMillis: 50),
            child: FittedBox(
              child: Text(
                value.toString(),
                style: _getTextStyle(value),
              ),
              fit: BoxFit.scaleDown,
            ),
          );
        },
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontFamily: 'MontserratReg',
    );
  }

  TextStyle _getHighlightTextStyle() {
    return new TextStyle(
      color: Color(0xFFea9b72),
      fontSize: 28.0,

      fontFamily: 'MontserratMed',
    );
  }

  TextStyle _getTextStyle(int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle()
        : _getDefaultTextStyle();
  }
  }
