import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'main_menu.dart';
import 'contacts_menu.dart';

void main() {
  runApp(ConnectedKeychainApp());
}

class ConnectedKeychainApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connected Keychain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            label: main_menu.title,
            icon: main_menu.icon,
          ),
          BottomNavigationBarItem(
            label: contacts_menu.title,
            icon: contacts_menu.icon,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: main_menu.title,
              builder: (context) => main_menu(),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: contacts_menu.title,
              builder: (context) => contacts_menu(),
            );
          default:
            assert(false, 'Unexpected tab');
            return SizedBox.shrink();
        }
      },
    );
  }
}