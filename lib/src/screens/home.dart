import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sipendi/src/models/user_auth.dart';

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
          const SizedBox(width: 12)
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text(
                        'Hello, ',
                        style: TextStyle(
                          color: Color(0xFF75B79E),
                        ),
                      ),
                      Consumer<UserAuthModel>(
                        builder: (context, model, child) {
                          final fullName = model.userDetail?.fullName ?? '';
                          return Text(
                            fullName,
                            style: const TextStyle(
                              color: Color(0xFF75B79E),
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ]),
                    Text(
                      'Beranda',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    _menuItem(
                      context,
                      title: 'Rekam Data',
                      iconPath: 'assets/icon/list_alt.svg',
                    ),
                    const SizedBox(width: 50),
                    _menuItem(
                      context,
                      title: 'Pengingat',
                      iconPath: 'assets/icon/reminder.svg',
                      to: '/reminder',
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    _menuItem(
                      context,
                      title: 'Daftar Obat',
                      iconPath: 'assets/icon/meds.svg',
                      to: '/medicine',
                    ),
                    const SizedBox(width: 50),
                    _menuItem(
                      context,
                      title: 'Keluhan Obat',
                      iconPath: 'assets/icon/side_effect.svg',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context,
      {required String title, required String iconPath, String? to}) {
    return Expanded(
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
