import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/screens/medicine.dart';
import 'package:sipendi/src/screens/medicine_add.dart';
import 'package:sipendi/src/screens/medicine_detail.dart';

import 'auth/models/user_auth.dart';
import 'auth/views/sign_in.dart';
import 'auth/views/sign_up.dart';
import 'auth/views/reset_password.dart';
import 'auth/views/verify_otp.dart';
import 'auth/views/change_password.dart';
import 'config/cubit/config_cubit.dart';
import 'consultation/bloc/consultation_bloc.dart';
import 'consultation/views/consultation.dart';
import 'consultation/views/consultation_form.dart';
import 'home/views/home.dart';
import 'medical_record/bloc/medical_record_bloc.dart';
import 'medical_record/views/medical_record_detail.dart';
import 'medical_record/views/medical_record_from.dart';
import 'medical_record/views/medical_record_menu.dart';
import 'patient_medicine/bloc/patient_medicine_bloc.dart';
import 'reminder/bloc/reminder_bloc.dart';
import 'reminder/views/reminder.dart';
import 'reminder/views/reminder_add.dart';
import 'reminder/views/reminder_edit.dart';
import 'theme.dart';

final _router = GoRouter(
  redirect: (context, state) {
    const unprotectedPath = [
      '/login',
      '/register',
      '/reset-password',
      '/reset-password/verify-otp',
    ];

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
        GoRoute(
          path: 'consultation',
          builder: (context, state) => const ConsultationScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const ConsultationFormScreen(),
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
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
      routes: [
        GoRoute(
          path: 'verify-otp',
          builder: (context, state) =>
              VerifyOtpScreen(phone: state.extra! as String),
        ),
        GoRoute(
          path: 'change-password',
          builder: (context, state) => const ChangePasswordScreen(),
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConfigCubit>(
          lazy: false,
          create: (BuildContext context) => ConfigCubit()..fetch(),
        ),
        BlocProvider<MedicalRecordBloc>(
          create: (BuildContext context) => MedicalRecordBloc(),
        ),
        BlocProvider<ConsultationBloc>(
          create: (BuildContext context) => ConsultationBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => ReminderBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => PatientMedicineBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeConfig.theme,
      ),
    );
  }
}
