import 'package:equatable/equatable.dart';

class DepartamentModel extends Equatable {
  final int id;
  final String name;

  const DepartamentModel({
    required this.id,
    required this.name,
  });

  factory DepartamentModel.init() {
    return const DepartamentModel(id: 0, name: '');
  }

  factory DepartamentModel.fromJson(Map<String, dynamic> json) =>
      DepartamentModel(id: json['id'], name: json['name']);

  @override
  List<Object?> get props => [id, name];
}
