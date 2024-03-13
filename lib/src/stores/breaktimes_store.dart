import 'package:flutter/material.dart';
import 'package:pausabem/src/repository/breaktimes_repository.dart';
import 'package:pausabem/src/states/breaktimes_state.dart';

class BreaktimesStore extends ValueNotifier<BreaktimesState> {
  BreaktimesStore() : super(BreaktimesState.init());
  final repository = BreaktimesRepository();

  Future<void> getBreaktimes() async {
    final breaktimes = await repository.getBreaktimes();
    value = value.copyWith(breaktimes: breaktimes);
  }
}
