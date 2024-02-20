import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pausabem/src/models/breaktimes_model.dart';
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
  late List<BreaktimesModel> breaktimes;

  final store = BreaktimesStore();

  var label = '';

  late Timer _timer;

  @override
  void initState() {
    super.initState();
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
    setState(() {
      breaktimes = store.value.breaktimes;
    });
    _startLabel();
    _startTimer();
  }

  Future<void> _playMusic() async {
    await _player.play(AssetSource('/songs/Over_the_Horizon.m4a'));
  }

  Future<void> _stopMusic() async {
    await _player.stop();
  }

  void _startLabel() {
    var positiveDurations =
        breaktimes.where((element) => element.secondsUntil > Duration.zero);
    var newLabel = positiveDurations.isEmpty
        ? 'Não há pausas'
        : positiveDurations.first.time;

    setState(() {
      label = newLabel;
    });
  }

  void _updateLabel(String newLabel) {
    setState(() {
      label = newLabel;
    });
  }

  void _startTimer() {
    var positiveDurations = breaktimes
        .where((element) => element.secondsUntil > Duration.zero)
        .toList();
    for (var i = 0; i < positiveDurations.length; i++) {
      var element = breaktimes[i];

      print(element.secondsUntil);

      if (element.secondsUntil < Duration.zero) {
        continue;
      }

      _timer = Timer(element.secondsUntil, () {
        var newLabel = 'Não há pausas';

        if (element != positiveDurations.last) {
          newLabel = positiveDurations[i + 1].time;
        }

        _playMusic();
        _updateLabel(newLabel);
      });
    }
  }

  @override
  void dispose() {
    store.removeListener(_listener);
    _timer.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        'Próximo alarme:',
                        // textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color.fromARGB(255, 232, 179, 155),
                        ),
                      ),
                      Text(
                        label,
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
