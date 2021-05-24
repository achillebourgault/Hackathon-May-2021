import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class contacts_menu extends StatefulWidget {
  const contacts_menu({Key? key}) : super(key: key);
  static const title = "Contacts";
  static const icon = Icon(CupertinoIcons.person_3_fill);

  @override
  _contacts_menuState createState() => _contacts_menuState();
}

class _contacts_menuState extends State<contacts_menu> {
  final firstController = TextEditingController();
  final secondController = TextEditingController();
  final thirdController = TextEditingController();

  Future<void> saveStringInLocalMemory(String key, String value) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  Future<void> savePhoneNumbers() async {
    saveStringInLocalMemory("FIRST_CONTACT", firstController.text);
    saveStringInLocalMemory("SECOND_CONTACT", secondController.text);
    saveStringInLocalMemory("THIRD_CONTACT", thirdController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Material (
      child: Container(
        padding: const EdgeInsets.all(40.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 100),
                child: Text(
                  'Personnes à prévenir:',
                  style: GoogleFonts.candal(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: CupertinoColors.black,
                  ),
                ),
              ),
            new TextField(
              controller: firstController,
              decoration: new InputDecoration(labelText: "Contact n°1"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            ),
            new TextField(
              controller: secondController,
              decoration: new InputDecoration(labelText: "Contact n°2"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            ),
            new TextField(
              controller: thirdController,
              decoration: new InputDecoration(labelText: "Contact n°3"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
              onPressed: () => savePhoneNumbers(),
              child: Text("Sauvegarder"),
            ),
        ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstController.dispose();
    super.dispose();
  }
}