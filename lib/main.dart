import 'home.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: LandingPage(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contactless Vision Instant Feedback System',
        theme: ThemeData(
          // primarySwatch: Color(0xff6f86d6),
        ),
        home:AnimatedSplashScreen(
            splash: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'CUF SYSTEM MANAGER APP',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Contactless User Feedback System',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),]
                  ),
                ],
              ),
            ),
            duration: 3000,
            nextScreen: LandingPage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: const Color(0xff131313)
        )
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage>{

  final fbda = FirebaseDatabase(
      databaseURL: "https://fir-flutterlogin-bfc07-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref().child('Users');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.done){
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                Object? user = snapshot.data;

                if (user != null) {
                  return Home();
                } else {
                  return Login();
                }
              }


              return const Scaffold(
                body: Center(
                  child: Text("Checking Authentication..."),
                ),
              );
            },
          );
        }

        return const Scaffold(
          body: Center(
            child: Text("Connecting to the app..."),
          ),
        );
      },
    );
  }
}



