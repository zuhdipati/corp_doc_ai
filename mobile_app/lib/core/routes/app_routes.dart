import 'package:corp_doc_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:corp_doc_ai/features/library/presentation/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  get router => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => CupertinoPage(child: HomePage()),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        pageBuilder: (context, state) => CupertinoPage(child: ChatPage()),
      ),
    ],
  );
}
