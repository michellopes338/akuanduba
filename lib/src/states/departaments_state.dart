import 'package:pausabem/src/models/departaments_model.dart';

class DepartamentState {
  final List<DepartamentModel> departaments;

  DepartamentState({
    required this.departaments,
  });

  factory DepartamentState.init() {
    return DepartamentState(
      departaments: const [],
    );
  }

  DepartamentState copyWith({
    List<DepartamentModel>? departaments,
  }) {
    return DepartamentState(
      departaments: departaments ?? this.departaments,
    );
  }
}
