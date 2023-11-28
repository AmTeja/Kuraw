import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kuraw/core/util/context_extensions.dart';
import 'package:kuraw/core/widgets/responsive_textfield.dart';
import 'package:kuraw/features/auth/bloc/login_bloc.dart';
import 'package:kuraw/features/auth/presentation/screens/register_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? 'Something Went Wrong')),
            );
        }
      },
      child: const Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LoginHeader(),
            _UsernameInput(),
            SizedBox(height: 16),
            _PasswordInput(),
            SizedBox(height: 16),
            _RegisterText(),
            SizedBox(height: 16),
            Spacer(),
            _LoginButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      alignment: Alignment.topCenter,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text(
            'Login to Kuraw',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return RTextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          hintText: 'Username',
          errorText: state.username.displayError != null
              ? 'Invalid username format'
              : null,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return RTextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          hintText: 'Password',
          errorText: state.password.displayError != null
              ? 'Invalid password format'
              : null,
        );
      },
    );
  }
}

class _RegisterText extends StatelessWidget {
  const _RegisterText();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('loginForm_register_raisedButton'),
      onTap: () => Navigator.of(context).push(RegisterPage.route()),
      child: RichText(
        text: TextSpan(
          text: 'Don\'t have an account?',
          style: TextStyle(color: context.colorScheme.onBackground),
          children: [
            TextSpan(
              text: ' Register',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.end,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const CircularProgressIndicator();
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(context.rWidth, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            key: const Key('loginForm_continue_raisedButton'),
            onPressed: !state.isValid
                ? null
                : () => context.read<LoginBloc>().add(const LoginSubmitted()),
            child: const Text('Login'),
          );
        }
      },
    );
  }
}
