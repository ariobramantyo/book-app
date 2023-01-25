import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

import '../../../../core/widgets/auth_text_field.dart';
import '../../models/email.dart';
import '../../models/password.dart';
import '../../register/presentation/register_screen.dart';
import '../bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context)),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.message ?? 'Login gagal',
                        style: const TextStyle(fontSize: 12))));
            } else if (state.status.isSubmissionSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: const Text('Berhasil masuk akun',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  backgroundColor: Theme.of(context).primaryColor,
                ));
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 50),
                  _buildFormContent(),
                  const SizedBox(height: 80),
                  _LoginButton(),
                  const SizedBox(height: 10),
                  _buildFooter(context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Login',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        const Text('Welcome!', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 20),
        Center(
          child: SvgPicture.asset(
            'assets/book_login_vector.svg',
            height: 180,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmailInput(),
        const SizedBox(height: 20),
        _PasswordInput(),
      ],
    );
  }

  _buildFooter(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Belum punya akun?',
          style: Theme.of(context).textTheme.subtitle2,
          children: [
            TextSpan(
                text: ' Daftar',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Theme.of(context).primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ));
                  })
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthTextField(
          label: 'Email',
          hint: 'Masukkan E-mail kamu',
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: (state.status.isPure)
              ? null
              : Email.getErrorText(state.email.error),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  // var _passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AuthTextField(
          obscure: true,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          errorText: (state.status.isPure)
              ? null
              : PasswordSecure.getErrorText(state.password.error),
          onChanged: (password) => context.read<LoginBloc>().add(
                LoginPasswordChanged(password),
              ),
          // onActionDone: (_) {
          //   if (state.status.isPure ||
          //       (!state.status.isSubmissionInProgress &&
          //           state.status.isValid)) {
          //     context.read<LoginBloc>().add(const LoginSubmitted());
          //   }
          // },
          // suffixIcon: IconButton(
          //   constraints: const BoxConstraints(maxHeight: 20),
          //   icon: Icon(
          //       _passwordObscure ? Icons.visibility_off : Icons.visibility),
          //   padding: const EdgeInsets.only(bottom: 20),
          //   onPressed: () =>
          //       setState(() => _passwordObscure = !_passwordObscure),
          // ),
          label: 'Password',
          hint: 'Masukkan password kamu',
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      // buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              const Size(double.infinity, 48),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: state.email.valid && state.password.valid
              ? () {
                  if (state.status.isPure ||
                      (!state.status.isSubmissionInProgress &&
                          state.status.isValid)) {
                    context.read<LoginBloc>().add(const LoginSubmitted());
                  }
                }
              : null,
          child: state.status.isSubmissionInProgress
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).backgroundColor,
                  ),
                )
              : const Text('Login'),
        );
      },
    );
  }
}
