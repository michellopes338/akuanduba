import 'package:pausabem/src/models/breaktimes_model.dart';

class BreaktimesState {
  final List<BreaktimesModel> breaktimes;

  BreaktimesState({
    required this.breaktimes,
  });

  factory BreaktimesState.init() {
    return BreaktimesState(breaktimes: const []);
  }

  BreaktimesState copyWith({
    List<BreaktimesModel>? breaktimes,
  }) {
    return BreaktimesState(breaktimes: breaktimes ?? this.breaktimes);
  }
}
