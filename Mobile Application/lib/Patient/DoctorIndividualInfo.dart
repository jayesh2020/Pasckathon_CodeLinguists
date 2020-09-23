import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pascathon/Patient/Dashboard.dart';
import 'package:pascathon/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../loader.dart';

class DoctorInfo extends StatefulWidget {
  Map<String, dynamic> _data;
  String _uid;
  String _diseaseName;
  String startDate;
  int severity;
  String prevMedicals;
  bool day;
  bool night;
  String bodyPart;
  File _file;
  DoctorInfo(this._data, this._uid,this._diseaseName,this.startDate,this.severity,this.prevMedicals,this.day,this.night,this.bodyPart,this._file);
  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo>
    with SingleTickerProviderStateMixin {
  DateTime startTime;
  DateTime endTime;
  int len;
  bool load = true;
  bool generateReport=true;
  TabController _controller;
  int _currentIndex = 0;
  Color mainColour = Color(0xFFea9b72);
  List<dynamic> appts = List();
  Map<String,List<dynamic>>mapp1;
  List<dynamic> appts1 = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('abcd${widget._file}');
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
      CollectionReference doctor =
          FirebaseFirestore.instance.collection('Doctors');
      DocumentSnapshot ds = await doctor.doc(widget._uid).get();
      if (ds.exists) {
        if (ds.data().containsKey('appointments')) {
          setState(() {
            print('wtf');
            mapp1=Map.from(ds.get('appointments'));
            print(mapp1);
//            mapp1=Map.from(ds.get('appointments'));
////            mapp1=Map.from(ds.get('appointments'));
            print(mapp1.containsKey(DateFormat('yyyy-MM-dd').format(DateTime.now())));
            appts=mapp1[DateFormat('yyyy-MM-dd').format(DateTime.now())];
            if(appts==null){
              print('wtf1');
              appts=List<dynamic>();
            }
            print(mapp1.containsKey(DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)))));
            appts1=mapp1[DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)))];
            if(appts1==null){
              appts1=List<dynamic>();
              print('wtf2');
            }
          });
        }
      }
      setState(() {
        load = false;
      });
  }

  addData(String time, int ind,String reportUrl) async {
    try {
      if (ind == 0) {
        appts.add(time);
        String date=DateFormat('yyyy-MM-dd').format(DateTime.now());
        CollectionReference doctor =
        FirebaseFirestore.instance.collection('Doctors');
//        List<String>abcd=List();
//        abcd.add('def');
//        abcd.add('efg');
//        _mapp1={
//          "abc":abcd
//        };
        mapp1[DateFormat('yyyy-MM-dd').format(DateTime.now())]=appts;
        doctor
            .doc(widget._uid)
            .update({"appointments": mapp1} );
      } else {
        appts1.add(time);
        String date=DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
        CollectionReference doctor =
        FirebaseFirestore.instance.collection('Doctors');
//        List<String>abcd=List();
//        abcd.add('def');
//        abcd.add('efg');
//        _mapp1={
//          "abc":abcd
//        };
        mapp1[DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)))]=appts1;
        doctor
            .doc(widget._uid)
            .update({"appointments": mapp1} );
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
      Map<String, String>mapp2;
      if(ind==0){
     mapp2 = {
        'patientName': "${patientInfo.data()['name']}",
        'appointmentTime': "$time",
        "patientProfilePic": "${patientInfo.data()['profilePic']}",
        "diseasePrediction": "${widget._diseaseName}",
        "appointmentDate":"${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
       "reportUrl":"$reportUrl",
      };}else{
        mapp2 = {
          'patientName': "${patientInfo.data()['name']}",
          'appointmentTime': "$time",
          "patientProfilePic": "${widget._data['profilePic']}",
          "diseasePrediction": "${widget._diseaseName}",
          "appointmentDate":"${DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1)))}",
          "reportUrl":"$reportUrl",
        };
      }
      await FirebaseFirestore.instance.collection('Doctors').doc(widget._uid)
          .collection('Appointments').add(mapp2)
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
          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                    height: 200.0,
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
                              height: 10,
                            ),
                            CheckboxListTile(value: generateReport, onChanged: (bool value) {
                              setState(() {
                                generateReport=value;
                              });
                            },
                              title: Text('Generate report',style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'MontserratReg',
                              ),),
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
                                        if(generateReport){
                                          await generationReport(time);
                                        }
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


  generationReport(String time)async{
    final pdf = pw.Document();
    final image = PdfImage.file(
      pdf.document,
      bytes: widget._file.readAsBytesSync(),
    );
    final Med = await rootBundle.load('fonts/Montserrat-Medium.ttf');
    final Bold = await rootBundle.load('fonts/Montserrat-Bold.ttf');
    final Reg = await rootBundle.load('fonts/Montserrat-Regular.ttf');
    final Semi = await rootBundle.load('fonts/Montserrat-SemiBold.ttf');
    String timeofpain;
    if(widget.day&&widget.night){
      timeofpain='Day and Night';
    }else if(widget.day){
      timeofpain='Day';
    }else{
      timeofpain='Night';
    }
    var info=await FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser.uid).get();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Align(
                alignment: pw.Alignment.center,
                child:
                pw.Text('Dermosolutions',style: pw.TextStyle(fontSize: 20,fontWeight: pw.FontWeight.bold,font: pw.Font.ttf(Bold),color: PdfColor.fromHex("ea9b72")))),
              pw.SizedBox(
                height: 20
              ),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Personal Information',style: pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold,font: pw.Font.ttf(Semi),color: PdfColor.fromHex("ea9b72")))),
              pw.SizedBox(height: 10),
              info.data()['name']!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Name: ${info.data()['name']}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000"))),):pw.Container(),
              info.data()['dateOfBirth']!="null"? pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Age: ${(DateTime.now().difference(DateFormat('yyyy-MM-dd').parse(info.data()['dateOfBirth'])).inDays/365).floor()}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),
              info.data()['gender']!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Gender: ${info.data()['gender']}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),
              info.data()['city']!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Address: ${info.data()['city']}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),
              pw.SizedBox(
                  height: 20
              ),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Contact Information',style:  pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold,font: pw.Font.ttf(Semi),color: PdfColor.fromHex("ea9b72")))),
              pw.SizedBox(height: 10),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Email: ${info.data()['email']}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))),
          info.data()['phoneNumber']!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Phone Number: ${info.data()['phoneNumber']}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),
              pw.SizedBox(
                  height: 20
              ),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Medical Information',style: pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold,font: pw.Font.ttf(Semi),color: PdfColor.fromHex("ea9b72")))),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Height: ${info.data()['height']} cms',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))),

              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Weight: ${info.data()['weight']} kgs',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))),

          info.data()['bloodGroup']!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Blood Group: ${info.data()['bloodGroup']}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),

              pw.SizedBox(
                  height: 20
              ),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Infection Details',style:  pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold,font: pw.Font.ttf(Semi),color: PdfColor.fromHex("ea9b72")))),
              pw.SizedBox(
                  height: 10
              ),
              widget.prevMedicals!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Start Date: ${widget.startDate}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Severity(out of 5): ${widget.severity}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))),
              widget.prevMedicals!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Previous Medications: ${widget.prevMedicals}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),
              widget.bodyPart!=null?pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Body Part infected: ${widget.bodyPart}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))):pw.Container(),
              widget.day==false&&widget.night==false?pw.Container():pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Pain during: $timeofpain',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000")))),
              pw.SizedBox(
                  height: 20
              ),
              pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child:
                  pw.Text('Model Predictions',style:  pw.TextStyle(fontSize: 18,fontWeight: pw.FontWeight.bold,font: pw.Font.ttf(Semi),color: PdfColor.fromHex("ea9b72")))),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child:
                pw.Text('Disease Name: ${widget._diseaseName}',style: pw.TextStyle(fontSize: 15,font: pw.Font.ttf(Med),color: PdfColor.fromHex("000000"))),
              ),
            ]
          );  //
