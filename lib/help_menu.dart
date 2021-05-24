import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

typedef _Fn = void Function();

class SimpleRecorder extends StatefulWidget {
  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  final String _mPath = 'audio_record.aac';
  final telephony = Telephony.instance;
  late Position _position;
  late Geolocator _geolocator;
  late String first_contact = "";
  late String second_contact = "";
  late String third_contact = "";

  @override
  void initState() {
    _mPlayer!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
        record();
      });
    });
    super.initState();
    _geolocator = Geolocator();
    sendSms();
  }

  Future<void> sendSms() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String first = prefs.getString("FIRST_CONTACT") ?? '';
    String second = prefs.getString("SECOND_CONTACT") ?? '';
    String third = prefs.getString("THIRD_CONTACT") ?? '';
    first_contact = first;
    second_contact = second;
    third_contact = third;
    String message;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position newPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).timeout(new Duration(seconds: 5));
    setState(() {
      _position = newPosition;
    });
    message = "J'ai besoin d'aide, voici ou je me trouve: https://www.google.com/maps/search/?api=1&query=@${_position != null ? _position.latitude.toString() : '0'},${_position != null ? _position.longitude.toString() : '0'}";
    if (result != null && result) {
      await telephony.sendSms(
          to: "$first",
          message: "$message"
      );
      await telephony.sendSms(
          to: "$second",
          message: "$message"
      );
      await telephony.sendSms(
          to: "$third",
          message: "$message"
      );
    }
    if (!mounted) return;
  }

  @override
  void dispose() {
    _mPlayer!.closeAudioSession();
    _mPlayer = null;

    _mRecorder!.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openAudioSession();
    _mRecorderIsInited = true;
  }

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
        fromURI: _mPath,
        whenFinished: () {
          setState(() {});
        })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      //record();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10),
            child : SizedBox(
              width: 300,
              height: 75,
              child: ElevatedButton(
                onPressed: getRecorderFn(),
                child: Text(
                    _mRecorder!.isRecording ? "Arrêter l'enregistrement" : 'Enregistrer',
                    style: GoogleFonts.candal(
                      fontSize: 25,
                      //fontWeight: FontWeight.w700,
                      color: CupertinoColors.white,
                    ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 30),
            alignment: Alignment.center,
            child : SizedBox(
              width: 300,
              height: 75,
              child: ElevatedButton(
                onPressed: getPlaybackFn(),
                child: Text(
                  _mPlayer!.isPlaying ? 'Stop' : 'Play',
                  style: GoogleFonts.candal(
                    fontSize: 25,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Nous avons prévenu les contacts suivants:\n\n$first_contact\n$second_contact\n$third_contact",
                style: GoogleFonts.candal(
                  fontSize: 25,
                  color: CupertinoColors.black,
                ),
                textAlign: TextAlign.center,
              ),
          )
        ],
      );
    }
    return Scaffold(
        body: makeBody(),
    );
  }
}