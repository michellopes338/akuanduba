import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pausabem/pages/Alarm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
  Size size = view.physicalSize;
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(size.width, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();

    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.ebGaramondTextTheme()),
      debugShowCheckedModeBanner: false,
      title: 'Akuanduba',
      builder: (context, child) {
        child = virtualWindowFrameBuilder(context, child);

        return child;
      },
      home: const Alarm(),
    );
  }
}
