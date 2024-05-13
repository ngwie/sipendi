import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth/models/user_auth.dart';

enum ProfileMenuItem { logout }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<UserAuthModel>(builder: (context, model, child) {
            return PopupMenuButton<ProfileMenuItem>(
              iconSize: 36,
              icon: Icon(
                Icons.account_circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onSelected: (ProfileMenuItem item) async {
                await model.signOut();

                if (context.mounted) {
                  context.pushReplacement('/login');
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ProfileMenuItem>>[
                const PopupMenuItem<ProfileMenuItem>(
                  value: ProfileMenuItem.logout,
                  child: Text('Logout'),
                ),
              ],
            );
          }),
          const SizedBox(width: 8)
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            _greetings(context),
            const SizedBox(height: 32),
            Wrap(
              runSpacing: 32,
              children: [
                _menuItem(
                  context,
                  title: 'Rekam Data',
                  iconPath: 'assets/icon/list_alt.svg',
                  to: '/medical-record',
                ),
                _menuItem(
                  context,
                  title: 'Pengingat',
                  iconPath: 'assets/icon/reminder.svg',
                  to: '/reminder',
                ),
                _menuItem(
                  context,
                  title: 'Daftar Obat',
                  iconPath: 'assets/icon/meds.svg',
                  to: '/medicine',
                ),
                _menuItem(
                  context,
                  title: 'Keluhan Obat',
                  iconPath: 'assets/icon/side_effect.svg',
                  to: '/consultation',
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _greetings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<UserAuthModel>(builder: (context, model, child) {
          final fullName = model.userDetail?.fullName ?? '';

          return RichText(
            text: TextSpan(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              children: [
                const TextSpan(text: 'Hello, '),
                TextSpan(
                  text: fullName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }),
        Text('Beranda', style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required String title,
    required String iconPath,
    String? to,
  }) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (to != null) context.push(to);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(22.5),
              ),
              child: SvgPicture.asset(iconPath, semanticsLabel: title),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
