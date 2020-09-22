import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pascathon/Doctor/DoctorDashboard.dart';
import 'package:pascathon/Patient/BasicInfo.dart';
import 'package:pascathon/Patient/Dashboard.dart';
import 'package:pascathon/loader.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DoctorBasicInfo extends StatefulWidget {
  DoctorBasicInfo(this._uid,this._email,this._name,this._phoneNumber);
  String _uid;
  String _name;
  String _phoneNumber;
  String _email;
  @override
  _DoctorBasicInfoState createState() => _DoctorBasicInfoState();
}

class _DoctorBasicInfoState extends State<DoctorBasicInfo> with SingleTickerProviderStateMixin{

  String name;
  String phoneNumber;
  String email;
  int selectedTabIndex=0;
  AnimationController _controller;
  int experience;
  User _user;
  String genderValue;
  Animation<Offset> _animation;
  Animation<double> _fadeAnimation;
  TextEditingController _addressController=TextEditingController();
  String address;
  final picker = ImagePicker();
  File _file=null;
  File _certificate;
  FocusNode myFocusNode=FocusNode();
  RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  final storage=FlutterSecureStorage();
  String qualification;
  String clinicSince;
  String startTime;
  String endTime;
  String city;
  String regNo;
  bool load=true;
  TextEditingController _cityController=TextEditingController();

  onTabTap(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }


  Future<void> addUser() async {
    CollectionReference collectionReference;
    collectionReference = FirebaseFirestore.instance.collection('Doctors');
    DocumentSnapshot dS = await collectionReference.doc(widget._uid).get();
    if (!dS.exists) {
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
          }

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

// Cancel your subscription when done.
//      await uploadTask.onComplete;
//      streamSubscription.cancel();
//        print('abcde${widget._email}');
      Map<String,String>apps=Map<String,String>();
      Map<String, dynamic> map = {
        "name": "$name",
        "phoneNumber": "$phoneNumber",
        "email": "$email",
        "clinicAddress":"$address",
        "gender":"$genderValue",
        "qualification":"$qualification",
        "experience":"$experience",
        "startTime":"$startTime",
        "endTime":"$endTime",
        "registrationNumber":"$regNo",
        "city":"$city",
        "profilePic":"$downloadUrl",
        "appointments":apps,
      };
      await collectionReference.doc(widget._uid).set(map);
//          await storage.write(key: 'firstTime', value: 'true');
//          await storage.write(key: 'name', value: widget._name);
//          await storage.write(key: 'email', value: widget._email);
//          await storage.write(key: , value: 'true');
      await storage.write(key: 'firstTime', value: 'true');
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DoctorDashboard()));
    } // John Doe
    else{
      Fluttertoast.showToast(msg: 'Record already exist');
    }
  }

  playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  void doSomething()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery).then((value) {if(value==null){
    _btnController.error();
    Timer(Duration(seconds: 3), (){
      _btnController.reset();
    });
    }else{
      setState(() {
        _certificate=File(value.path);
      });
      _btnController.success();
    }
    });
//    setState(() {
//      _certificate=File(pickedFile.path);
//    });
//    _btnController.success();
  }


  checkRegNo()async{
//    String url="https://pure-anchorage-22286.herokuapp.com/license";
//
//    String body='{"firstName":"$name","lastName":"$name","license_no":"$regNo"}';
//    Map<String,String>header={
//      "Content-Type":"application/json"
//    };
//    http.Response response=await http.post(url,headers: header,body: body);
//    print(response.body);
//    print(body);
//    if(response.statusCode==200){
////
//    var res= jsonDecode(response.body);
//    if(res['msg']=="Authenticated!"){
      await addUser();
//    }else{
//      Fluttertoast.showToast(msg:res['msg'],textColor: Colors.white,backgroundColor: Colors.grey.shade700);
//    }
//    }

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
      address= addresses.first.addressLine;
      _addressController.text= addresses.first.addressLine;
      city=addresses.first.locality;
      _cityController.text=city;
      load=false;
//      city=addresses.first.locality;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user=FirebaseAuth.instance.currentUser;
    print('abcd${_user.photoURL}');
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


  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _file = File(pickedFile.path);
//      _btnController.reset();
    });
  }


  @override
  Widget build(BuildContext context) {
    return load==true?Container(child: loader1,color: Colors.white,):Scaffold(
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
                height: 600.0,
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
                              text: "Personal Information",
                              isSelected: selectedTabIndex == 0,
                              onTabTap: () {
                                onTabTap(0);
                              },
                            ),
                            SizedBox(height: 80,),
                            TabText(
                              text: "Clinic Information",
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
                                    initialValue: widget._name,
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
                                    initialValue: widget._phoneNumber,
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
                                    initialValue: widget._email,
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
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
//                                      myFocusNode.requestFocus();
                                      setState(() {
                                        qualification=val;

                                     });
                                    },
//                                    autofocus: true,
//                                    controller: _addressController,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: 'Qualification',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
//                                    focusNode: myFocusNode,
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
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
                                      setState(() {
                                        address=val;
                                      });
                                    },
                                    controller: _addressController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      labelText: 'Clinic Address',
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
                                        city=val;
                                      });
                                    },
                                    controller: _cityController,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: 'Clinic City',
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
                                  TextFormField(
                                    onChanged: (exp){
                                      setState(() {
//                                        dateOfBirth=DateFormat('dd-MM-yyyy').format(dateTime);\
                                      experience=int.parse(exp);
                                      });
                                    },
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Experience',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  DateTimeField(
                                    onChanged: (dateTime){
                                      setState(() {
//                                        dateOfBirth=DateFormat('dd-MM-yyyy').format(dateTime);
                                      startTime=DateFormat("HH:mm").format(dateTime);
//                                      print(startTime);
                                      });
                                    },
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Start time',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    format: DateFormat("HH:mm"),
                                    onShowPicker: (context, currentValue) async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.convert(time);
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  DateTimeField(
                                    onChanged: (dateTime){
//                                      setState(() {
////                                        dateOfBirth=DateFormat('dd-MM-yyyy').format(dateTime);
//                                      });
                                      setState(() {
//                                        dateOfBirth=DateFormat('dd-MM-yyyy').format(dateTime);
                                        endTime=DateFormat("HH:mm").format(dateTime);
//                                      print(startTime);
                                      });
                                    },
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'End time',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    format: DateFormat("HH:mm"),
                                    onShowPicker: (context, currentValue) async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.convert(time);
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    onChanged: (val){
//                                      myFocusNode.requestFocus();
                                      setState(() {
                                        regNo=val;

                                     });
                                    },
//                                    autofocus: true,
//                                    controller: _addressController,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: 'Registration number',
                                      labelStyle: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      color: Colors.black,
                                    ),
//                                    focusNode: myFocusNode,

                                  ),
                                SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Upload Certificate',style: TextStyle(
                                        fontFamily: 'MontserratMed',
                                        fontSize: 16,
                                        color: Colors.grey.shade500,
                                      ),),
                                      Expanded(
                                        child: RoundedLoadingButton(
                                          width: 20,
                                          controller: _btnController,
                                          onPressed: doSomething,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Icon(Icons.cloud_upload,color: Colors.white,),
                                          ),
                                          color: Color(0xFFea9b72),
//                                        ),
                                          ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: ()async{
                                          await checkRegNo();
//                                          await addUser();
//                                          print(weight);
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
