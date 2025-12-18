import 'package:corp_doc_ai/core/themes/app_colors.dart';
import 'package:corp_doc_ai/core/utils/toast.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.pushNamed('home');
        } else if (state is AuthError) {
          ToastUtils.show(state.message, backgroundColor: Colors.red);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: AppColors.black, offset: Offset(5, 5)),
                      ],
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 80,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Corp Doc AI',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Kelola dokumen perusahaan dengan bantuan AI',
                    style: TextStyle(fontSize: 16, color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return _GoogleSignInButton(
                        isLoading: isLoading,
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthSignInWithGoogle());
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _GoogleSignInButton({required this.isLoading, required this.onPressed});

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = true);
        }
      },
      onPointerUp: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = false);
          widget.onPressed();
        }
      },
      onPointerCancel: (_) {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.black : AppColors.secondary,
          border: Border.all(color: AppColors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: _isPressed ? Offset.zero : const Offset(5, 5),
            ),
          ],
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.black,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _isPressed ? AppColors.secondary : AppColors.black,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
