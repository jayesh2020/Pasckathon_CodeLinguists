import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pascathon/Patient/Dashboard.dart';

import '../loader.dart';

class DoctorInfo extends StatefulWidget {
  Map<String, dynamic> _data;
  String _uid;
  String _diseaseName;
  DoctorInfo(this._data, this._uid,this._diseaseName);
  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo>
    with SingleTickerProviderStateMixin {
  DateTime startTime;
  DateTime endTime;
  int len;
  bool load = true;
  TabController _controller;
  int _currentIndex = 0;
  Color mainColour = Color(0xFFea9b72);
  List<String> appts = List();
  List<String> appts1 = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('abcd${widget._uid}');
    _controller = TabController(vsync: this, length: 2);
    _controller.addListener(_handleTabSelection);
    getExactTime();
    getAppointments();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getAppointments() async {
    Timer(Duration(seconds: 3), () async {
      CollectionReference doctor =
          FirebaseFirestore.instance.collection('Doctors');
      DocumentSnapshot ds = await doctor.doc(widget._uid).get();
      if (ds.exists) {
        if (ds.data().containsKey('appointments')) {
          setState(() {
            appts = List.from(ds.get('appointments'));
          });
        }
        if (ds.data().containsKey('appointments1')) {
          setState(() {
            appts1 = List.from(ds.get('appointments1'));
          });
        }
      }
      setState(() {
        load = false;
      });
    });
  }

  addData(String time, int ind) async {
    try {
      if (ind == 0) {
        appts.add(time);
        CollectionReference doctor =
        FirebaseFirestore.instance.collection('Doctors');
        doctor
            .doc(widget._uid)
            .update({"appointments": FieldValue.arrayUnion(appts)});
      } else {
        appts1.add(time);
        CollectionReference doctor =
        FirebaseFirestore.instance.collection('Doctors');
        doctor
            .doc(widget._uid)
            .update({"appointments1": FieldValue.arrayUnion(appts1)});
      }
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentSnapshot patientInfo = await FirebaseFirestore.instance
          .collection('Patients').doc(uid).get();
      Map<String, String>mapp = {
        'doctorName': "${widget._data['name']}",
        'appointmentTime': "$time",
        "doctorProfilePic": "${widget._data['profilePic']}"
      };
      await FirebaseFirestore.instance.collection('Patients').doc(uid)
          .collection('Appointments').add(mapp)
          .then((value) =>
          print(value.id));
      Map<String, String>mapp1 = {
        'patientName': "${patientInfo.data()['name']}",
        'appointmentTime': "$time",
        "patientProfilePic": "${widget._data['profilePic']}",
        "diseasePrediction": "${widget._diseaseName}"
      };
      await FirebaseFirestore.instance.collection('Doctors').doc(widget._uid)
          .collection('Appointments').add(mapp1)
          .then((value) =>
          print(value.id));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
              (route) => false);
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }
//    doctor.doc(widget._uid).update()
  }

  getExactTime() {
    print(DateFormat('HH:mm').parse(widget._data['startTime']));
    DateTime dateTime;
    if (DateFormat('HH:mm').parse(widget._data['startTime']).minute == 0) {
      dateTime = DateFormat('HH:mm').parse(widget._data['startTime']);
    } else if (DateFormat('HH:mm').parse(widget._data['startTime']).minute <=
        30) {
      dateTime = DateFormat('HH:mm').parse(widget._data['startTime']).add(
          Duration(
              minutes: (30 -
                  DateFormat('HH:mm')
                      .parse(widget._data['startTime'])
                      .minute)));
    } else {
      dateTime = DateFormat('HH:mm').parse(widget._data['startTime']).add(
          Duration(
              minutes: (60 -
                  DateFormat('HH:mm')
                      .parse(widget._data['startTime'])
                      .minute)));
    }
    DateTime dateTime1;
    if (DateFormat('HH:mm').parse(widget._data['endTime']).minute == 0) {
      dateTime1 = DateFormat('HH:mm').parse(widget._data['endTime']);
    } else if (DateFormat('HH:mm').parse(widget._data['endTime']).minute < 30) {
      dateTime1 = DateFormat('HH:mm').parse(widget._data['endTime']).subtract(
          Duration(
              minutes:
                  DateFormat('HH:mm').parse(widget._data['endTime']).minute));
    } else {
      dateTime1 = DateFormat('HH:mm').parse(widget._data['endTime']).subtract(
          Duration(
              minutes:
                  DateFormat('HH:mm').parse(widget._data['endTime']).minute -
                      30));
    }
    if (dateTime1.difference(dateTime).inMinutes / 30 < 0) {
    } else {
      setState(() {
        len = (dateTime1.difference(dateTime).inMinutes / 30).floor();
        startTime = dateTime;
        endTime = dateTime1;
      });
    }
  }

