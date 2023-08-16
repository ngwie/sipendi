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
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Consumer<UserAuthModel>(builder: (context, model, child) {
            return PopupMenuButton<ProfileMenuItem>(
              iconSize: 36,
              icon: const Icon(
                Icons.account_circle,
                color: Color(0xFF6A8CAF),
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
      extendBodyBehindAppBar: true,
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
                    const Text(
                      'Beranda',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6A8CAF),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    _menuItem(
                      title: 'Rekam Data',
                      iconPath: 'assets/icon/list_alt.svg',
                    ),
                    const SizedBox(width: 50),
                    _menuItem(
                        title: 'Pengingat',
                        iconPath: 'assets/icon/reminder.svg'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    _menuItem(
                      title: 'Daftar Obat',
                      iconPath: 'assets/icon/meds.svg',
                    ),
                    const SizedBox(width: 50),
                    _menuItem(
                        title: 'Keluhan Obat',
                        iconPath: 'assets/icon/side_effect.svg'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({required String title, required String iconPath}) {
    return Expanded(
      child: Column(
        children: [
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF75B79E),
                borderRadius: BorderRadius.circular(45),
              ),
              child: Material(
                type: MaterialType.transparency,
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  icon: SvgPicture.asset(iconPath, semanticsLabel: title),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6A8CAF),
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
