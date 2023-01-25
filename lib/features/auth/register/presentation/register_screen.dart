import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

import '../../../../core/widgets/auth_text_field.dart';
import '../../models/email.dart';
import '../../models/name.dart';
import '../../models/password.dart';
import '../bloc/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context)),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text(state.registerErrorMessage)));
          } else if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: const Text(
                    'Pendaftaran akun berhasil. silahkan kembali ke halaman login',
                    style: TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: Theme.of(context).primaryColor,
              ));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 50),
                  _buildFormContent(),
                  const SizedBox(height: 50),
                  _RegisterButton(),
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
        const Text('Sign up',
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
        _NameInput(),
        const SizedBox(height: 15),
        _EmailInput(),
        const SizedBox(height: 15),
        _PasswordInput(),
        const SizedBox(height: 15),
        _ConfirmPasswordInput(),
      ],
    );
  }

  _buildFooter(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Sudah punya akun?',
          style: Theme.of(context).textTheme.subtitle2,
          children: [
            TextSpan(
                text: ' Login',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Theme.of(context).primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(context);
                  })
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return AuthTextField(
          label: 'Nama',
          hint: 'Masukkan nama kamu',
          errorText:
              state.status.isPure ? null : Name.getErrorText(state.name.error),
          onChanged: (name) =>
              context.read<RegisterBloc>().add(RegisterNameChanged(name)),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
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
              context.read<RegisterBloc>().add(RegisterEmailChanged(email)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AuthTextField(
          obscure: true,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          errorText: (state.status.isPure)
              ? null
              : PasswordSecure.getErrorText(state.password.error),
          onChanged: (password) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password)),
          label: 'Password',
          hint: 'Masukkan password kamu',
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return AuthTextField(
          obscure: true,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          errorText: (state.status.isPure)
              ? null
              : PasswordSecure.getErrorText(state.confirmPassword.error),
          onChanged: (password) => context
              .read<RegisterBloc>()
              .add(RegisterConfirmPasswordChanged(password)),
          label: 'Password',
          hint: 'Masukkan password kamu',
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
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
          onPressed: state.email.valid &&
                  state.password.valid &&
                  state.name.valid &&
                  state.confirmPassword.valid
              ? () {
                  if (state.password.value == state.confirmPassword.value) {
                    if (state.status.isPure ||
                        (!state.status.isSubmissionInProgress &&
                            state.status.isValid)) {
                      context.read<RegisterBloc>().add(RegisterRequested());
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: Text(
                          'Password tidak sama',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ));
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
              : const Text('Daftar'),
        );
      },
    );
  }
}
