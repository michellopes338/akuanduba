import 'package:equatable/equatable.dart';

class BreaktimesModel extends Equatable {
  final int idPause;
  final String time;
  final int breakId;
  final Duration secondsUntil;

  const BreaktimesModel({
    required this.idPause,
    required this.time,
    required this.breakId,
    required this.secondsUntil,
  });

  factory BreaktimesModel.init() {
    return const BreaktimesModel(
        idPause: 0, time: '', breakId: 0, secondsUntil: Duration.zero);
  }

  factory BreaktimesModel.fromJson(Map<String, dynamic> json) =>
      BreaktimesModel(
          idPause: json['id_pause'],
          time: json['time'],
          breakId: json['breakId'],
          secondsUntil: json['seconds_until']);

  @override
  List<Object?> get props => [idPause, time, breakId];
}
