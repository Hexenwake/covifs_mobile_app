import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late String _email;
  late String _password;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _createUser() async {
    try{
      UserCredential userCredential = await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      print("user: $userCredential");
    }on FirebaseAuthException catch (e) {
      //print("Error: $e");
    }catch (e){
      //_error = "Error: $e";
      print("Error: $e");
    }
  }

  Future<void> _login() async {
    try{
      UserCredential userCredential = await FirebaseAuth
          .instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      print("user: $userCredential");

      final User? user = auth.currentUser;
      final uid = user!.uid;
      print(uid);
    }on FirebaseAuthException catch (e) {
      //print("Error: $e");
    }catch (e){
      print("Error: $e");
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //
  //           const Text(
  //             "LOGIN TO IFS APP",
  //             style: TextStyle(
  //               fontSize: 20,
  //             ),
  //           ),
  //
  //           const SizedBox(
  //               height: 30
  //           ),
  //
  //           Container(
  //             width: 340,
  //             height: 50,
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.6),
  //                     spreadRadius: 2,
  //                     blurRadius: 2,
  //                     offset: const Offset(0, 1),// changes position of shadow
  //                   ),]
  //             ),
  //             child:  TextField(
  //               onChanged: (value){
  //                 _email = value;
  //               },
  //               decoration: InputDecoration(
  //                   filled: true,
  //                   hintStyle: TextStyle(color: Colors.grey[500],),
  //                   hintText: "Username/Email",
  //                   fillColor: Colors.white70),
  //             ),
  //           ),
  //
  //           const SizedBox(
  //             height: 10,
  //           ),
  //
  //           Container(
  //             width: 340,
  //             height: 50,
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.6),
  //                     spreadRadius: 2,
  //                     blurRadius: 2,
  //                     offset: const Offset(0, 1),// changes position of shadow
  //                   ),]
  //             ),
  //             child:  TextField(
  //               obscureText: true,
  //               onChanged: (value){
  //                 _password = value;
  //               },
  //               decoration: InputDecoration(
  //                   filled: true,
  //                   hintStyle: TextStyle(color: Colors.grey[500],),
  //                   hintText: "Password",
  //                   fillColor: Colors.white70),
  //             ),
  //           ),
  //
  //           SizedBox(
  //             height: 20,
  //           ),
  //
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               GestureDetector(
  //                 onTap: (){
  //                   _login();
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.black87,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.6),
  //                           spreadRadius: 2,
  //                           blurRadius: 2,
  //                           offset: const Offset(0, 1),// changes position of shadow
  //                         ),]
  //                   ),
  //                   width: 340,
  //                   height: 50,
  //                   child: const Align(
  //                     alignment: Alignment.center,
  //                     child: Text("LOG IN",
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         //fontWeight: FontWeight.bold,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //
  //               /*
  //               TextButton(
  //                 style: TextButton.styleFrom(
  //                   primary: Colors.black,
  //                 ),
  //                   onPressed: (){
  //                     _login();
  //                   },
  //                   child: Text("LOG IN",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 15
  //                     ),
  //                   ),
  //               ),*/
  //
  //               GestureDetector(
  //                 onTap: (){
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => sign_up(),
  //                       )
  //                   );
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.6),
  //                           spreadRadius: 2,
  //                           blurRadius: 2,
  //                           offset: const Offset(0, 1),// changes position of shadow
  //                         ),]
  //                   ),
  //                   width: 340,
  //                   height: 50,
  //                   child: const Align(
  //                     alignment: Alignment.center,
  //                     child: Text("SIGN UP",
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                         //fontWeight: FontWeight.bold,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            // backgroundColor:Colors.black38,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  height: 100.h,
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(90)),
                          // gradient: LinearGradient(
                          //   colors: [(Colors.black38), Colors.black87],
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          // ),
                          color: Colors.black,
                        ),
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: const Text(
                                    'Contactless Feedback Admin',
                                    style: TextStyle(fontSize: 40, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 20, top: 20),
                                  alignment: Alignment.bottomRight,
                                  child: const Text(
                                    "Login to App",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                )
                              ],
                            )),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200],
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: Color(0xffEEEEEE)),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value){
                            _email = value;
                          },
                          decoration: const InputDecoration(
                            labelText: "Enter Email",
                            border: OutlineInputBorder(),
                            icon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200],
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: Color(0xffEEEEEE)),
                          ],
                        ),
                        child: TextField(
                          obscureText: true,
                          onChanged: (value){
                            _password = value;
                          },
                          decoration: const InputDecoration(
                            labelText: "Enter Password",
                            border: OutlineInputBorder(),
                            focusColor: Color(0xffF5591F),
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.black,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {}, child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          )
                          )
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          _login();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [(Colors.black), Colors.black],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200],
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 50,
                                  color: Color(0xffEEEEEE)),
                            ],
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const sign_up()),
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.black38,
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
