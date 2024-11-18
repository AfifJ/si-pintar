import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
// import 'package:provider/provider.dart';
import 'package:si_pintar/providers/matkul_provider.dart';
import 'package:si_pintar/screen/matkul/presensi_dialog.dart';
import 'package:si_pintar/screen/matkul/submit_task_page.dart';
import 'package:si_pintar/services/remote/class_service.dart';

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
  late final List<Map<String, dynamic>> meetings;
  late final List<Map<String, dynamic>> tasks;
  final ClassService _classService = ClassService();

  @override
  void initState() {
    super.initState();
    final meetingsJson = jsonDecode(DummyData.meetings);
    meetings = (meetingsJson as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final tasksJson = jsonDecode(DummyData.tasks);
    tasks = (tasksJson as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    _tabController = TabController(length: 3, vsync: this);
    _matkulDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      final announcementsData =
          await _classService.getClassAnnouncements(widget.courseId);
      setState(() {
        announcements = [announcementsData];
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
                        onPressed: () {
                          // TODO: Handle download using announcement['attachment_url']
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
      itemCount: meetings.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text('${index + 1}'),
            ),
            title: Text(meeting['week'] as String),
            subtitle: Text(meeting['date'] as String),
            trailing: meeting['status'] != null
                ? Chip(
                    label: Text(
                      meeting['status'] as String,
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
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final bool isSubmitted = task['status'] == 'Sudah dikumpulkan';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              isSubmitted ? Icons.check_circle : Icons.assignment,
              color: isSubmitted ? Colors.green : Colors.orange,
            ),
            title: Text(
              task['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deadline: ${task['deadline']}'),
                Text(
                  task['status'] as String,
                  style: TextStyle(
                    color: isSubmitted ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
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
              widget.courseId + "halo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Semester 5 • 3 SKS',
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
