import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/activity.dart';
import 'package:si_pintar/models/class_model.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/repository/user_repository.dart';
import 'package:si_pintar/screen/auth/login_page.dart';
import 'package:si_pintar/screen/matkul/matkul_page.dart';
import 'package:si_pintar/screen/profile/profile_page.dart';
import 'package:si_pintar/screen/schedule/schedule_page.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    // Check session first
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isLoggedIn = await SessionManager.isLoggedIn();
      if (!isLoggedIn && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        return;
      }
      _loadHomeData();
    });
  }

  Future<void> _loadHomeData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await SessionManager.getCurrentUserId();
      // final userEmail = await SessionManager.getCurrentUserEmail();
      print("USER ID: $userId");

      if (userId != null) {
        final userService = UserService();
        _user = await userService.getUserFromSession(userId.toString());

        try {
          // Fetch classes using ClassService and handle potential null response
          final classesResponse = await _classService.getClasses(_user!.userId);
          print("\n=== PARSED CLASSES DATA ===");
          for (var cls in classesResponse) {
            print("Title: ${cls.title}");
            print("Credits: ${cls.credits}");
            print("Semester: ${cls.semester}");
            print("-------------------");
          }
          setState(() {
            _classes = classesResponse;
          });
        } catch (e) {
          print('Error fetching classes: $e');
          setState(() {
            _classes = [];
          });
        }
      }

      // try {
      //   if (DummyData.announcements != null) {
      //     _activities = (jsonDecode(DummyData.announcements) as List)
      //         .map((json) => Activity.fromJson(json))
      //         .toList();
      //   } else {
      //     _activities = [];
      //     print('Warning: DummyData.announcements is null');
      //   }
      // } catch (e) {
      //   print('Error parsing activities: $e');
      //   _activities = [];
      // }

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
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            course.title.isNotEmpty ? course.title.substring(0, 1) : '-',
            style: TextStyle(color: Colors.blue.shade700),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${course.credits ?? 0} SKS - Semester ${course.semester ?? 0}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print("iddddd" + course.classId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MatkulPage(courseId: course.classId)));
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          SchedulePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          NavigationDestination(
            icon: Builder(
              builder: (context) {
                return _user?.image_url != null && _user!.image_url.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _user!.image_url,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person_outline);
                          },
                        ),
                      )
                    : const Icon(Icons.person_outline);
              },
            ),
            selectedIcon: const Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