//          pdf.addPage(pw.)// Center
        }));
    pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          ); // Center
        }));
    Directory appDocDir = await getTemporaryDirectory();
    String appDocPath = appDocDir.path;
    final file = File('$appDocPath/example.pdf');
    await file.writeAsBytes(pdf.save());
    print(file.path);
    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child('report')
        .child(FirebaseAuth.instance.currentUser.uid)
        .putFile(file)
        .onComplete;
    String downloadUrl;
    if (snapshot.error == null) {
      downloadUrl = await snapshot.ref.getDownloadURL();}
      print(downloadUrl);
    await addData(time, _currentIndex,downloadUrl);

  }

  showDialog2(BuildContext context){
    showDialog(context: context,builder: (BuildContext context){
      String selectedDate;

      dynamic selectedTime;
      Map<String,List<String>>mapp1=Map<String,List<String>>();
//      for(DateTime a=DateTime.now();a.isBefore(DateTime.now().add(Duration(days: 7)));a.add(Duration(days: 1))){
//        if(mapp1.containsKey([DateFormat('yyyy-MM-dd').format(a)])){
//        }else{
//
//        }
//      }
      return StatefulBuilder(
        builder: (BuildContext context,StateSetter setState){
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 200.0,
                  child: Center(
                    child: Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DateTimeField(
                              onChanged: (dateTime){
                                setState(() {
                                  selectedDate=DateFormat('yyyy-MM-dd').format(dateTime);
                                });
                              },
                              style: TextStyle(
                                fontFamily: 'MontserratMed',
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Appointment Date',
                                labelStyle: TextStyle(
                                  fontFamily: 'MontserratMed',
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              format: DateFormat("dd-MM-yyyy"),
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 6)));
                              },
                            ),
                            SizedBox(height: 10,),
                            DropdownButtonFormField<dynamic>(
                              style: TextStyle(
                                fontFamily: 'MontserratMed',
                                color: Colors.black,
                              ),
                              hint: Text('Appointment Time',style: TextStyle(
                                fontFamily: 'MontserratMed',
                                color: Colors.black,
                              ),),
                              value: selectedTime,
                              onChanged: (val){
                                setState(() {
                                  selectedTime=val;
                                });
                              },
                              items:selectedDate==null?null:mapp1[selectedDate].map((e) => DropdownMenuItem<dynamic>(value: mapp1[selectedDate],
                              child: Text('${mapp1[selectedDate]}'),
                             )),
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
//                                      await addData(time, _currentIndex);
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
                    ),
                  )),
            ),
          );
        },
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
                  Center(
                    child: Text(
                      'Clinic Address:-${widget._data['clinicAddress']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMed',
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget._data['experience'] == 'null'
                      ? Container()
                      : Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget._data['experience']} years experience',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontserratMed',
                              fontSize: 16,
                            ),
                          ),
                        ),

                  SizedBox(
                    height: 15,
                  ),
                  Divider(color: Colors.grey.shade300,thickness: 2,),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Slots Available for today and tomorrow',style: TextStyle( fontFamily: 'MontserratMed',
                      fontSize: 16),),
                  SizedBox(
                    height: 20,
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
                  _currentIndex == 0?GridView.builder(
                    shrinkWrap: true,
                        itemBuilder: (BuildContext context, int pos) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: appts.contains(DateFormat.jm()
                                      .format(startTime.add(
                                          Duration(minutes: pos * 30))))
                                  ? null
                                  : () {
                                      print(appts);

                                      print(appts.contains(
                                          DateFormat.jm().format(
                                              startTime.add(Duration(
                                                  minutes: pos * 30)))));

                                      showDialog1(
                                          context,
                                          DateFormat.jm().format(
                                              startTime.add(Duration(
                                                  minutes: pos * 30))));
                                    },
                              child: Container(
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),

                                  color: appts.contains(DateFormat.jm()
                                          .format(startTime.add(
                                              Duration(minutes: pos * 30))))
                                      ? Colors.grey.shade500
                                      : null,

                                  gradient: appts.contains(DateFormat.jm().
                                          format(startTime.add(
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
                      )
                      :GridView.builder(
                    shrinkWrap: true,
                        itemBuilder: (BuildContext context, int pos) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: appts1.contains(DateFormat.jm()
                                      .format(startTime.add(
                                          Duration(minutes: pos * 30))))
                                  ? null
                                  : () {
                                      print(appts1);
                                      print(appts1.contains(
                                          DateFormat.jm().format(
                                              startTime.add(Duration(
                                                  minutes: pos * 30)))));
                                      showDialog1(
                                          context,
                                          DateFormat.jm().format(
                                              startTime.add(Duration(
                                                  minutes: pos * 30))));
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: appts1.contains(DateFormat.jm()
                                          .format(startTime.add(
                                              Duration(minutes: pos * 30))))
                                      ? Colors.grey.shade500
                                      : null,
                                  gradient: appts1.contains(DateFormat.jm()
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
                SizedBox(height: 30,),
                  InkWell(
                    onTap: ()async{
//                      await showDialog2(context);
//                    await generationReport();
//                    Fluttertoast.showToast(msg: 'Success');
                    },
                    child: Material(
                      elevation: 2,
                      child: Container(
                        width: 200,
//                      width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),  gradient: LinearGradient(
                            colors: [
                              Color(0xFFea9b72),
                              Color(0xFFff9e33)
                            ]
                        )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          child: Center(child: Text('Book Appointment',style: TextStyle( fontSize: 16,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
