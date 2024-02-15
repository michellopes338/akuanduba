import 'package:flutter/material.dart';
import 'package:pausabem/src/repository/breaktimes_repository.dart';
import 'package:pausabem/src/states/breaktimes_state.dart';

class BreaktimesStore extends ValueNotifier<BreaktimesState> {
  BreaktimesStore() : super(BreaktimesState.init());
  final repository = BreaktimesRepository();

  Future<void> getBreaktimes(int departamentId) async {
    final breaktimes = await repository.getBreaktimes(departamentId);
    value = value.copyWith(breaktimes: breaktimes);
  }
}
