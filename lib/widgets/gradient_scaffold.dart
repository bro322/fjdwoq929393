
import 'package:flutter/material.dart';
import '../theme.dart';

class GradientScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? drawer;

  const GradientScaffold({super.key, required this.title, required this.body, this.floatingActionButton, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(title)),
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: body,
        ),
        floatingActionButton: floatingActionButton,
        drawer: drawer,
      ),
    );
  }
}
