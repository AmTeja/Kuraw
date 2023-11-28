import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuraw/features/auth/bloc/register_bloc.dart';
import 'package:kuraw/features/auth/data/repositories/auth_repository.dart';
import 'package:kuraw/features/auth/presentation/widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const RegisterPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: BlocProvider(
          create: (context) => RegisterBloc(
            authenticationRepository: RepositoryProvider.of<AuthRepo>(context),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
