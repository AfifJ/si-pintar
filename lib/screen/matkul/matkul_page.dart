// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/screen/matkul/presensi_dialog.dart';
import 'package:si_pintar/screen/matkul/submit_task_page.dart';
import 'package:si_pintar/services/remote/class_service.dart';
import 'package:si_pintar/services/session_manager.dart';

class MatkulPage extends StatefulWidget {
  final String courseId;
  const MatkulPage({super.key, required this.courseId});

  @override
  State<MatkulPage> createState() => _MatkulPageState();
}

class _MatkulPageState extends State<MatkulPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<void> _matkulDataFuture;
  List<Map<String, dynamic>> announcements = [];
  List<Map<String, dynamic>> attendances = [];
  Map<String, dynamic> classDetails = {};
  final ClassService _classService = ClassService();
  String? userId;

  @override
  void initState() {
    super.initState();
    // final meetingsJson = jsonDecode(DummyData.meetings);
    // meetings = (meetingsJson as List)
    //     .map((item) => Map<String, dynamic>.from(item))
    //     .toList();

    _loadClassDetails();
    _loadAttendances();
    // _loadAssignments();
    // final tasksJson = jsonDecode(DummyData.tasks);
    // tasks = (tasksJson as List)
    //     .map((item) => Map<String, dynamic>.from(item))
    //     .toList();

    _tabController = TabController(length: 3, vsync: this);
    _matkulDataFuture = _loadData();
  }

  Future<void> _loadClassDetails() async {
    final classDetailsData =
        await _classService.getClassDetails(widget.courseId);
    setState(() {
      classDetails = classDetailsData;
    });
  }

  Future<void> _loadAttendances() async {
    try {
      userId = await SessionManager.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final attendancesData =
          await _classService.getClassAttendances(widget.courseId, userId!);
      setState(() {
        attendances = attendancesData;
      });
    } catch (e) {
      print('Error loading attendances: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      userId = await SessionManager.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final announcementsData =
          await _classService.getClassAnnouncements(widget.courseId, userId!);
      setState(() {
        announcements = announcementsData;
      });
    } catch (e) {
      print('Error loading announcements: $e');
      // You might want to show an error message to the user here
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPengumumanTab() {
    return FutureBuilder(
      future: _matkulDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return ListView.builder(
          itemCount: announcements.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  announcement['material_title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(announcement['date'] ?? ''),
                    Text(announcement['description'] ?? ''),
                    if (announcement['has_attachment'] == true)
                      TextButton.icon(
                        onPressed: () async {
                          try {
                            // First, ensure the URL is properly formatted
                            final urlString = announcement['file_url'];
                            if (urlString == null || urlString.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('URL file tidak valid'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Create the URI and handle potential formatting issues
                            final Uri url = Uri.parse(urlString);
                            if (url == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Format URL tidak valid'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Check if the URL can be launched
                            if (await canLaunchUrl(url)) {
                              // Launch the URL with proper configuration
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                                webViewConfiguration:
                                    const WebViewConfiguration(
                                  enableJavaScript: true,
                                  enableDomStorage: true,
                                ),
                              );
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Tidak dapat membuka: $urlString'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              print(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.file_download, size: 18),
                        label: const Text('Unduh Materi'),
                      ),
                  ],
                ),
                trailing: announcement['has_task'] == true
                    ? const Icon(Icons.assignment, color: Colors.orange)
                    : announcement['has_attachment'] == true
                        ? const Icon(Icons.book, color: Colors.blue)
                        : null,
                onTap: announcement['has_task'] == true
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubmitTaskPage(
                                  taskTitle:
                                      announcement['material_title'] ?? '',
                                  taskDescription:
                                      announcement['description'] ?? '',
                                  deadline: announcement['deadline'] ?? " ",
                                )))
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresensiTab() {
    return ListView.builder(
      itemCount: attendances.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final meeting = attendances[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text('${index + 1}'),
            ),
            title: Text(meeting['attendance_date'] as String),
            subtitle: Text(meeting['class_title'] as String),
            trailing: meeting['attendance_status'] != null
                ? Chip(
                    label: Text(
                      meeting['attendance_status'] as String,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  )
                : ElevatedButton(
                    onPressed: () => ShowPresensiDialog(context),
                    child: const Text('Presensi'),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTugasTab() {
    return FutureBuilder(
      future: _matkulDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Filter announcements where has_task is true
        final tasks = announcements
            .where((announcement) => announcement['has_task'] == true)
            .toList();

        return ListView.builder(
          itemCount: tasks.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final task = tasks[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(
                  Icons.assignment,
                  color: Colors.orange,
                ),
                title: Text(
                  task['material_title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deadline: ${task['deadline'] ?? 'Not set'}'),
                    Text(task['description'] ?? ''),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubmitTaskPage(
                      taskTitle: task['material_title'] ?? '',
                      taskDescription: task['description'] ?? '',
                      deadline: task['deadline'] ?? " ",
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classDetails['title'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Semester ${classDetails['semester']} • ${classDetails['credits']} SKS',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pengumuman', icon: Icon(Icons.announcement)),
            Tab(text: 'Presensi', icon: Icon(Icons.how_to_reg)),
            Tab(text: 'Tugas', icon: Icon(Icons.assignment)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPengumumanTab(),
          _buildPresensiTab(),
          _buildTugasTab(),
        ],
      ),
    );
  }
}
