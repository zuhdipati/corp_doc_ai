import 'dart:io';

import 'package:corp_doc_ai/core/themes/app_colors.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:corp_doc_ai/features/document/presentation/bloc/document_bloc.dart';
import 'package:corp_doc_ai/features/document/presentation/widgets/neo_container.dart';
import 'package:file_picker/file_picker.dart';
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
  void initState() {
    super.initState();
    context.read<DocumentBloc>().add(GetDocumentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.goNamed('login');
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
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'json', 'txt'],
                            );
                        if (result != null) {
                          if (!context.mounted) return;
                          context.read<DocumentBloc>().add(
                            UploadDocumentEvent(
                              document: File(result.files.single.path ?? ''),
                            ),
                          );

                          context.pop();
                        }
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
        body: BlocConsumer<DocumentBloc, DocumentState>(
          listener: (context, state) {
            if (state is UploadedDocument) {
              context
                  .pushNamed(
                    'chat',
                    queryParameters: {'fileName': state.document.name},
                  )
                  .then((_) {
                    if (context.mounted) {
                      context.read<DocumentBloc>().add(GetDocumentsEvent());
                    }
                  });
            }
            if (state is UploadedDocumentError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is DocumentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ListDocumentError) {
              return Center(child: Text(state.message));
            }
            if (state is ListDocumentLoaded) {
              return SafeArea(
                child: Visibility(
                  visible: state.documents.isNotEmpty,
                  replacement: Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: Text(
                      "Selamat Datang di Corp Doc AI, upload file dan AI akan berintegrasi dengan data dan anda bisa mulai berkomunikasi",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(state.documents.length, (index) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Stack(
                            children: [
                              NeoContainer(
                                onTap: () {},
                                height: MediaQuery.of(context).size.height / 8,
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Text(state.documents[index].name),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog.adaptive(
                                        title: Text("Are you sure?"),
                                        content: Text(
                                          "Are you sure you want to delete ${state.documents[index].name} document?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.pop();
                                              context.read<DocumentBloc>().add(
                                                DeleteDocumentEvent(
                                                  documentId:
                                                      state.documents[index].id,
                                                ),
                                              );
                                            },
                                            child: Text("Delete"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_sharp,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
