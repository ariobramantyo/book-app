import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../book/list_book/presentation/list_book_screen.dart';
import 'bloc/auth_bloc.dart';
import 'login/presentation/login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.unknown ||
            state.status == AuthenticationStatus.unauthenticated) {
          return const LoginScreen();
        } else {
          return const ListBookScreen();
        }
      },
    );
  }
}
