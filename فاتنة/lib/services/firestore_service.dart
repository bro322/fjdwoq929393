
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grade.dart';
import '../models/session.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Grades
  Stream<List<Grade>> watchStudentGrades(String studentId) {
    return _db.collection('grades').where('studentId', isEqualTo: studentId).snapshots()
      .map((s) => s.docs.map((d)=> Grade.fromMap(d.id, d.data())).toList());
  }

  Future<void> addGrade(Grade g) async {
    await _db.collection('grades').add(g.toMap());
  }

  // Sessions
  Stream<List<Session>> watchTeacherSessions(String teacherId) {
    return _db.collection('schedules').where('teacherId', isEqualTo: teacherId).snapshots()
      .map((s) => s.docs.map((d)=> Session.fromMap(d.id, d.data())).toList());
  }

  Future<void> addSession(Session s) async {
    await _db.collection('schedules').add(s.toMap());
  }
}
