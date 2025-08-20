
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final name = TextEditingController();
  bool register = false;
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/images/logo.png', height: 120),
                    const SizedBox(height: 8),
                    Text("معهد فاتنة", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 24),
                    if (register) TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
                    const SizedBox(height: 12),
                    TextField(controller: email, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
                    const SizedBox(height: 12),
                    TextField(controller: pass, decoration: const InputDecoration(labelText: 'كلمة المرور'), obscureText: true),
                    const SizedBox(height: 12),
                    if (error!=null) Text(error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: loading ? null : () async {
                        setState(()=> loading = true); setState(()=> error=null);
                        try {
                          final auth = context.read<AuthService>();
                          if (register) {
                            await auth.register(name.text.trim(), email.text.trim(), pass.text);
                          } else {
                            await auth.signIn(email.text.trim(), pass.text);
                          }
                          if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          setState(()=> error = e.toString());
                        } finally {
                          setState(()=> loading = false);
                        }
                      },
                      child: Text(register ? 'إنشاء حساب' : 'تسجيل الدخول'),
                    ),
                    TextButton(onPressed: ()=> setState(()=> register = !register), child: Text(register ? 'لديك حساب؟ تسجيل الدخول' : 'مستخدم جديد؟ إنشاء حساب')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
