import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'help_menu.dart';

class main_menu extends StatefulWidget {
  const main_menu({Key? key}) : super(key: key);
  static const title = "Signaler une urgence";
  static const icon = Icon(CupertinoIcons.phone_fill);

  @override
  _main_menuState createState() => _main_menuState();
}

class _main_menuState extends State<main_menu> {
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {});
    });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7.00, 24.00, 00.00, 00.00),
        child: Column(
          children: [
            Align (
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  'Signaler une urgence',
                  style: GoogleFonts.candal(
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                    color: CupertinoColors.black,
                  ),
                ),
              ),
            ),
            Align (
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 200, left: 38),
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: CupertinoButton(
                    color: CupertinoColors.systemRed,
                    child: Text("J'ai besoin d'aide", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (context) {
                          return CupertinoActionSheet(
                            title: Text('Voulez vous lancer une alerte ?'),
                            actions: [
                              CupertinoActionSheetAction(
                                child: const Text("Oui j'ai besoin d'aide"),
                                isDestructiveAction: true,
                                onPressed: () => Navigator.push( context,
                                CupertinoPageRoute(builder: (context) => SimpleRecorder())
                                ),
                              ),
                              CupertinoActionSheetAction(
                                child: const Text('Non'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
