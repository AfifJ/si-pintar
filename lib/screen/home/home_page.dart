import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/activity.dart';
import 'package:si_pintar/models/class_model.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/screen/auth/login_page.dart';
import 'package:si_pintar/screen/matkul/matkul_page.dart';
import 'package:si_pintar/screen/nilai/nilai_page.dart';
import 'package:si_pintar/screen/profile/profile_page.dart';
import 'package:si_pintar/screen/schedule/schedule_page.dart';
import 'package:si_pintar/screen/ukt/ukt_page.dart';
import 'package:si_pintar/screen/nilai/nilai_page.dart';
import 'package:intl/intl.dart';
import 'package:si_pintar/services/conversion/convert_currency.dart';
import 'package:si_pintar/services/conversion/convert_time.dart';
import 'package:si_pintar/services/remote/user_service.dart';
import 'package:si_pintar/services/session_manager.dart';
import 'package:si_pintar/services/remote/class_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  String? _error;
  User? _user;
  List<ClassModel> _classes = [];
  List<Activity> _activities = [];
  final ClassService _classService = ClassService();

  // Add PageController
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Check session when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionAndLoadData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkSessionAndLoadData() async {
    final userId = await SessionManager.getCurrentUserId();
    print('Current user ID: $userId'); // Print user ID for debugging

    if (userId == null) {
      print('No user logged in - redirecting to login page');
      // Redirect to login if session is invalid
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      print('User logged in with ID: $userId - loading home data');
      // Load home data if session is valid
      _loadHomeData();
    }
  }

  Future<void> _loadHomeData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await SessionManager.getCurrentUserId();
      if (!mounted) return;

      if (userId != null) {
        final userService = UserService();
        _user = await userService.getUserFromSession(userId.toString());
        if (!mounted) return;

        try {
          final classesResponse = await _classService.getClasses(_user!.userId);
          if (!mounted) return;

          setState(() {
            _classes = classesResponse;
          });
        } catch (e) {
          print('Error fetching classes: $e');
          if (!mounted) return;
          setState(() {
            _classes = [];
          });
        }
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Error: $e\n\nStack Trace:\n${stackTrace.toString()}';
      });
    }
  }

  Future<void> refreshData() async {
    await _loadHomeData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Animate to the selected page when tapping bottom nav items
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildActivityCard(Activity activity) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MatkulPage(courseId: ,)),
          // );
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: _getActivityColor(activity.type),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getActivityIcon(activity.type),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activity.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                activity.subtitle,
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(activity.dateTime),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'lecture':
        return Icons.school;
      case 'practicum':
        return Icons.science;
      case 'exam':
        return Icons.assignment;
      case 'assignment':
        return Icons.task;
      case 'project':
        return Icons.work;
    }
    return Icons.info;
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'lecture':
        return Colors.blue;
      case 'practicum':
        return Colors.green;
      case 'exam':
        return Colors.red;
      case 'assignment':
        return Colors.orange;
      case 'project':
        return Colors.purple;
    }
    return Colors.grey;
  }

  Widget _buildCourseCard(ClassModel course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            course.title.isNotEmpty ? course.title.substring(0, 1) : '-',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('${course.credits} SKS - Semester ${course.semester}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatkulPage(courseId: course.classId),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 12),

            // Quick actions skeleton
            Row(
              children: List.generate(
                2,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == 1 ? 16 : 8,
                    ),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            // Course list skeleton
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Course card skeletons
                  ...List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: refreshData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://unsplash.it/2000/1000',
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(0.2),
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.blue.shade200,
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Selamat Datang\n${_user?.email}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Semester ${_user?.semester} - ${_user?.academic_year}",
                          style: TextStyle(color: Colors.blue.shade100),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 8),
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
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.payment_outlined,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        title: const Text(
                          'Bayar UKT',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          'Pembayaran UKT',
                          maxLines: 2,
                        ),
                        // trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UktPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8, right: 16),
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
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calculate_outlined,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        title: const Text(
                          'Nilai',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          'Kalkulasi IPK',
                          maxLines: 2,
                        ),
                        // trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NilaiPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 24),
                  const Text(
                    "Mata Kuliah",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _classes.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildCourseCard(_classes[index]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildHomeContent(),
          SchedulePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          height: 65,
          elevation: 0,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.shade50,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 500),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0 ? Colors.blue.shade700 : Colors.grey,
              ),
              selectedIcon: Icon(Icons.home, color: Colors.blue.shade700),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.calendar_today_outlined,
                color: _selectedIndex == 1 ? Colors.blue.shade700 : Colors.grey,
              ),
              selectedIcon:
                  Icon(Icons.calendar_today, color: Colors.blue.shade700),
              label: 'Jadwal',
            ),
            NavigationDestination(
              icon: Builder(
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedIndex == 2
                            ? Colors.blue.shade700
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: _user?.image_url != null &&
                              _user!.image_url.isNotEmpty
                          ? Image.network(
                              _user!.image_url,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  color: Colors.blue.shade50,
                                  child: Text(
                                    _user?.full_name.isNotEmpty == true
                                        ? _user!.full_name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: _selectedIndex == 2
                                          ? Colors.blue.shade700
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              color: Colors.blue.shade50,
                              child: Text(
                                _user?.full_name.isNotEmpty == true
                                    ? _user!.full_name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: _selectedIndex == 2
                                      ? Colors.blue.shade700
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
