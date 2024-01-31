
class TaskModel {
  late int id;
  late String name;
  late String dateIni;
  late String dateFin;
  late int progress;
  TaskModel({
    required this.id,
    required this.name,
    required this.dateIni,
    required this.dateFin,
    required this.progress
  });

  TaskModel copyWith({
    int? id,
    String? name,
    String? dateIni,
    String? dateFin,
    int? progress
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateIni: dateIni ?? this.dateIni,
      dateFin: dateFin ?? this.dateFin,
      progress: progress ?? this.progress,
    );
  }
}