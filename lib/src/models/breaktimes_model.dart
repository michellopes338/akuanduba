import 'package:equatable/equatable.dart';

class BreaktimesModel extends Equatable {
  final int idPause;
  final String time;
  final String duration;
  final int breakId;

  const BreaktimesModel({
    required this.idPause,
    required this.time,
    required this.duration,
    required this.breakId,
  });

  factory BreaktimesModel.init() {
    return const BreaktimesModel(
        idPause: 0, time: '', duration: '', breakId: 0);
  }

  factory BreaktimesModel.fromJson(Map<String, dynamic> json) =>
      BreaktimesModel(
          idPause: json['id_pause'],
          time: json['time'],
          duration: json['duration'],
          breakId: json['breakId']);

  @override
  List<Object?> get props => [idPause, time, duration, breakId];
}
