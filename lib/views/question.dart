import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../widgets/delete_question.dart';
import '../widgets/edit_question.dart';

class Questions extends StatefulWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final fbda = FirebaseDatabase.instance.ref();
  late Query _ref;

  @override
  void initState() {
    super.initState();
    _ref = fbda.child('Questions').orderByChild('questionId');
    // _ref = fbda.child('question');
  }

  Widget _buildItem({required Map data}) {
    Color taskColor = AppColors.blueShadeColor;
    return Container(
      height: 100,
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
      child: ListTile(
        leading: Container(
          width: 20,
          height: 20,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.center,
          child: CircleAvatar(
            backgroundColor: taskColor,
          ),
        ),
        title: Text(data['questionName']),
        subtitle: Text(data['questionDesc']),
        isThreeLine: true,
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'edit',
                child: const Text(
                  'Edit',
                  style: TextStyle(fontSize: 13.0),
                ),
                onTap: () {
                  String questId = (data['questionId']);
                  String questName = (data['questionName']);
                  String questDesc = (data['questionDesc']);
                  //String taskTag = (data['taskTag']);
                  Future.delayed(
                    const Duration(seconds: 0),
                    () => showDialog(
                      context: context,
                      builder: (context) => EditQuestions(
                        questionId: questId,
                        questionName: questName,
                        questionDesc: questDesc,
                        //taskTag: taskTag,
                      ),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                value: 'delete',
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 13.0),
                ),
                onTap: () {
                  String questId = (data['questionId']);
                  String questName = (data['questionName']);
                  Future.delayed(
                    const Duration(seconds: 0),
                    () => showDialog(
                      context: context,
                      builder: (context) => DeleteQuestions(
                          QuestionId: questId, QuestionName: questName),
                    ),
                  );
                },
              ),
            ];
          },
        ),
        dense: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: FirebaseAnimatedList(
        query: _ref,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          if (!snapshot.exists) {
            return const Text('No Questions to display');
          } else {
            Map data = snapshot.value as Map;
            data['key'] = snapshot.key;
            return _buildItem(data: data);
          }
        },
      ),
    );
  }
}
