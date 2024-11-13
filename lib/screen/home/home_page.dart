import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/activity.dart';
import 'package:si_pintar/models/course.dart';
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
  final courses = DummyData.courses;
  final activities = DummyData.activities;
  final profile = DummyData.profile;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildActivityCard(Activity activity) {
    return Card(
      elevation: 4,
      color: activity.color,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatkulPage()),
        ),
        child: Container(
          width: 200,
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

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.lecture:
        return Icons.school;
      case ActivityType.practicum:
        return Icons.science;
      case ActivityType.exam:
        return Icons.assignment;
      case ActivityType.assignment:
        return Icons.task;
      case ActivityType.project:
        return Icons.work;
    }
  }

  Widget _buildCourseCard(Course course) {
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
    return SingleChildScrollView(
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
                        'Selamat Datang \n${profile['fullName']}!',
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Semester ${profile['semester']} - ${profile['academicYear']}",
                        style: TextStyle(color: Colors.blue.shade100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: const Text(
                    "Kegiatan Terdekat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activities.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        right: 12,
                        left: index == 0 ? 16 : 0,
                      ),
                      child: _buildActivityCard(activities[index]),
                    ),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildCourseCard(courses[index]),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
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
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          NavigationDestination(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                profile['imageUrl']!,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person_outline);
                },
              ),
            ),
            // selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
