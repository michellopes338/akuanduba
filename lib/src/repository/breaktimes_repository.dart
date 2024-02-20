import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:pausabem/src/models/breaktimes_model.dart';

class BreaktimesRepository {
  final client = http.Client();

  Future<List<BreaktimesModel>> getBreaktimes(int departamentId) async {
    var now = DateTime.now().add(const Duration(seconds: 30));
    var hour = now.hour.toString().padLeft(2, '0');
    var minutes = now.minute.toString().padLeft(2, '0');
    String defaultBreakConfig =
        '[{"id_pause": 1, "time": "$hour:$minutes", "duration": "5", "breakId": 3},{"id_pause": 1, "time": "10:00", "duration": "5", "breakId": 3},{"id_pause": 1, "time": "14:00", "duration": "5", "breakId": 3},{"id_pause": 1, "time": "16:30", "duration": "5", "breakId": 3}]';
    try {
      final response = await client
          .get(Uri.parse('http://localhost:3000/timers/$departamentId'));

      final jsonRaw = response.body;

      if (response.statusCode == 200) {
        return parseBreaktimes(jsonRaw);
      }
      return parseBreaktimes(defaultBreakConfig);
    } on http.ClientException catch (err) {
      return parseBreaktimes(defaultBreakConfig);
    }
  }

  Duration? calcDuration(String duration) {
    var alarmTime = duration.split(':').map((n) => int.parse(n)).toList();

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

    return Duration(seconds: secondsUntilAlarm);
  }

  List<BreaktimesModel> parseBreaktimes(String jsonRaw) {
    final json = jsonDecode(jsonRaw);
    List<BreaktimesModel> breaktimes = [];

    for (var element in json) {
      element['seconds_until'] = calcDuration(element['time']);
      breaktimes.add(BreaktimesModel.fromJson(element));
    }

    return breaktimes;
  }
}
