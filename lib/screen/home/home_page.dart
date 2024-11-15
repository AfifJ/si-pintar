import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/activity.dart';
import 'package:si_pintar/models/class_model.dart';
import 'package:si_pintar/models/user.dart';
import 'package:si_pintar/repository/user_repository.dart';
import 'package:si_pintar/screen/matkul/matkul_page.dart';
import 'package:si_pintar/screen/profile/profile_page.dart';
import 'package:si_pintar/screen/schedule/schedule_page.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    // Load data when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHomeData();
    });
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      final userRepo = UserRepository();
      _user = await userRepo.getUser();

      _classes = (jsonDecode(DummyData.classes) as List)
          .map((json) => ClassModel.fromJson(json))
          .toList();

      _activities = (jsonDecode(DummyData.announcements) as List)
          .map((json) => Activity.fromJson(json))
          .toList();
      // _activities = [
      //   Activity(
      //       title: "Mobile Programming",
      //       subtitle: "Lecture",
      //       type: "lecture",
      //       dateTime: DateTime.now()),
      // ];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MatkulPage()),
        ),
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
            course.title.substring(0, 1),
            style: TextStyle(color: Colors.blue.shade700),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${course.credits} SKS - Semester ${course.semester}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MatkulPage()),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // if (_error != null) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(_error!),
    //         ElevatedButton(
    //           onPressed: _loadHomeData,
    //           child: const Text('Retry'),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    if (_user == null) {
      return const Center(child: Text('No user data'));
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
                          'Selamat Datang\n${_user!.full_name}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Semester ${_user!.semester} - ${_user!.academicYear}",
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
                  const SizedBox(height: 24),
                  const Text(
                    "Mata Kuliah",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                return _user?.imageUrl != null && _user!.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _user!.imageUrl,
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
