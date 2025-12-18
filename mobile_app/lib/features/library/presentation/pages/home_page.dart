import 'package:corp_doc_ai/core/themes/app_colors.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:corp_doc_ai/features/library/presentation/widgets/neo_container.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.pushNamed('login');
        }
      },
      child: Scaffold(
        floatingActionButton: NeoContainer(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: AppColors.secondary,
                title: Text("Upload File", textAlign: TextAlign.center),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 15,
                  children: [
                    NeoContainer(
                      onTap: () async {
                        // FilePickerResult? result = await FilePicker.platform
                        //     .pickFiles(
                        //       type: FileType.custom,
                        //       allowedExtensions: ['pdf', 'json', 'txt'],
                        //     );
                        // if (result != null) {
                        //   String fileName = result.files.single.name;

                        //   if (!context.mounted) return;
                        context.pushNamed(
                          'chat',
                          queryParameters: {'fileName': 'fileName'},
                        );
                        // }
                      },
                      width: 200,
                      child: Text("Upload File"),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Corp Doc AI",
            style: TextStyle(color: AppColors.black, fontSize: 25),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
              icon: const Icon(Icons.logout, color: AppColors.black),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: Text(
                    "Selamat Datang di Corp Doc AI, upload file dan AI akan berintegrasi dengan data dan anda bisa mulai berkomunikasi",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                // ...List.generate(3, (index) {
                //   return Container(
                //     alignment: Alignment.center,
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 12,
                //       vertical: 8,
                //     ),
                //     child: AniContainer(
                //       onTap: () {},
                //       height: MediaQuery.of(context).size.height / 8,
                //       width: MediaQuery.of(context).size.width / 1.2,
                //       child: Text("halo"),
                //     ),
                //   );
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
