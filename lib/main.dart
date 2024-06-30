import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:last_did_app/home.dart';

void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  window.document
      .querySelector('meta[name="theme-color"]')
      ?.setAttribute('content', '#f3e5f5');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Last Did',
      home: const HomePage(),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
