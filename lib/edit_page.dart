import 'package:dp3_manager_statistics/views/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_question.dart';
import 'main.dart';
import 'home.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final PageController pageController = PageController(initialPage: 0);
  late int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Questions'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (result) {
              if (result == 1) {
                _signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LandingPage()));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Sign Out'),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.black87,
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddQuestionDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black12,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                pageController.jumpToPage(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.square_list),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.tag),
                label: '',
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        children: const <Widget>[
          Center(
            child: Questions(),
          ),
          Center(
            child: Questions(),
          ),
        ],
      ),
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

void handleClick(String value) {
  switch (value) {
    case 'Logout':
      _signOut();
      break;
    case 'Edit':
      break;
  }
}
