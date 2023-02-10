import 'package:api_services/api_services.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:book_app/features/auth/wrapper.dart';
import 'package:book_repository/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'features/auth/bloc/auth_bloc.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepositoryImpl(),
    bookRepository: BookRepositoryImpl(
        bookApiService: BookApiServiceImpl(client: http.Client()),
        flutterSecureStorage: const FlutterSecureStorage()),
  ));
}

class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final BookRepository bookRepository;

  const App({
    super.key,
    required this.authenticationRepository,
    required this.bookRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: bookRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AuthBloc(authenticationRepository: authenticationRepository),
            ),
          ],
          child: const AppView(),
        ));
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book App',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}
