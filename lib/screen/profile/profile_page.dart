import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/screen/profile/kesan_pesan_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_pintar/services/remote/user_service.dart';
import 'package:si_pintar/services/session_manager.dart';
import 'package:si_pintar/screen/auth/login_page.dart';
import 'package:si_pintar/services/database_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserService _userService = UserService();
  Map<String, dynamic>? user;
  bool _isEditingUsername = false;
  bool _isEditingPassword = false;
  bool _isLoading = true;
  final DatabaseService _databaseService = DatabaseService();
  final ImagePicker _picker = ImagePicker();
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadProfileImage();
  }

  Future<void> _loadUser() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await SessionManager.getCurrentUserId();
      if (!mounted) return;

      final userData = await _userService.getUserFromSession(userId!);
      if (!mounted) return;

      setState(() {
        user = userData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProfileImage() async {
    final imagePath = await _databaseService.getProfileImage();
    if (imagePath != null) {
      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  Future<void> _handleLogout() async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Konfirmasi Logout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Apakah Anda yakin ingin keluar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        // style: ElevatedButton.styleFrom(
                        //   padding: const EdgeInsets.symmetric(vertical: 16),
                        //   // backgroundColor: Colors.grey[200],
                        //   // shape: RoundedRectangleBorder(
                        //   //   borderRadius: BorderRadius.circular(12),
                        //   // ),
                        // ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Ya, Keluar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmLogout == true) {
      try {
        await SessionManager.clearSession();
        await _databaseService.deleteAllMataKuliah();
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
      await _databaseService.saveProfileImage(pickedFile.path);
    }
  }

  Widget _buildSkeletonBox({double? width, double height = 20}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildProfileSection() {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.only(bottom: 32),
        height: 100,
        child: Row(
          children: [
            _buildSkeletonBox(width: 100, height: 100),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonBox(width: 150, height: 24),
                const SizedBox(height: 10),
                _buildSkeletonBox(width: 100, height: 18),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      height: 100,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showImageSourceActionSheet(),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _profileImagePath != null
                  ? FileImage(File(_profileImagePath!))
                  : NetworkImage(user?['image_url'] ?? '') as ImageProvider,
              onBackgroundImageError: (_, __) => Text(
                (user?['full_name'] as String?)?.isNotEmpty == true
                    ? (user?['full_name'] as String)
                        .substring(0, 1)
                        .toUpperCase()
                    : "?",
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
              backgroundColor: Colors.blue,
              child: null,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?['full_name'] ?? "",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'NIM: ${user?['npm'].toString()}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard(String title, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              const Text(
                "Pengaturan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Username editing section
              _buildSettingsCard(
                  "Nama Lengkap",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(user?['full_name'] ?? ''),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditingUsername = !_isEditingUsername;
                                if (_isEditingUsername) {
                                  _usernameController.text =
                                      user?['full_name'] ?? '';
                                }
                              });
                            },
                            child: Text(_isEditingUsername ? "Batal" : "Ubah"),
                          ),
                        ],
                      ),
                      if (_isEditingUsername) ...[
                        const SizedBox(height: 8),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Baru',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    () async {
                                      try {
                                        final userId = await SessionManager
                                            .getCurrentUserId();
                                        final success =
                                            await _userService.updateFullName(
                                          userId!,
                                          _usernameController.text,
                                        );
                                        if (success) {
                                          await _loadUser();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Nama berhasil diperbarui')),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                    }();

                                    setState(() {
                                      _isEditingUsername = false;
                                    });
                                  }
                                },
                                child: const Text('Simpan Username'),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  )),

              const SizedBox(height: 6),

              // Password editing section
              _buildSettingsCard(
                  "Password",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Password"),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditingPassword = !_isEditingPassword;
                              });
                            },
                            child: Text(_isEditingPassword ? "Batal" : "Ubah"),
                          ),
                        ],
                      ),
                      if (_isEditingPassword) ...[
                        const SizedBox(height: 8),
                        Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _currentPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password Saat Ini',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _newPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password Baru',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Konfirmasi Password Baru',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Future<void> _updatePassword() async {
                                    if (_currentPasswordController
                                            .text.isEmpty ||
                                        _newPasswordController.text.isEmpty ||
                                        _confirmPasswordController
                                            .text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Semua field harus diisi'),
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      final userId = await SessionManager
                                          .getCurrentUserId();
                                      final userData = await _userService
                                          .getUserFromSession(userId!);

                                      // Try logging in with current password to verify
                                      await _userService.login(
                                          userData['email'],
                                          _currentPasswordController.text);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Password lama tidak sesuai'),
                                        ),
                                      );
                                      return;
                                    }

                                    if (_newPasswordController.text !=
                                        _confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Password baru dan konfirmasi tidak cocok'),
                                        ),
                                      );
                                      return;
                                    }

                                    // Verify current password

                                    try {
                                      final userId = await SessionManager
                                          .getCurrentUserId();
                                      await _userService.updatePassword(
                                          userId!, _newPasswordController.text);

                                      _currentPasswordController.clear();
                                      _newPasswordController.clear();
                                      _confirmPasswordController.clear();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Password berhasil diperbarui')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Gagal memperbarui password: $e'),
                                        ),
                                      );
                                      return;
                                    }
                                  }

                                  _updatePassword();
                                  // TODO: Implement update password logic

                                  setState(() {
                                    _isEditingPassword = false;
                                  });
                                },
                                child: const Text('Simpan Password'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  )),

              // Logout card
              const SizedBox(height: 6),
              Card(
                elevation: 0,
                color: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: _handleLogout,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.red[700],
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                          builder: (context) => const KesanPesanPage()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue.withOpacity(0.1),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.message,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text('Feedback'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
