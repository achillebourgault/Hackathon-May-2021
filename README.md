# Porte-clé connecté

A mobile application made in Flutter for a Hackathon

## About this project

This project is a mobile application made in Flutter during a Hackathon at Epitech Lille. The scope of this project was to produce a cross-plateform mobile application that connects to a Bluetooth keychain. One the button on the keychain is pressed the app should trigger and audio recording, call the phone numbers defined by the user to let them know something wrong is going on and save the user current GPS location.

For this project we decided to use Flutter, because it would allow us to produce an application that could run on both Android and iOS using a single code base. Since it was our first time using Flutter, you might see some bugs in the app.


## TODO

There are still things to do in the application:

- The Bluetooth functionality: since the keychain has not been created yet we did not know what Bluetooth profile it would use (see: https://learn.sparkfun.com/tutorials/bluetooth-basics/all#bluetooth-profiles), so we did not implement this. You will have to implement this using a library such as flutter-blue (https://pub.dev/packages/flutter_blue) or flutter_bluetooth_serial (https://pub.dev/packages/flutter_bluetooth_serial). Once you register your keychain input you can call the sendSms() method of the HelpMenu class to do everithing you want.
- A better User Interface: the user interface was not our main focus, so it does not look really good. 



## HOW TO USE THIS PROJECT

- Install Flutter (see: https://flutter.dev/docs/get-started/install)
- Install Android Studio (see: https://developer.android.com/studio/install)
- Clone / download this repository
- Edit the application
- Build the application (see: https://flutter.dev/docs/deployment/android for Android and https://flutter.dev/docs/deployment/ios for iOS)


## WARNING

Although this application is intended to be cross-platform it has only been tested during development using Android Studio, Android 9 and Android 11. **It has not been tested on iOS** since you need an Apple Developper Account to build the application, so things can be broken on the iOS app.