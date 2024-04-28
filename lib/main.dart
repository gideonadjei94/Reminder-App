import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reminder_app/screens/Home.dart';
import 'package:reminder_app/screens/Login.dart';
import 'firebase_options.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Reminder());
}

class Reminder extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _auth.currentUser != null ? Home() : Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
