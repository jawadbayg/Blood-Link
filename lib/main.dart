import 'package:bloodbankmanager/authentication/login.dart';
import 'package:bloodbankmanager/dashboard.dart';
import 'package:bloodbankmanager/homePage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyCB03c6kLw94OWOPB7qecDx367pciF1eGs',
    appId: '1:1046677148282:android:80c05bcc4dfa29876a21c3',
    messagingSenderId: '1046677148282',
    projectId: 'bloodbankmanager-4c888',
    storageBucket: 'myapp-b9yt18.appspot.com',
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}
