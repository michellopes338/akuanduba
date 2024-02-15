import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pausabem/src/repository/departament_repository.dart';
import 'package:pausabem/src/states/departaments_state.dart';

class DepartamentStore extends ValueNotifier<DepartamentState> {
  DepartamentStore() : super(DepartamentState.init());
  final repository = DepartamentRepository();

  Future<void> getDepartaments() async {
    final departaments = await repository.getDepartaments();
    value = value.copyWith(departaments: departaments);
  }
}
