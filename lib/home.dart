import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../views/dashboard.dart';
import '../views/graph.dart';
import 'edit_page.dart';
import 'main.dart';
import 'review_graph.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final fbda = FirebaseDatabase.instance.ref();

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MANAGER'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (result) {
              if (result == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => EditPage()));
              }

              if (result == 1) {
                _signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LandingPage()));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('Sign Out'),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('JANITOR', style: TextStyle(height: 2, fontSize: 12)),
            ),
            Tab(
              child: Text('MAINTENANCE',
                  style: TextStyle(height: 2, fontSize: 12)),
            ),
            Tab(
              child:
                  Text('DASHBOARD', style: TextStyle(height: 2, fontSize: 12)),
            ),
          ],
        ),
      ),
      body: Navigator(
        key: _navKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            controller: _tabController,
            children: [
              Janitor(),
              Maintainence(),

              Column(
                children: const [
                  Expanded(
                    flex: 3,
                      child: Review_Graph()),
                  Expanded(
                    flex: 1,
                      child: Dashboard()),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class Janitor extends StatefulWidget {
  const Janitor({Key? key}) : super(key: key);

  @override
  _JanitorState createState() => _JanitorState();
}

class _JanitorState extends State<Janitor> {
  final fbda = FirebaseDatabase.instance.ref();
  late Query _ref;

  //late final String documentId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = fbda.child('janitor').orderByChild('id');
  }

  //final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('janitor').snapshots();

  Widget _buildItem({required Map contact}) {
    return Column(
      children: [
        Container(
            // margin: const EdgeInsets.only(top: 10, bottom: 20),
            height: 20.h,
            width: 100.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 2.h, top: 2.h, right: 2.h, bottom: 2.h),
                        height: 10.h,
                        width: 20.w,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        // child: const Text("test") ,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      const Text("VIEW MORE",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                  width: 70.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //worker id
                      Container(
                        alignment: Alignment.topCenter,
                        margin:
                            EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                        height: 3.h,
                        //width: 80.w,
                        child: Text(
                          "Worker ${contact['id']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      //name and tick icons
                      Container(
                          alignment: Alignment.topCenter,
                          margin:
                              EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                          height: 3.h,
                          //width: 70.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${contact['first_name']} ${contact['last_name']}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.orange,
                                size: 20,
                              )
                            ],
                          )),

                      //ratings
                      Container(
                        alignment: Alignment.topCenter,
                        margin:
                            EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                        height: 3.h,
                        //width: 80.w,
                        child: Text(
                          "Rating: ${contact['rating']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                width: 100.w,
                height: 95.h,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FirebaseAnimatedList(
                    query: _ref,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map contact = snapshot.value as Map;
                      contact['key'] = snapshot.key;
                      return _buildItem(contact: contact);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class Maintainence extends StatefulWidget {
  const Maintainence({Key? key}) : super(key: key);

  @override
  _MaintainenceState createState() => _MaintainenceState();
}

class _MaintainenceState extends State<Maintainence> {
  final fbda = FirebaseDatabase.instance.ref();

  late Query _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = fbda.child('maintenance').orderByChild('id');
  }

  //final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('maintenance').snapshots();

  Widget _buildItem({required Map contact}) {
    return Column(
      children: [
        Container(
            // margin: const EdgeInsets.only(top: 10, bottom: 20),
            height: 20.h,
            width: 100.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 2.h, top: 2.h, right: 2.h, bottom: 2.h),
                        height: 10.h,
                        width: 20.w,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        // child: const Text("test") ,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      const Text("VIEW MORE",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                  width: 70.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //worker id
                      Container(
                        alignment: Alignment.topCenter,
                        margin:
                            EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                        height: 3.h,
                        //width: 80.w,
                        child: Text(
                          "Worker ${contact['id']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      //name and tick icons
                      Container(
                          alignment: Alignment.topCenter,
                          margin:
                              EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                          height: 3.h,
                          //width: 70.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${contact['first_name']} ${contact['last_name']}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.orange,
                                size: 20,
                              )
                            ],
                          )),

                      //ratings
                      Container(
                        alignment: Alignment.topCenter,
                        margin:
                            EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                        height: 3.h,
                        //width: 80.w,
                        child: Text(
                          "Rating: ${contact['rating']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Container(
                width: 100.w,
                height: 95.h,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FirebaseAnimatedList(
                    query: _ref,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map contact = snapshot.value as Map;
                      contact['key'] = snapshot.key;
                      return _buildItem(contact: contact);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

//----------------------DASHBOARD--------------------------//

// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   _DashboardState createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   DatabaseReference fbda = FirebaseDatabase.instance.ref();
//
//   late Query _ref;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _ref = fbda.child('toilet').orderByChild('id');
//   }
//
//   //final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('dashboard').snapshots();
//
//   Widget _buildItem({required Map contact}) {
//     return Container(
//       height: 20.h,
//       width: 100.w,
//       decoration: BoxDecoration(
//           color: Colors.black87,
//           borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(10),
//               topRight: Radius.circular(10),
//               bottomLeft: Radius.circular(10),
//               bottomRight: Radius.circular(10)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.6),
//               spreadRadius: 2,
//               blurRadius: 2,
//               offset: const Offset(0, 1), // changes position of shadow
//             ),
//           ]),
//       child: Padding(
//         padding: EdgeInsets.all(1.w),
//         child: Row(
//           children: [
//             Container(
//               width: 50.w,
//               alignment: Alignment.topCenter,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                     // alignment: Alignment.topLeft,
//                     child: Text(
//                       "Toilet ID: ${contact['toilet_id']}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 1.h,
//                   ),
//                   Container(
//                     alignment: Alignment.topCenter,
//                     height: 3.h,
//                     child: Row(
//                       children: [
//                         Container(
//                           //margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
//                           child: RatingBar.builder(
//                               initialRating: double.parse(contact['Rating']),
//                               minRating: double.parse(contact['Rating']),
//                               maxRating: double.parse(contact['Rating']),
//                               direction: Axis.horizontal,
//                               allowHalfRating: false,
//                               itemBuilder: (context, index) {
//                                 return const Icon(Icons.star,
//                                     color: Colors.orange);
//                               },
//                               onRatingUpdate: (value) {}),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 2.h,
//                   ),
//                   if (contact['Feedback_1'] != '') ...[
//                     Row(
//                       children: [
//                         Text(
//                           "Feedback 1 : ${contact['Feedback_1']}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           "Status : ${contact['Feedback_1_status']}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                   SizedBox(
//                     height: 1.h,
//                   ),
//                   if (contact['Feedback_2'] != '') ...[
//                     Row(
//                       children: [
//                         Text(
//                           "Feedback 2 : ${contact['Feedback_2']}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           "Status : ${contact['Feedback_2_status']}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                   SizedBox(
//                     height: 1.h,
//                   ),
//                   if (contact['Feedback_3'] != '') ...[
//                     Row(
//                       children: [
//                         Text(
//                           "Feedback 3 : ${contact['Feedback_3']}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           "Status : ${contact['Feedback_2_status']}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     )
//                   ]
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 Container(
//                   alignment: Alignment.topCenter,
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 0.0, horizontal: 5.0),
//                   child: Text(
//                     "Location: ${contact['toilet_location']}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 Text(
//                   "Review Date : ${contact['review_date']}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 Text(
//                   "Review Time : ${contact['review_time']}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Column(
//             children: [
//               Container(
//                 width: 100.w,
//                 height: 95.h,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: FirebaseAnimatedList(
//                     query: _ref,
//                     itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                         Animation<double> animation, int index) {
//                       Map contact = snapshot.value as Map;
//                       contact['key'] = snapshot.key;
//                       return _buildItem(contact: contact);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

// Route<dynamic> controller(String value){
//   switch (value) {
//     case 'Logout':
//       _signOut();
//       break;
//     case 'Edit':
//       return MaterialPageRoute(builder: (context) => EditPage());
//     default:
//       throw('this route name does not exist');
//   }
// }

// dynamic handleClick(String value) {
//   switch (value) {
//     case 'Logout':
//       return _signOut();
//       break;
//     case 'Edit':
//       return MaterialPageRoute(builder: (context) => EditPage());
//     default:
//       throw ('this route name does not exist');
//   }
// }

void _handleClick(BuildContext ctx, String value) async {
  switch (value) {
    case 'Logout':
      _signOut();
      break;
    case 'Edit':
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => EditPage()));
      break;
  }
}
// class _ChartData {
//   _ChartData({this.x, this.y});
//
//   final DateTime? x;
//   final int? y;
// }
//
// class SubFirstPage extends StatelessWidget {
//   const SubFirstPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('First Nested Page'),
//       ),
//       body: const Center(
//         child: Text('From First Page'),
//       ),
//     );
//   }
// }
//
// class SubSecondPage extends StatelessWidget {
//   const SubSecondPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Second Nested Page'),
//       ),
//       body: const Center(
//         child: Text('From Second Page'),
//       ),
//     );
//   }
// }
