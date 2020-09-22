import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pascathon/Patient/DoctorIndividualInfo.dart';
import 'package:pascathon/loader.dart';

class DoctorList extends StatefulWidget {
  String _disaeaseName;
  DoctorList(this._disaeaseName);
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {


  List<Map<String,dynamic>>list=List();
  bool load=true;
  List<String>ids=List<String>();

  createList()async{
    list=List();
    var city=await FirebaseFirestore.instance.collection('Patients').doc(FirebaseAuth.instance.currentUser.uid).get();
    String c=city.data()['city'];
    var snapshot=await FirebaseFirestore.instance.collection('Doctors').get();
    List<QueryDocumentSnapshot>sna=snapshot.docs;
    for(int i=0;i<sna.length;i++){
      print(sna[i].data());
      print(sna[i].id);
      if(sna[i].data()['city']==c){
        list.add(sna[i].data());
        ids.add(sna[i].id);
      }
    }
    print(list.length);
    setState(() {
      load=false;
    });
    print(list);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createList();
  }

  @override
  Widget build(BuildContext context) {
    return load==true?Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: loader,
      decoration: BoxDecoration(gradient: LinearGradient(
          colors: [
            Color(0xFFea9b72),
            Color(0xFFff9e33)
          ]
      )),
    ):Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFea9b72),
        title: Text('Doctors',style: GoogleFonts.aBeeZee(fontSize: 20.0, color: Colors.white,),),
      ),
      body: ListView.builder(itemBuilder: (BuildContext context,int pos){
        return Padding(
          padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 8),
          child: Material(
            elevation: 5,
              borderRadius: BorderRadius.circular(5),
            child: InkWell(
              onTap: (){
                print(
                  'abc'
                );
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DoctorInfo(list[pos],ids[pos],widget._disaeaseName)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
                ),
                child: ListTile(
                  title:  Text('Dr. ${list[pos]['name']}',style: TextStyle(
                      color: Colors.black,fontFamily: 'MontserratSemi',fontSize: 16
                  ),),
                  subtitle: Column(
                    children: [
                      SizedBox(height: 10,),
                      Text(list[pos]['clinicAddress'],style: TextStyle(
                          color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14
                      ),),
                      list[pos]['phoneNumber']!='null'?Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Icon(Icons.phone,color:Color(0xFFea9b72),size: 16,),
                            SizedBox(width: 10,),
                            Text(list[pos]['phoneNumber'],style: TextStyle(
                                color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14
                            ),),
                          ],
                        ),
                      ):Container(),
                      list[pos]['email']!='null'?Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Icon(Icons.email,color:Color(0xFFea9b72),size: 16,),
                            SizedBox(width: 10,),
                            Text(list[pos]['email'],style: TextStyle(
                                color: Colors.black,fontFamily: 'MontserratMed',fontSize: 14
                            ),),
                          ],
                        ),
                      ):Container(),
                      SizedBox(height: 10,)
                    ],
                  ),
                  leading: ClipOval(child: list[pos]['profilePic']==null?Image.asset('assets/images/placeholder.jpg',height: 50,width: 50,):FadeInImage.assetNetwork(placeholder:'assets/images/placeholder.jpg', image: list[pos]['profilePic'],height: 50,width: 50,imageCacheHeight: 50,imageCacheWidth: 50,)),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: list.length,),
    );
  }
}
