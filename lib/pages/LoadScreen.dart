import 'package:flutter/material.dart';
import 'package:pausabem/pages/Alarm.dart';
import 'package:pausabem/pages/getUserDepartament.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  int? _departamentId;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      _loadDepartamentId();
    });
  }

  Future<void> _loadDepartamentId() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('departamentId');
    print('O valor de departamentId é ${prefs.getInt('departamentId')}');
    final int? id = prefs.getInt('departamentId');
    if (id == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GetUserDepartament()));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const Alarm()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                scale: 2,
                repeat: ImageRepeat.repeat)),
        child: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Akuanduba",
              style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 232, 179, 155),
                  letterSpacing: 16),
            ),
            CircularProgressIndicator()
          ],
        )),
      ),
    );
  }
}