  showDialog1(BuildContext context, String time) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 130.0,
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
                                'Are you sure you want to book appointment for $time?',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'MontserratReg',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(48, 48, 48, 1)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
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
                                      await addData(time, _currentIndex);
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
        });
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _controller.index;
    });
    print(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return load == true
        ? Center(
            child: Container(
            child: loader1,
            color: Colors.white,
          ))
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color(0xFFea9b72),
              title: Text(
                'Book Appointment',
                style: GoogleFonts.aBeeZee(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Center(
                        child: ClipOval(
                            child: widget._data['profilePic'] == null
                                ? Image.asset(
                                    'assets/images/placeholder.jpg',
                                    height: 150,
                                    width: 150,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.jpg',
                                    fit: BoxFit.cover,
                                    image: widget._data['profilePic'],
                                    height: 150,
                                    width: 150,
                                    imageCacheHeight: 150,
                                    imageCacheWidth: 150,
                                  ))),
                  ),
                  Center(
                    child: Text(
                      'Dr. ${widget._data['name']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratSemi',
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Clinic Address:-${widget._data['clinicAddress']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'MontserratMed',
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget._data['clinicSince'] == 'null'
                      ? Container()
                      : Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${(DateTime.now().difference(DateFormat('dd-MM-yyyy').parse(widget._data['clinicSince'])).inDays / 365).floor()} years experience',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontserratMed',
                              fontSize: 16,
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Book Appointment:-',
                      style: TextStyle(
                          fontFamily: 'MontserratMed',
                          fontSize: 16,
                          color:
                              _currentIndex == 0 ? Colors.black : Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Today',
                                  style: TextStyle(
                                      fontFamily: 'MontserratMed',
                                      fontSize: 16,
                                      color: _currentIndex == 0
                                          ? Colors.black
                                          : Colors.grey.shade500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _currentIndex == 0
                                    ? Container(
                                        height: 2,
                                        color: mainColour,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Tomorrow',
                                  style: TextStyle(
                                      color: _currentIndex == 1
                                          ? Colors.black
                                          : Colors.grey.shade500,
                                      fontFamily: 'MontserratMed',
                                      fontSize: 16),
                                ),

                                SizedBox(
                                  height: 10,
                                ),
//                          Container(height: 2,col,),
                                _currentIndex == 1
                                    ? Container(
                                        height: 2,
                                        color: mainColour,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  _currentIndex == 0
                      ? Flexible(
                          child: GridView.builder(
                            itemBuilder: (BuildContext context, int pos) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: appts.contains(DateFormat('HH:mm')
                                          .format(startTime.add(
                                              Duration(minutes: pos * 30))))
                                      ? null
                                      : () {
                                          print(appts);

                                          print(appts.contains(
                                              DateFormat('HH:mm').format(
                                                  startTime.add(Duration(
                                                      minutes: pos * 30)))));

                                          showDialog1(
                                              context,
                                              DateFormat('HH:mm').format(
                                                  startTime.add(Duration(
                                                      minutes: pos * 30))));
                                        },
                                  child: Container(
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),

                                      color: appts.contains(DateFormat('HH:mm')
                                              .format(startTime.add(
                                                  Duration(minutes: pos * 30))))
                                          ? Colors.grey.shade500
                                          : null,

                                      gradient: appts.contains(DateFormat(
                                                  'HH:mm')
                                              .format(startTime.add(
                                                  Duration(minutes: pos * 30))))
                                          ? null
                                          : LinearGradient(
                                              colors: [
                                                Color(0xFFea9b72),
                                                Color(0xFFff9e33)
                                              ],
                                            ),

                                      //                           child: Text('${DateFormat('HH:mm').parse()}'),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        '${DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos * 30)))}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'MontserratSemi',
                                            fontSize: 16),
                                      )),
                                    ),
                                  ),
                                ),
                              );
                            },

                            //

                            //                         itemCount: ,

                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),

                            itemCount: len,

                            scrollDirection: Axis.vertical,

//    shrinkWrap: true,
                          ),
                        )
                      : Flexible(
                          child: GridView.builder(
                            itemBuilder: (BuildContext context, int pos) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: appts1.contains(DateFormat('HH:mm')
                                          .format(startTime.add(
                                              Duration(minutes: pos * 30))))
                                      ? null
                                      : () {
                                          print(appts1);
                                          print(appts1.contains(
                                              DateFormat('HH:mm').format(
                                                  startTime.add(Duration(
                                                      minutes: pos * 30)))));
                                          showDialog1(
                                              context,
                                              DateFormat('HH:mm').format(
                                                  startTime.add(Duration(
                                                      minutes: pos * 30))));
                                        },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: appts1.contains(DateFormat('HH:mm')
                                              .format(startTime.add(
                                                  Duration(minutes: pos * 30))))
                                          ? Colors.grey.shade500
                                          : null,
                                      gradient: appts1.contains(DateFormat(
                                                  'HH:mm')
                                              .format(startTime.add(
                                                  Duration(minutes: pos * 30))))
                                          ? null
                                          : LinearGradient(
                                              colors: [
                                                Color(0xFFea9b72),
                                                Color(0xFFff9e33)
                                              ],
                                            ),
//                           child: Text('${DateFormat('HH:mm').parse()}'),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        '${DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos * 30)))}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'MontserratSemi',
                                            fontSize: 16),
                                      )),
                                    ),
                                  ),
                                ),
                              );
                            },
