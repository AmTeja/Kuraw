import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuraw/features/auth/bloc/login_bloc.dart';
import 'package:kuraw/features/auth/presentation/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocProvider(
          create: (context) => LoginBloc(
            authenticationRepository: RepositoryProvider.of(context),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
