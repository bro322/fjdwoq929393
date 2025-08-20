
class Session {
  final String id;
  final String teacherId;
  final String title;
  final String room;
  final DateTime startTime;
  final DateTime endTime;
  final String? note;

  Session({required this.id, required this.teacherId, required this.title, required this.room, required this.startTime, required this.endTime, this.note});

  factory Session.fromMap(String id, Map<String, dynamic> m) => Session(
    id: id,
    teacherId: m['teacherId'],
    title: m['title'],
    room: m['room'] ?? '',
    startTime: DateTime.fromMillisecondsSinceEpoch((m['startTime'] as int)),
    endTime: DateTime.fromMillisecondsSinceEpoch((m['endTime'] as int)),
    note: m['note'],
  );

  Map<String, dynamic> toMap() => {
    'teacherId': teacherId,
    'title': title,
    'room': room,
    'startTime': startTime.millisecondsSinceEpoch,
    'endTime': endTime.millisecondsSinceEpoch,
    'note': note,
  };
}
