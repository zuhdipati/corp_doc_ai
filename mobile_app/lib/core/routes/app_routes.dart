import 'package:corp_doc_ai/features/auth/presentation/pages/login_page.dart';
import 'package:corp_doc_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:corp_doc_ai/features/document/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  GoRouter get router => GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            CupertinoPage(child: const LoginPage()),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => CupertinoPage(child: const HomePage()),
      ),
      GoRoute(
        path: '/chat/:documentId',
        name: 'chat',
        pageBuilder: (context, state) {
          final documentId = state.pathParameters['documentId']!;
          return CupertinoPage(child: ChatPage(documentId: documentId));
        },
      ),
    ],
  );
}
