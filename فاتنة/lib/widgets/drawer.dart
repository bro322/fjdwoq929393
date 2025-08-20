
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';

class MainDrawer extends StatelessWidget {
  final AppUser user;
  const MainDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 72),
                const SizedBox(height: 8),
                Text(user.fullName.isEmpty ? user.email : user.fullName, textAlign: TextAlign.center),
                Text(user.role, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          ListTile(title: const Text('الرئيسية'), onTap: ()=> Navigator.pushReplacementNamed(context, '/home')),
          if (user.role == 'student') ListTile(title: const Text('علاماتي'), onTap: ()=> Navigator.pushReplacementNamed(context, '/grades')),
          ListTile(title: const Text('البرامج (التاسع/بكالوريا)'), onTap: ()=> Navigator.pushReplacementNamed(context, '/programs')),
          if (user.role == 'teacher') ListTile(title: const Text('جدولي'), onTap: ()=> Navigator.pushReplacementNamed(context, '/teacher')),
          if (user.role == 'admin') ListTile(title: const Text('لوحة المدير'), onTap: ()=> Navigator.pushReplacementNamed(context, '/admin')),
          const Divider(),
          ListTile(title: const Text('تسجيل الخروج'), onTap: () async {
            await context.read<AuthService>().signOut();
            if (context.mounted) Navigator.pushReplacementNamed(context, '/');
          }),
        ],
      ),
    );
  }
}
