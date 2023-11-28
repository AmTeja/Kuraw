import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kuraw/core/util/context_extensions.dart';
import 'package:kuraw/core/widgets/responsive_textfield.dart';
import 'package:kuraw/features/auth/bloc/register_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something Went Wrong'),
              ),
            );
        }
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RegisterHeader(),
          _ProfilePictureInput(),
          SizedBox(height: 16),
          _UsernameInput(),
          SizedBox(height: 16),
          _PasswordInput(),
          SizedBox(height: 16),
          _EmailInput(),
          SizedBox(height: 16),
          Spacer(),
          _RegisterButton(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

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
            'Welcome to Kuraw',
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

class _ProfilePictureInput extends StatelessWidget {
  const _ProfilePictureInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.previousProfilePic != current.previousProfilePic ||
          previous.status != current.status,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RTextField(
                      onChanged: (profilePic) => context
                          .read<RegisterBloc>()
                          .add(RegisterProfilePicChanged(profilePic)),
                      hintText: 'Profile Picture URL',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<RegisterBloc>()
                            .add(const RegisterProfilePicSubmitted());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: 50,
            foregroundImage: NetworkImage(
              state.previousProfilePic ?? 'https://www.gravatar.com/avatar/',
            ),
          ),
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.username != current.username ||
          previous.status != current.status,
      builder: (context, state) {
        return RTextField(
          key: const Key('registerForm_usernameInput_textField'),
          onChanged: (username) => context
              .read<RegisterBloc>()
              .add(RegisterUsernameChanged(username)),
          hintText: 'Username',
          errorText: state.status.isFailure ? 'Invalid Username Format' : null,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.status != current.status,
      builder: (context, state) {
        return RTextField(
          key: const Key('registerForm_passwordInput_textField'),
          onChanged: (password) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password)),
          obscureText: true,
          hintText: 'Password',
          errorText: state.status.isFailure ? 'Invalid Password Format' : null,
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.email != current.email || previous.status != current.status,
      builder: (context, state) {
        return RTextField(
            key: const Key('registerForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<RegisterBloc>().add(RegisterEmailChanged(email)),
            hintText: 'Email',
            errorText: state.status.isFailure ? 'Invalid Email Format' : null);
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.isValid != current.isValid ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(context.rWidth, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          key: const Key('registerForm_continue_raisedButton'),
          onPressed: state.isValid
              ? () {
                  context.read<RegisterBloc>().add(const RegisterSubmitted());
                }
              : null,
          child: const Text('Register'),
        );
      },
    );
  }
}
