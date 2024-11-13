import 'package:flutter/material.dart';
import 'package:si_pintar/screen/matkul/matkul_page.dart';
import 'package:si_pintar/screen/profile/profile_page.dart';
import 'package:si_pintar/screen/schedule/schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Move data to separate files/models
  static const List<Map<String, dynamic>> _courses = [
    {
      'title': 'Pemrograman Mobile',
      'subtitle': 'Semester 5 - 3 SKS',
    },
    {
      'title': 'Basis Data Lanjut',
      'subtitle': 'Semester 5 - 3 SKS',
    },
    {
      'title': 'Kecerdasan Buatan',
      'subtitle': 'Semester 5 - 3 SKS',
    },
    {
      'title': 'Pemrograman Web',
      'subtitle': 'Semester 5 - 3 SKS',
    },
    {
      'title': 'Analisis Algoritma',
      'subtitle': 'Semester 5 - 3 SKS',
    },
  ];

  static const List<Map<String, dynamic>> _activities = [
    {
      'title': 'Kuliah',
      'subtitle': 'Pemrograman Mobile',
      'color': Colors.blue,
      'route': '/kuliah',
    },
    {
      'title': 'Praktikum',
      'subtitle': 'Basis Data',
      'color': Colors.green,
      'route': '/praktikum',
    },
    {
      'title': 'UTS',
      'subtitle': 'Pemrograman Web',
      'color': Colors.blue,
      'route': '/uts',
    },
    {
      'title': 'Tugas',
      'subtitle': 'Artificial Intelligence',
      'color': Colors.green,
      'route': '/tugas',
    },
    {
      'title': 'Project',
      'subtitle': 'Mobile App',
      'color': Colors.blue,
      'route': '/project',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onActivityTapped(String title) {
    debugPrint('Activity tapped: $title');
  }

  void _onCourseTapped(String title) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MatkulPage()));
    debugPrint('Course tapped: $title');
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 150,
      height: 100,
      child: Material(
        color: activity['color'] as Color,
        child: InkWell(
          onTap: () => _onActivityTapped(activity['title'] as String),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  activity['subtitle'] as String,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(course['title'] as String),
        subtitle: Text(course['subtitle'] as String),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: () => _onCourseTapped(course['title'] as String),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Image.network(
            'https://imgs.search.brave.com/xAxkYgIPUop0epjylba0ZriId-OeyFMWJcBFq5LArZo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9ibG9n/Z2VyLmdvb2dsZXVz/ZXJjb250ZW50LmNv/bS9pbWcvYi9SMjl2/WjJ4bC9BVnZYc0Vp/bkVVSEVjNE5ZUzY3/cFA1MW1STXVfNTV1/ZFk2bHd1OFlxZVQ2/UmNWdG1GWVNoV0ta/emVIQ1hDbk5YcUZv/NlRWcG5mQTFCZHM5/RWlleDVaallwRXdm/em9YRTV6ZGh4RDdl/aHQ3Y1FyUHRGM1h0/Z2Z1RVRCOEFDdmlQ/YVR1X01kVFNqS0RZ/d1VPZHlmVTAvczE2/MDAvd2FsbHBhcGVy/K2tlcmVuK3N1a3Nl/cytkYW4ra2VnYWdh/bGFuKyUyNTI4RklM/RW1pbmltaXplciUy/NTI5LmpwZw',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Kegiatan terdekat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _activities.map(_buildActivityCard).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Mata Kuliah",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _courses.length,
              itemBuilder: (context, index) =>
                  _buildCourseItem(_courses[index]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 0 || _selectedIndex == 1
            ? const Icon(Icons.account_circle_rounded)
            : null,
        title: Text(_selectedIndex == 0
            ? "Si Pintar"
            : _selectedIndex == 1
                ? "Jadwal"
                : "Profil"),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          SchedulePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
