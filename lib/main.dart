import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futsal_management/firebase_options.dart';
import 'package:futsal_management/pages/booked_success.dart';
import 'package:futsal_management/pages/home_page.dart';
import 'package:futsal_management/pages/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree(),
    );
  }
}
