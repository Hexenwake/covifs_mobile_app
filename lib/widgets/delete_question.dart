import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DeleteQuestions extends StatefulWidget {
  final String QuestionId, QuestionName;

  const DeleteQuestions({Key? key, required this.QuestionId, required this.QuestionName}) : super(key: key);

  @override
  State<DeleteQuestions> createState() => _DeleteQuestionsState();
}

class _DeleteQuestionsState extends State<DeleteQuestions> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Delete Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              const Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              Text(
                widget.QuestionName.toString(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteTasks();
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future _deleteTasks() async {
    var collection = FirebaseDatabase.instance.ref().child('Questions');
    collection
        .child(widget.QuestionId)
        .remove()
        .then(
          (_) => Fluttertoast.showToast(
          msg: "Task deleted successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0),
    )
        .catchError(
          (error) => Fluttertoast.showToast(
          msg: "Failed: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0),
    );
  }
}
