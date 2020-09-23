import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pascathon/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {

  int selectedIndex=0;
  bool load=true;
  DocumentSnapshot userInfo;
  List<dynamic> response;
  List<QueryDocumentSnapshot>sna;
  ReceivePort _port = ReceivePort();
  bool _permissionReady = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
//    IsolateNameServer.registerPortWithName(
//        _port.sendPort, 'downloader_send_port');
//    _port.listen((dynamic data) {
//      String id = data[0];
//      DownloadTaskStatus status = data[1];
//      int progress = data[2];
//      setState(() {});
//      FlutterDownloader.registerCallback(downloadCallback);
//    });
  }


  Future<bool> _checkPermission() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> download(String url,String key) async {
    _permissionReady = await _checkPermission();
    _checkPermission().then((hasGranted) {
      setState(() {
        _permissionReady = hasGranted;
      });
    });

     var appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    print('key$key');
    List k = key.split('/');
    print(k);

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      fileName: k[k.length - 1],
      savedDir: appDocPath,
      showNotification:
      true, // show download progress in status bar (for Android)
      openFileFromNotification:
      true, // click on notification to open downloaded file (for Android)
    );
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  getData()async{
    userInfo=await FirebaseFirestore.instance.collection('Doctors').doc(FirebaseAuth.instance.currentUser.uid).get();
    var snapshot=await FirebaseFirestore.instance.collection('Doctors').doc(FirebaseAuth.instance.currentUser.uid).collection('Appointments').get();

    setState(() {
      sna=snapshot.docs;
      load=false;
    });

//    print(userInfo);
//    setState(() {
//      var response1=userInfo.data()['appointments'];
//      response=response1[DateFormat('yyyy-MM-dd').format(DateTime.now())] as List;
//      print(response);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return load==true?Container(color: Colors.white,child: loader1,):SafeArea(
      child: Scaffold(
        body: sna.length==0?Column(
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
                Text('No appointments lined up',style: GoogleFonts.aBeeZee(color: Colors.black,fontSize: 18),),
               ],
            ),
          ],
        ):Column(
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
          SizedBox(height: 30,),
          Text('My Appointments',style: TextStyle(
            color: Color(0xFFea9b72),fontFamily: 'MontserratSemi',fontSize: 24,
//              decoration: TextDecoration.underline
          ),),
         Container(
           height: 500,
           child: PageView.builder(
             itemBuilder: (BuildContext context,int pos){
               return Card(
                 margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 60.0),
                 elevation: 20.0,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ClipRRect(
                       child: sna[pos].data()['patientProfilePic']==null?Image.asset('assets/images/placeholder.jpg',height: 150,width: 150,):FadeInImage.assetNetwork(placeholder:'assets/images/placeholder.jpg', image: sna[pos].data()['patientProfilePic'],height: 150,width: 150,imageCacheHeight: 150,imageCacheWidth: 150,),borderRadius:  BorderRadius.all(Radius.circular(20.0)),),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Patient Name:- ${sna[pos].data()['patientName']}",style: TextStyle(
                         color: Colors.black,fontFamily: 'MontserratMed',fontSize: 18,
//              decoration: TextDecoration.underline
                       ),),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Disease predicted:- ${sna[pos].data()['diseasePrediction']}",style: TextStyle(
                         color: Colors.black,fontFamily: 'MontserratMed',fontSize: 18,
//              decoration: TextDecoration.underline
                       )),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Appointment Date:- ${sna[pos].data()['appointmentDate']}",style: TextStyle(
                         color: Colors.black,fontFamily: 'MontserratMed',fontSize: 18,
//              decoration: TextDecoration.underline
                       )),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Appointment Time:- ${sna[pos].data()['appointmentTime']}",style: TextStyle(
                         color: Colors.black,fontFamily: 'MontserratMed',fontSize: 18,
//              decoration: TextDecoration.underline
                       )),
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("View Report",style: TextStyle(
                           color: Colors.black,fontFamily: 'MontserratMed',fontSize: 18,
//              decoration: TextDecoration.underline
                         )),
                         SizedBox(width: 5,),
                         IconButton(icon: Icon(Icons.web,color: Color(0xFFea9b72),),onPressed: ()async{

                           String url = sna[pos].data()['reportUrl'];
                           if (await canLaunch(url)) {
                             await launch(url);
                           } else {
                             throw 'Could not launch $url';
                           }
//                         await download(sna[pos].data()['reportUrl'],sna[pos].data()['diseasePrediction']);
                         },)
                       ],
                     )
                   ],
                 ),
               );
             },
             itemCount: sna.length,
           ),
         )
          ],
        ),
//        bottomNavigationBar: CurvedNavigationBar(
//          index: selectedIndex,
//          height: 60,
//          color: Color(0xFFea9b72),
//          backgroundColor: Colors.white,
//          items: [
//            Icon(Icons.home,color: Colors.white,),
//            Icon(Icons.event_note,color: Colors.white,),
//            Icon(Icons.person,color: Colors.white,),
//          ],
//          onTap: (int x)async{
////            print(x);
////            switch (x){
////              case 0:setState(() {
////                selectedIndex=0;
////              });
////              break;
////              case 1:showSheet();
////              break;
////              case 3:setState(() {
////                selectedIndex=3;
////              });
////              break;
////            }
//          },
//        )
      ),
    );
  }
}
