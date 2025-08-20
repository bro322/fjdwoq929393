
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/drawer.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/app_user.dart';
import '../models/grade.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();
    return StreamBuilder<AppUser?>(
      stream: context.read<AuthService>().userChanges,
      builder: (context, snap) {
        final user = snap.data;
        if (user == null) return const Center(child: CircularProgressIndicator());
        return GradientScaffold(
          title: 'علاماتي',
          drawer: MainDrawer(user: user),
          body: StreamBuilder<List<Grade>>(
            stream: fs.watchStudentGrades(user.uid),
            builder: (context, s) {
              final items = s.data ?? [];
              if (items.isEmpty) return const Center(child: Text('لا توجد علامات بعد.'));
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (c,i){
                  final g = items[i];
                  return Card(
                    child: ListTile(
                      title: Text('${g.subject} - ${g.term}'),
                      trailing: Text(g.score.toStringAsFixed(2)),
                      subtitle: g.notes==null? null : Text(g.notes!),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
    );
  }
}
