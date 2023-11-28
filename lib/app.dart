import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kuraw/config/screen_util.dart';
import 'package:kuraw/core/data/repository/user_repository.dart';
import 'package:kuraw/core/http_client.dart';
import 'package:kuraw/features/auth/bloc/auth_bloc.dart';
import 'package:kuraw/features/auth/data/repositories/auth_repository.dart';
import 'package:kuraw/features/auth/presentation/screens/login_page.dart';
import 'package:kuraw/features/home/bloc/feed_bloc.dart';
import 'package:kuraw/features/home/data/repository/post_repository.dart';
import 'package:kuraw/features/home/presentation/screens/home_page.dart';
import 'package:kuraw/features/splash/presentation/screens/splash_page.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthRepo _authenticationRepository;
  late final UserRepository _userRepository;
  late final PostRepository _postRepository;
  late final HttpClient _dio;
  late final FlutterSecureStorage _storage;

  @override
  void initState() {
    _dio = HttpClient();
    _storage = const FlutterSecureStorage();
    _authenticationRepository = AuthRepo(_dio, _storage);
    _userRepository = UserRepository(_dio);
    _postRepository = PostRepository(_dio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _postRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
              authenticationRepository: _authenticationRepository,
              userRepository: _userRepository,
            ),
          ),
          BlocProvider(
            create: (_) => FeedBloc(postRepository: _postRepository)
              ..add(const FeedFetched()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  var showedSplash = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.from(colorScheme: const ColorScheme.dark()),
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          breakpoints: ScreenUtils.breakpoints,
          child: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                if (showedSplash) return child!;
                showedSplash = true;

                return const SplashPage();
              }
              return BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  switch (state.status) {
                    case UserAuthenticationStatus.unknown:
                      _navigator.pushAndRemoveUntil<void>(
                        SplashPage.route(),
                        (route) => false,
                      );
                      break;
                    case UserAuthenticationStatus.signedIn:
                      _navigator.pushAndRemoveUntil<void>(
                        HomePage.route(),
                        (route) => false,
                      );
                      break;
                    case UserAuthenticationStatus.signedOut:
                      _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                        (route) => false,
                      );
                      break;
                    default:
                      break;
                  }
                },
                child: child,
              );
            },
          ),
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
