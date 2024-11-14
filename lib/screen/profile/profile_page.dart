import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/providers/home_provider.dart';
import 'package:si_pintar/screen/profile/profile_edit.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_pintar/screen/profile/update_password.dart';

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
    // user = User.fromJson(jsonDecode(DummyData.profile));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
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

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (provider.error != null) {
        print('Error: ${provider.error}');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(provider.error!),
              ElevatedButton(
                onPressed: () => provider.loadHomeData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

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
                            backgroundImage: NetworkImage(
                                provider.user?.imageUrl ??
                                    'https://via.placeholder.com/100'),
                            onBackgroundImageError: (_, __) =>
                                const Text("Error")),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.user?.full_name ?? "",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'NIM: ${provider.user?.nim?.toString() ?? ""}',
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                      height: 12,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Menu Lainnya",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
    });
  }
}
