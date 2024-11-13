import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/screen/profile/profile_edit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_pintar/screen/profile/update_password.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final profile = DummyData.profile;

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
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 32),
                height: 100,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile['imageUrl']!),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profile['fullName']!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'NIM: ${profile['nim']!}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pengaturan",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Text("Edit Profil"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePasswordPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Text("Ganti Password"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Menu Lainnya",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ...menuLainnya
                      .map((menu) => Column(
                            children: [
                              Card(
                                child: InkWell(
                                  onTap: menu['onTap'],
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        menu['icon'] != null
                                            ? Icon(menu['icon'])
                                            : Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(menu['title']),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
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
