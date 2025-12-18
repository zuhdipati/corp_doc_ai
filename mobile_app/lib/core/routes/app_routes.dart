import 'package:corp_doc_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:corp_doc_ai/features/auth/presentation/pages/login_page.dart';
import 'package:corp_doc_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:corp_doc_ai/features/library/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  final AuthRepository _authRepository = AuthRepository();

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
        pageBuilder: (context, state) => CupertinoPage(
          child: BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: _authRepository)
                  ..add(AuthCheckRequested()),
            child: const LoginPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => CupertinoPage(
          child: BlocProvider(
            create: (context) => AuthBloc(authRepository: _authRepository),
            child: const HomePage(),
          ),
        ),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        pageBuilder: (context, state) => CupertinoPage(child: ChatPage()),
      ),
    ],
  );
}
