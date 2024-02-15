import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pausabem/src/stores/breaktimes_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final double headerSize = 40;
  final double columnWidth = 300;
  final _player = AudioPlayer();

  final store = BreaktimesStore();

  var nextAlarm = '';

  Timer? _timer;

  @override
  void initState() {
    store.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final int departamentId = await _getDepartamentId();
      store.getBreaktimes(departamentId);
    });
  }

  Future<int> _getDepartamentId() async {
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('departamentId');

    return id!;
  }

  void _listener() {
    setState(() {});
  }

  Future<void> _playMusic() async {
    await _player.play(AssetSource('/songs/Over_the_Horizon.m4a'));
  }

  Future<void> _stopMusic() async {
    await _player.stop();
  }

  void _calcTimer() {
    int firstValuePositive;
    var firstValuePositiveWasFounded = false;
    for (var i = 0; i < store.value.breaktimes.length; i++) {
      var element = store.value.breaktimes[i];
      var alarmTime = element.time.split(':').map((n) => int.parse(n)).toList();

      // check validate if nessesaire

      const List<int> secondsHMS = [3600, 60, 1];

      var alarmSeconds = List<int>.generate(
              min(secondsHMS.length, alarmTime.length),
              (index) => secondsHMS[index] * alarmTime[index])
          .fold(0, (previousValue, element) => previousValue + element);

      var now = DateTime.now();
      var currentTimeInSeconds = List<int>.generate(
              secondsHMS.length,
              (index) =>
                  secondsHMS[index] * [now.hour, now.minute, now.second][index])
          .fold(0, (previousValue, element) => previousValue + element);

      var secondsUntilAlarm = alarmSeconds - currentTimeInSeconds;
      print(secondsUntilAlarm);

      if (secondsUntilAlarm < 0) {
        continue;
      }

      if (firstValuePositiveWasFounded == false && secondsUntilAlarm > 0) {
        firstValuePositive = secondsUntilAlarm;
        firstValuePositiveWasFounded = true;
        setState(() {
          nextAlarm = element.time;
        });
      }

      _timer = Timer(Duration(seconds: secondsUntilAlarm), () {
        if (i + 1 < store.value.breaktimes.length) {
          setState(() {
            nextAlarm = store.value.breaktimes[i + 1].time;
          });
          _playMusic();
        }
      });
    }
  }

  @override
  void dispose() {
    store.removeListener(_listener);
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _calcTimer();
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  scale: 2,
                  repeat: ImageRepeat.repeat)),
          child: Column(
            children: [
              Container(
                // decoration: const BoxDecoration(color: Colors.deepOrange),
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsets.symmetric(horizontal: 80),
                width: double.infinity,
                height: headerSize,
                child: const Text(
                  "Akuanduba",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 232, 179, 155),
                      letterSpacing: 8),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                // decoration: const BoxDecoration(color: Colors.pinkAccent),
                height: MediaQuery.of(context).size.height - headerSize,
                // width: columnWidth,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Próximo alarme',
                        // textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color.fromARGB(255, 232, 179, 155),
                        ),
                      ),
                      Text(
                        nextAlarm,
                        style: const TextStyle(
                          fontSize: 100,
                          color: Color.fromARGB(255, 232, 179, 155),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 232, 179, 155)),
                          onPressed: _stopMusic,
                          child: const Text(
                            'Parar Musica',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ]),
              )
            ],
          )),
    );
  }
}
