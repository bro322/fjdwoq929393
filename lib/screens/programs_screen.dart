
import 'package:flutter/material.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: context.read<AuthService>().userChanges,
      builder: (context, snap) {
        final user = snap.data;
        if (user == null) return const Center(child: CircularProgressIndicator());
        return GradientScaffold(
          title: 'البرامج التعليمية',
          drawer: MainDrawer(user: user),
          body: ListView(
            children: const [
              _ProgramCard('البرنامج التاسع', 'مواد التأسيس والامتحانات التجريبية للصف التاسع.'),
              _ProgramCard('البكالوريا الأدبي', 'اللغة العربية، الفلسفة، الجغرافيا، التاريخ، اللغات ...'),
              _ProgramCard('البكالوريا العلمي', 'الرياضيات، الفيزياء، الكيمياء، علم الأحياء، اللغات ...'),
            ],
          ),
        );
      }
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String title, desc;
  const _ProgramCard(this.title, this.desc);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ListTile(
        title: Text(title), subtitle: Text(desc),
      ),
    );
  }
}
