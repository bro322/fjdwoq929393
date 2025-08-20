
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/drawer.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../services/notifications_service.dart';
import '../models/app_user.dart';
import '../models/session.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});
  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final fs = FirestoreService();
  final notif = NotificationsService();
  bool _inited = false;

  @override
  void initState() {
    super.initState();
    notif.init().then((_){ setState(()=> _inited = true); });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: context.read<AuthService>().userChanges,
      builder: (context, snap) {
        final user = snap.data;
        if (user == null) return const Center(child: CircularProgressIndicator());
        return GradientScaffold(
          title: 'جدول الجلسات',
          drawer: MainDrawer(user: user),
          body: StreamBuilder<List<Session>>(
            stream: fs.watchTeacherSessions(user.uid),
            builder: (context, s) {
              final items = s.data ?? [];
              if (items.isEmpty) return const Center(child: Text('لا توجد جلسات مسجلة.'));
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (c,i){
                  final x = items[i];
                  return Card(
                    child: ListTile(
                      title: Text(x.title),
                      subtitle: Text('${x.room} • ${x.startTime}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.notifications_active),
                        onPressed: !_inited ? null : () async {
                          await notif.scheduleRingtone(i+1, x.startTime.subtract(const Duration(minutes: 10)), 'موعد الجلسة', x.title);
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم ضبط تنبيه قبل 10 دقائق')));
                        },
                      ),
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
