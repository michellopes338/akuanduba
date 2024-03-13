import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pausabem/src/models/breaktimes_model.dart';
import 'package:pausabem/src/stores/breaktimes_store.dart';
import 'package:window_manager/window_manager.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> with WindowListener {
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
    windowManager.addListener(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      store.getBreaktimes();
    });
  }

  void _listener() {
    setState(() {
      breaktimes = store.value.breaktimes;
    });
    _startLabel();
    _startTimer();
  }

  Future<void> _playMusic() async {
    await _player.play(AssetSource('songs/song.mp3'));
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

  Future<void> _showWindow() async {
    await windowManager.setAlwaysOnTop(true);
  }

  Future<void> _hideWindow() async {
    await windowManager.setAlwaysOnTop(false);
  }

  int _roof(int value, int maxValue) {
    return value > maxValue ? maxValue : value;
  }

  void _startTimer() {
    String newLabel;
    int next;
    var positiveDurations = breaktimes
        .where((element) => element.secondsUntil > Duration.zero)
        .toList();
    for (var i = 0; i < positiveDurations.length; i++) {
      var element = positiveDurations[i];

      _timer = Timer(element.secondsUntil, () async {
        next = _roof(i, positiveDurations.length);
        newLabel = positiveDurations[next].time;

        if (element == positiveDurations.last) {
          newLabel = 'Não há pausas';
        }

        await _showWindow();
        _playMusic();
        _updateLabel(newLabel);
      });
    }
  }

  @override
  void dispose() {
    store.removeListener(_listener);
    windowManager.removeListener(this);
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
                          onPressed: () {
                            _stopMusic();
                            _hideWindow();
                          },
                          child: const Text(
                            'Pular pausa',
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
