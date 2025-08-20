
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/drawer.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: context.read<AuthService>().userChanges,
      builder: (context, snap) {
        final user = snap.data;
        if (user == null) return const Center(child: CircularProgressIndicator());
        return GradientScaffold(
          title: 'الرئيسية',
          drawer: MainDrawer(user: user),
          body: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            children: [
              _CardTile('علاماتي', Icons.grade, onTap: user.role=='student'? ()=> Navigator.pushNamed(context, '/grades') : null),
              _CardTile('البرامج (التاسع/بكالوريا)', Icons.school, onTap: ()=> Navigator.pushNamed(context, '/programs')),
              if (user.role=='teacher') _CardTile('جدولي', Icons.event, onTap: ()=> Navigator.pushNamed(context, '/teacher')),
              if (user.role=='admin') _CardTile('لوحة المدير', Icons.lock, onTap: ()=> Navigator.pushNamed(context, '/admin')),
            ],
          ),
        );
      }
    );
  }
}

class _CardTile extends StatelessWidget {
  final String title; final IconData icon; final VoidCallback? onTap;
  const _CardTile(this.title, this.icon, {this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 42),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}
