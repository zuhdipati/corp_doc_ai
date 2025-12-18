import 'package:corp_doc_ai/core/routes/app_routes.dart';
import 'package:corp_doc_ai/core/themes/app_theme.dart';
import 'package:corp_doc_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CorpDocApp());
}

class CorpDocApp extends StatelessWidget {
  const CorpDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes().router,
      theme: AppTheme.appTheme,
    );
  }
}
