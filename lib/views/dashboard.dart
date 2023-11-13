import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../utils/colors.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final fbda = FirebaseDatabase.instance.ref();
  final dbRef = FirebaseDatabase.instance.ref().child("validation");
  late Query _ref_1, _ref_2;
  Map<dynamic, dynamic> lastData = {};
  Map<dynamic, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _ref_1 = fbda.child('reviews');
    _ref_2 = fbda.child('validation');
    dbRef.orderByKey().limitToLast(1).onChildAdded.listen((event) {
      setState(() {
        lastData = {event.snapshot.key: event.snapshot.value};
      });
    });

    dbRef.once().then((event) {
      final data = event.snapshot;
    });
  }

  // Widget _buildItem({required Map data}) {
  //   Color taskColor = AppColors.blueShadeColor;
  //   return SizeTransition(
  //     sizeFactor: ,
  //     child: ListTile(
  //       leading: Container(
  //         width: 20,
  //         height: 20,
  //         padding: const EdgeInsets.symmetric(vertical: 4.0),
  //         alignment: Alignment.center,
  //         child: CircleAvatar(
  //           backgroundColor: taskColor,
  //         ),
  //       ),
  //       title: Text(data['key']),
  //       subtitle: Text(data['value']),
  //       isThreeLine: true,
  //       dense: true,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FirebaseAnimatedList(
                query: _ref_2,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String? itemKey = snapshot.key;
                  dynamic itemValue = snapshot.value;

                  Color avatarColor;
                  // Set the CircleAvatar color based on the itemKey value
                  if (itemValue == 'valid') {
                    avatarColor = Colors.blue;
                  } else if (itemValue == 'invalid') {
                    avatarColor = Colors.red;
                  } else {
                    avatarColor = Colors.grey; // Default color if key does not match 'valid' or 'invalid'
                  }

                  return Container(
                    height: 70,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 5.0,
                          offset:
                              Offset(0, 5), // shadow direction: bottom right
                        ),
                      ],
                    ),
                    child: Material(
                      // type: MaterialType.transparency,
                      child: ListTile(
                        leading: Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            // Use the avatarColor determined above
                            backgroundColor: avatarColor,
                          ),
                        ),
                        title: Text('$itemKey'),
                        subtitle: Text('$itemValue'),
                        isThreeLine: true,
                        dense: true,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 5.0,
                offset: Offset(0, 5), // shadow direction: bottom right
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: ListTile(
              leading: Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                alignment: Alignment.center,
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
              ),
              title: Text('Latest: ${lastData.values.first.toString()}'),
              subtitle: Text('Date-time:  ${lastData.keys.first.toString()}'),
            ),
          ),
        ));
  }
}


