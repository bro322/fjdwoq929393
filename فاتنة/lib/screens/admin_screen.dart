
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/drawer.dart';
import '../models/app_user.dart';
import '../models/grade.dart';
import '../models/session.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/constants.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final fs = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String code = '';
  bool unlocked = false;

  // Grade inputs
  final studentId = TextEditingController();
  final subject = TextEditingController();
  final term = TextEditingController();
  final score = TextEditingController();
  final notes = TextEditingController();

  // Session inputs
  final teacherId = TextEditingController();
  final title = TextEditingController();
  final room = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: context.read<AuthService>().userChanges,
      builder: (context, snap) {
        final user = snap.data;
        if (user == null) return const Center(child: CircularProgressIndicator());
        if (user.role != 'admin') return const Center(child: Text('صلاحيات المدير فقط.'));
        return GradientScaffold(
          title: 'لوحة المدير',
          drawer: MainDrawer(user: user),
          body: ListView(
            children: [
              if (!unlocked)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('أدخل الرمز السري لفتح لوحة التحكم'),
                        const SizedBox(height: 8),
                        TextField(onChanged: (v)=> code=v, decoration: const InputDecoration(labelText: 'الرمز السري')),
                        const SizedBox(height: 8),
                        ElevatedButton(onPressed: (){
                          if (code == AppStrings.adminSecret) setState(()=> unlocked = true);
                          else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رمز غير صحيح')));
                        }, child: const Text('فتح')),
                      ],
                    ),
                  ),
                ),
              if (unlocked) ...[
                _panelTitle('إضافة علامة لطالب'),
                Card(child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    TextField(controller: studentId, decoration: const InputDecoration(labelText: 'UID الطالب (من Firebase)')),
                    TextField(controller: subject, decoration: const InputDecoration(labelText: 'المادة')),
                    TextField(controller: term, decoration: const InputDecoration(labelText: 'الفصل/الدفعة')),
                    TextField(controller: score, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'العلامة')),
                    TextField(controller: notes, decoration: const InputDecoration(labelText: 'ملاحظات (اختياري)')),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () async {
                      final g = Grade(id: '', studentId: studentId.text.trim(), subject: subject.text.trim(), term: term.text.trim(), score: double.tryParse(score.text.trim()) ?? 0, notes: notes.text.trim().isEmpty? null : notes.text.trim());
                      await fs.addGrade(g);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة العلامة')));
                    }, child: const Text('حفظ')),
                  ]),
                )),

                _panelTitle('إضافة جلسة لمعلم'),
                Card(child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    TextField(controller: teacherId, decoration: const InputDecoration(labelText: 'UID المعلم')),
                    TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان')),
                    TextField(controller: room, decoration: const InputDecoration(labelText: 'القاعة/الغرفة')),
                    Row(children: [
                      Expanded(child: ElevatedButton(onPressed: () async {
                        final dt = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), initialDate: DateTime.now());
                        if (dt==null) return;
                        final tm = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (tm==null) return;
                        startTime = DateTime(dt.year, dt.month, dt.day, tm.hour, tm.minute);
                        setState((){});
                      }, child: Text(startTime==null? 'اختيار وقت البداية' : startTime.toString()))),
                      const SizedBox(width: 8),
                      Expanded(child: ElevatedButton(onPressed: () async {
                        final dt = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), initialDate: DateTime.now());
                        if (dt==null) return;
                        final tm = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (tm==null) return;
                        endTime = DateTime(dt.year, dt.month, dt.day, tm.hour, tm.minute);
                        setState((){});
                      }, child: Text(endTime==null? 'اختيار وقت النهاية' : endTime.toString()))),
                    ]),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () async {
                      if (startTime==null || endTime==null) return;
                      final s = Session(id: '', teacherId: teacherId.text.trim(), title: title.text.trim(), room: room.text.trim(), startTime: startTime!, endTime: endTime!);
                      await fs.addSession(s);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة الجلسة')));
                    }, child: const Text('حفظ')),
                  ]),
                )),
              ],
            ],
          ),
        );
      }
    );
  }

  Widget _panelTitle(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}