//                         itemCount: ,
                            itemCount: len,
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                          ),
                        ),
//            DefaultTabController(
//              length: 2,
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: [
//                  TabBar(
//                    physics: NeverScrollableScrollPhysics(),
//                    controller: _controller,
//                    tabs: [
//                      Tab(text: 'Today',),
//                      Tab(text: 'Tomorrow',),
//                    ],
//                    isScrollable: false,
//                    indicatorColor: Color(0xFFea9b72),
//                    labelColor: Colors.black,
//                    labelStyle: TextStyle(
//                        color: Colors.black,fontFamily: 'MontserratMed',fontSize: 16
//                    ),
//                    unselectedLabelColor: Colors.grey.shade500,
//                  ),
//                  Container(
//                    height: 55,
//                    child: TabBarView(
//                      children: [
//                        ListView.builder(itemBuilder: (BuildContext context,int pos){
//                          return Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: InkWell(
//                              onTap: appts.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))))? null:(){
//                                print(appts);
//                                print(appts.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30)))));
//                                showDialog1(context,DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))));
//                              },
//                              child: Container(
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(5),
//                              color: appts.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))))?Colors.grey.shade500:null,
//                              gradient: appts.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))))?null:LinearGradient(
//                              colors: [
//                              Color(0xFFea9b72),
//                              Color(0xFFff9e33)
//                              ],
//                                ),
////                           child: Text('${DateFormat('HH:mm').parse()}'),
//                              ),
//                              child: Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Center(child: Text('${DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30)))}',style: TextStyle(color: Colors.white,fontFamily: 'MontserratSemi',fontSize: 16),)),
//                              ),
//                              ),
//                            ),
//                          );
//                        },
//                          physics: NeverScrollableScrollPhysics(),
////                         itemCount: ,
//                        itemCount: len,
//                          scrollDirection: Axis.horizontal,
//                        ),
//                        ListView.builder(itemBuilder: (BuildContext context,int pos){
//                          return Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: InkWell(
//                              onTap: appts1.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))))? null:(){
//                                print(appts1);
//                                print(appts1.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30)))));
//                                showDialog1(context,DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))));
//                              },
//                              child: Container(
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(5),
//                                  color: appts1.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))))?Colors.grey.shade500:null,
//                                  gradient: appts1.contains(DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30))))?null:LinearGradient(
//                                    colors: [
//                                      Color(0xFFea9b72),
//                                      Color(0xFFff9e33)
//                                    ],
//                                  ),
////                           child: Text('${DateFormat('HH:mm').parse()}'),
//                                ),
//                                child: Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child: Center(child: Text('${DateFormat('HH:mm').format(startTime.add(Duration(minutes: pos*30)))}',style: TextStyle(color: Colors.white,fontFamily: 'MontserratSemi',fontSize: 16),)),
//                                ),
//                              ),
//                            ),
//                          );
//                        },
////                         itemCount: ,
//                          itemCount: len,
//                          scrollDirection: Axis.horizontal,
//                        ),
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            )
                ],
              ),
            ),
          );
  }
}
