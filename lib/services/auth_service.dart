
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import 'constants.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<AppUser?> get userChanges async* {
    await for (final u in _auth.userChanges()) {
      if (u == null) {
        yield null;
      } else {
        final doc = await _db.collection('users').doc(u.uid).get();
        if (doc.exists) {
          yield AppUser.fromMap(doc.id, doc.data()!..['email'] = u.email);
        } else {
          // new user – default student
          final appUser = AppUser(uid: u.uid, email: u.email ?? '', fullName: u.displayName ?? '', role: 'student');
          await _db.collection('users').doc(u.uid).set(appUser.toMap());
          yield appUser;
        }
      }
    }
  }

  Future<AppUser?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return await currentUser();
  }

  Future<AppUser?> register(String fullName, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _db.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'fullName': fullName,
      'role': email == adminEmail ? 'admin' : 'student',
    });
    return await currentUser();
  }

  Future<void> signOut() => _auth.signOut();

  Future<AppUser?> currentUser() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    final doc = await _db.collection('users').doc(u.uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.id, {...doc.data()!, 'email': u.email});
  }
}
