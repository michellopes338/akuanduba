import 'package:flutter/material.dart';
import 'package:pausabem/pages/LoadScreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.ebGaramondTextTheme()),
      debugShowCheckedModeBanner: false,
      title: 'Akuanduba',
      home: const LoadScreen(),
    );
  }
}
