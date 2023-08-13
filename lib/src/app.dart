import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/models/user_auth.dart';
import 'package:sipendi/src/screens/home.dart';
import 'package:sipendi/src/screens/sign_in.dart';
import 'package:sipendi/src/screens/sign_up.dart';

final _router = GoRouter(
    redirect: (context, state) {
      const unprotectedPath = ['/login', '/register'];

      final signedIn =
          Provider.of<UserAuthModel>(context, listen: false).signedIn;
      final accessingUnprotectedPath = unprotectedPath.contains(state.fullPath);

      if (accessingUnprotectedPath && signedIn) {
        return '/home';
      }

      if (!accessingUnprotectedPath && !signedIn) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(title: 'SiPendDi'),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpScreen(),
      ),
    ]);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      // theme: ThemeData(
      //   useMaterial3: true,
      //   colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF75B79E)),
      // ),
    );
  }
}
