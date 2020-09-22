
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pascathon/Doctor/DoctorDashboard.dart';
import 'package:pascathon/signup.dart';
import 'package:pascathon/Patient/Dashboard.dart';
import 'ChooseRole.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final storage=FlutterSecureStorage();
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    check();
  }



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
//  return FutureBuilder(
//    future: storage.read(key: 'firstTime'),
//    builder: (BuildContext context,AsyncSnapshot<String>txt){
//      if(txt.hasData){
//        return Dashboard();
//      }else
//        return MyHomePage()
//    },
//  );
  }
}





class MyHomePage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _email;
  String _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    auth
//        .authStateChanges()
//        .listen((User user) {
//      if (user == null) {
//        print('User is currently signed out!');
//      } else {
//        print('User is signed in!');
//      }
//    });
  }
  Future handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
//    scopes: [
//      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
//    ],
      );
      await googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      User _user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      print("abcd${_user.phoneNumber}");
      print("abcd${_user.email}");
      CollectionReference collectionReference,collectionReference1;
      collectionReference = FirebaseFirestore.instance.collection('Doctors');
      DocumentSnapshot dS = await collectionReference.doc(_user.uid).get();

      collectionReference1 = FirebaseFirestore.instance.collection('Patients');
      DocumentSnapshot dS1 = await collectionReference1.doc(_user.uid).get();
      print(_user.uid);
      print(dS1.exists);
      if(dS1.exists) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      }else if(dS.exists){
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => DoctorDashboard()));
      }
      else
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ChooseRole(_user.displayName,_user.email,_user.phoneNumber,_user.uid)));
    } catch (e) {
      print(e);}
    return null;
  }

  Future login()async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$_email",
          password: "$_password"
      );
       User user=userCredential.user;
      CollectionReference collectionReference,collectionReference1;
      collectionReference = FirebaseFirestore.instance.collection('Doctors');
      DocumentSnapshot dS = await collectionReference.doc(user.uid).get();

      collectionReference1 = FirebaseFirestore.instance.collection('Patients');
      DocumentSnapshot dS1 = await collectionReference.doc(user.uid).get();
      if(dS.exists||dS1.exists)Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
      else
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ChooseRole(user.displayName,user.email,user.phoneNumber,user.uid)));

      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg:'No user found for that email.',backgroundColor: Colors.grey[900],textColor: Colors.white);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg:'Wrong password provided for that user.',backgroundColor: Colors.grey[900],textColor: Colors.white);
      }else{
        Fluttertoast.showToast(msg:e.code.toUpperCase(),backgroundColor: Colors.grey[900],textColor: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change inst  ances of widgets.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFFea9b72),
                  Color(0xFFff9e33)
                ]
            )
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 220,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFea9b72),
                    Color(0xFFff9e33)
                  ]
                )
              ),
              child: Center(
                child:Text('DERMOSOLUTIONS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'MontserratBold'
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(35),topLeft: Radius.circular(35)),
                  ),
                  child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Text('Login',
                        style: TextStyle(
                          fontFamily: 'MontserratSemi',
                            color: Colors.black,
                            fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFff9e33),width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                            child: TextFormField(
                              onChanged: (val){
                                setState(() {
                                  _email=val;
                                });
                              },
                                style: TextStyle( fontSize: 16,color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),
                                decoration: InputDecoration.collapsed(hintText: 'Email',hintStyle:  TextStyle( fontSize: 16,color: Colors.grey,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFff9e33),width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                            child: TextFormField(
                              onChanged: (val){
                                setState(() {
                                  _password=val;
                                });
                              },
                              obscureText: true,
                                style: TextStyle( fontSize: 16,color: Colors.black,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),
                                decoration: InputDecoration.collapsed(hintText: 'Password',hintStyle:  TextStyle( fontSize: 16,color: Colors.grey,fontStyle: FontStyle.normal,fontFamily: 'MontserratMed'),)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                          onTap: ()async{
                            await login();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),  gradient: LinearGradient(
                                colors: [
                                  Color(0xFFea9b72),
                                  Color(0xFFff9e33)
                                ]
                            )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              child: Center(child: Text('Log In',style: TextStyle( fontSize: 20,color: Colors.white,fontStyle: FontStyle.normal,fontFamily: 'MontserratSemi'),)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SignInButtonBuilder(
                            elevation: 2,
                            textColor: Colors.black,
                            mini: true,
                            shape: CircleBorder(),
                            icon: FontAwesomeIcons.google,
                            onPressed: ()async{
                              await handleGoogleSignIn(context);
                            }, backgroundColor: Colors.red.shade900, text: 'a',
                          ),
                          SizedBox(width: 5,),
                          Text('Sign in with Google',style: TextStyle( fontSize: 14,color: Colors.black,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontFamily: 'MontserratReg'),),
                        ],
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('New here, ',style: TextStyle(color: Color(0xFFff9e33),fontFamily: 'MontserratMed',fontSize:   15),),
                          Text('Sign Up',style: TextStyle(color: Color(0xFFff9e33),fontFamily: 'MontserratSemi',decoration: TextDecoration.underline,fontSize: 15),),
                        ],
                      ),onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SignUp()));
                      },)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),//// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
