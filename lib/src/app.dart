import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/models/user_auth.dart';
import 'package:sipendi/src/screens/home.dart';
import 'package:sipendi/src/screens/medicine.dart';
import 'package:sipendi/src/screens/medicine_add.dart';
import 'package:sipendi/src/screens/medicine_detail.dart';
import 'package:sipendi/src/screens/reminder.dart';
import 'package:sipendi/src/screens/reminder_add.dart';
import 'package:sipendi/src/screens/sign_in.dart';
import 'package:sipendi/src/screens/sign_up.dart';
import 'package:sipendi/src/theme.dart';

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
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'medicine',
            builder: (context, state) => const MedicineScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const MedicineAddScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    MedicineDetailScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: 'reminder',
            builder: (context, state) => const ReminderScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const ReminderAddScreen(),
              )
            ],
          ),
        ],
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
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: ThemeColor.greenSheen,
          onPrimary: ThemeColor.paleSpringBud,
          secondary: ThemeColor.rackley,
          onSecondary: ThemeColor.paleSpringBud,
          error: ThemeColor.sunsetOrange,
          onError: ThemeColor.paleSpringBud,
          background: Colors.white,
          onBackground: ThemeColor.greenSheen,
          surface: Colors.white,
          onSurface: ThemeColor.rackley,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6A8CAF),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: ThemeColor.greenSheen,
          ),
        ),
      ),
    );
  }
}
