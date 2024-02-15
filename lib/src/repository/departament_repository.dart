import 'dart:convert';

import 'package:pausabem/src/models/departaments_model.dart';
import 'package:pausabem/src/states/departaments_state.dart';
import 'package:http/http.dart' as http;

class DepartamentRepository {
  final client = http.Client();

  Future<List<DepartamentModel>> getDepartaments() async {
    final response =
        await client.get(Uri.parse('http://localhost:3000/breaks'));
    final jsonRaw = response.body;

    return parseDepartaments(jsonRaw);
  }

  List<DepartamentModel> parseDepartaments(String jsonRaw) {
    final json = jsonDecode(jsonRaw);
    List<DepartamentModel> departaments = [];

    for (var element in json) {
      departaments.add(DepartamentModel.fromJson(element));
    }

    return departaments;
  }
}
