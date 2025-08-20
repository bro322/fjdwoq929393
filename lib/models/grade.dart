
class Grade {
  final String id;
  final String studentId;
  final String subject;
  final String term; // فصل/دفعة
  final double score;
  final String? notes;

  Grade({required this.id, required this.studentId, required this.subject, required this.term, required this.score, this.notes});

  factory Grade.fromMap(String id, Map<String, dynamic> m) => Grade(
    id: id,
    studentId: m['studentId'],
    subject: m['subject'],
    term: m['term'],
    score: (m['score'] as num).toDouble(),
    notes: m['notes'],
  );

  Map<String, dynamic> toMap() => {
    'studentId': studentId,
    'subject': subject,
    'term': term,
    'score': score,
    'notes': notes,
  };
}
