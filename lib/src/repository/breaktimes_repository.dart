import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pausabem/src/models/breaktimes_model.dart';

class BreaktimesRepository {
  final client = http.Client();

  Future<List<BreaktimesModel>> getBreaktimes(int departamentId) async {
    final response = await client
        .get(Uri.parse('http://localhost:3000/timers/$departamentId'));
    final jsonRaw = response.body;

    return parseBreaktimes(jsonRaw);
  }

  List<BreaktimesModel> parseBreaktimes(String jsonRaw) {
    final json = jsonDecode(jsonRaw);
    List<BreaktimesModel> breaktimes = [];

    for (var element in json) {
      breaktimes.add(BreaktimesModel.fromJson(element));
    }

    return breaktimes;
  }
}
