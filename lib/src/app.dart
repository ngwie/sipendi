import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/medical_record/views/medical_record_detail.dart';
import 'package:sipendi/src/medical_record/views/medical_record_from.dart';
import 'package:sipendi/src/medical_record/views/medical_record_menu.dart';
import 'package:sipendi/src/models/user_auth.dart';
import 'package:sipendi/src/screens/home.dart';
import 'package:sipendi/src/screens/medicine.dart';
import 'package:sipendi/src/screens/medicine_add.dart';
import 'package:sipendi/src/screens/medicine_detail.dart';
import 'package:sipendi/src/screens/reminder.dart';
import 'package:sipendi/src/screens/reminder_add.dart';
import 'package:sipendi/src/screens/reminder_edit.dart';
import 'package:sipendi/src/screens/sign_in.dart';
import 'package:sipendi/src/screens/sign_up.dart';
import 'package:sipendi/src/theme.dart';

import 'medical_record/bloc/medical_record_bloc.dart';

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
            path: 'medical-record',
            builder: (context, state) => const MedicalRecordMenuScreen(),
            routes: [
              GoRoute(
                path: ':pageTypeName',
                builder: (context, state) => MedicalRecordDetailScreen(
                  pageTypeName: state.pathParameters['pageTypeName']!,
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => MedicalRecordAddScreen(
                      pageTypeName: state.pathParameters['pageTypeName']!,
                    ),
                  )
                ],
              ),
            ],
          ),
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
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    ReminderEditScreen(id: state.pathParameters['id']!),
              ),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<MedicalRecordBloc>(
          create: (BuildContext context) => MedicalRecordBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeConfig.theme,
      ),
    );
  }
}
