import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {

  int selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
      ),
        bottomNavigationBar: CurvedNavigationBar(
          index: selectedIndex,
          height: 60,
          color: Color(0xFFea9b72),
          backgroundColor: Colors.white,
          items: [
            Icon(Icons.home,color: Colors.white,),
            Icon(Icons.event_note,color: Colors.white,),
            Icon(Icons.person,color: Colors.white,),
          ],
          onTap: (int x)async{
//            print(x);
//            switch (x){
//              case 0:setState(() {
//                selectedIndex=0;
//              });
//              break;
//              case 1:showSheet();
//              break;
//              case 3:setState(() {
//                selectedIndex=3;
//              });
//              break;
//            }
          },
        )
    );
  }
}
