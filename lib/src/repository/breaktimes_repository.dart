import 'dart:convert';
import 'dart:math';

import 'package:pausabem/src/models/breaktimes_model.dart';

class BreaktimesRepository {
  Future<List<BreaktimesModel>> getBreaktimes() async {
    // var pause1 = DateTime.now().add(const Duration(minutes: 1));
    // var hour1 = pause1.hour.toString().padLeft(2, '0');
    // var minutes1 = pause1.minute.toString().padLeft(2, '0');

    // var pause2 = DateTime.now().add(const Duration(minutes: 2));
    // var hour2 = pause2.hour.toString().padLeft(2, '0');
    // var minutes2 = pause2.minute.toString().padLeft(2, '0');
    // String defaultBreakConfig = '[{"id_pause": 1, "time": "$hour1:$minutes1", "duration": "5", "breakId": 3},{"id_pause": 1, "time": "$hour2:$minutes2", "duration": "5", "breakId": 3},{"id_pause": 1, "time": "14:00", "duration": "5", "breakId": 3},{"id_pause": 1, "time": "16:30", "duration": "5", "breakId": 3}]';
    String defaultBreakConfig = """[
      {"id_pause": 1, "time": "10:00", "duration": "5", "breakId": 3},
      {"id_pause": 2, "time": "14:00", "duration": "5", "breakId": 3},
      {"id_pause": 3, "time": "16:30", "duration": "5", "breakId": 3},
      {"id_pause": 4, "time": "20:03", "duration": "5", "breakId": 3}
    ]""";
    return parseBreaktimes(defaultBreakConfig);
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
