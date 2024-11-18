import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/screen/profile/profile_edit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_pintar/screen/profile/update_password.dart';
import 'package:si_pintar/services/session_manager.dart';
import 'package:si_pintar/screen/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final User user;

  @override
  void initState() {
    super.initState();
    user = User.fromJson(jsonDecode(DummyData.profile));
  }

  final List<Map<String, dynamic>> menuLainnya = [
    {
      'icon': Icons.calculate,
      'title': 'Kalkulator',
      'onTap': () {
        // Add calculator functionality
      },
    },
    {
      'icon': Icons.currency_exchange,
      'title': 'Konversi Mata Uang',
      'onTap': () {
        // Add currency converter functionality
      },
    },
    {
      'icon': Icons.access_time,
      'title': 'Konversi Waktu',
      'onTap': () {
        // Add time converter functionality
      },
    },
    {
      'icon': Icons.message,
      'title': 'Kesan Pesan',
      'onTap': () {
        // Add testimonials functionality
      },
    },
  ];

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ya, Keluar'),
            ),
          ],
        );
      },
    );

    // If user confirms logout
    if (confirmLogout == true) {
      try {
        await SessionManager.clearSession();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal logout. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                height: 100,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.image_url

                              // ??'https://via.placeholder.com/100'
                              ),
                          onBackgroundImageError: (_, __) =>
                              const Text("Error")),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.full_name ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'NIM: ${user.npm.toString()}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pengaturan",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileEditPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Edit Profil"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdatePasswordPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Ganti Password"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Card(
                    child: InkWell(
                      onTap: _handleLogout,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: const Text("Logout"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Menu Lainnya",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...menuLainnya
                      .map((menu) => Column(
                            children: [
                              Card(
                                child: InkWell(
                                  onTap: menu['onTap'] as void Function()?,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        menu['icon'] != null
                                            ? Icon(menu['icon'] as IconData)
                                            : Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(menu['title'] as String),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ))
                      .toList(),
                ],
              )
            ],
          )),
    );
  }
}
