import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pascathon/Patient/BasicInfo.dart';
import 'package:pascathon/Patient/CustomSliderThumbRect.dart';
import 'package:pascathon/Patient/DoctorList.dart';


class QuestionAire extends StatefulWidget {

  String _disaeaseName;
  File _file;
  QuestionAire(this._disaeaseName,this._file);
  @override
  _QuestionAireState createState() => _QuestionAireState();
}

class _QuestionAireState extends State<QuestionAire> {

  String startDate;
  int severity=0;
  String prevMedicals;
  bool day=false;
  bool night=false;
  String bodyPart;
  @override
  Widget build(BuildContext context) {

    Map<String, bool> values = {
      'Day': false,
      'Night': false,
    };

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AppBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text('Before you consult the doctor, we recommend you to fill some information',style: TextStyle(
                          color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14
                      ),),
                    ),
                    SizedBox(height: 20,),
                    DateTimeField(
                      onChanged: (dateTime){
                        setState(() {
                          startDate=DateFormat('dd-MM-yyyy').format(dateTime);
                        });
                      },
                      style: TextStyle(
                        fontFamily: 'MontserratMed',
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Start of infection',
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
                    SizedBox(height: 20,),
                  Align(child: Text('Rate severity out of 5',style: TextStyle( color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14),),alignment: Alignment.centerLeft,),
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
//                    overlayColor: Color(0x29EB1555),
                    ),
                    child: Slider(
                      value: severity.toDouble(),
                      label: '$severity',
                      divisions: 5,
                      min: 0,
                      max: 5,
                      onChanged: (double newhieght) {
                        setState(() {
                          severity = newhieght.round();
                        });
                      },
                    ),
                  ),
                    TextFormField(
                      onChanged: (val){
                        setState(() {
                          bodyPart=val;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Previous Medications',
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
                          prevMedicals=val;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Body part infected',
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
                    Align(child: Text('Time of day where you feel most pained',style: TextStyle( color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14),),alignment: Alignment.centerLeft,),
                   SizedBox(height: 20,),
                    CheckboxListTile(
                      activeColor: Color(0xFFea9b72),
                      title: new Text('Day',style:  TextStyle( color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14),),
                      value: day,
                      onChanged: (bool value) {
                        setState(() {
                          day = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      activeColor: Color(0xFFea9b72),
                      title: new Text('Night',style:  TextStyle( color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14),),
                      value: night,
                      onChanged: (bool value) {
                        setState(() {
                          night = value;
                        });
                      },
                    ),
                    SizedBox(height: 30,),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DoctorList(widget._disaeaseName,startDate,
                           severity,
                          prevMedicals,
                          day,
                          night,
                          bodyPart,widget._file)));
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
  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



