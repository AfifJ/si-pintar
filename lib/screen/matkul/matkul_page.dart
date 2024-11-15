import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
// import 'package:provider/provider.dart';
import 'package:si_pintar/providers/matkul_provider.dart';
import 'package:si_pintar/screen/matkul/submit_task_page.dart';

class MatkulPage extends StatefulWidget {
  const MatkulPage({super.key});

  @override
  State<MatkulPage> createState() => _MatkulPageState();
}

class _MatkulPageState extends State<MatkulPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<void> _matkulDataFuture;
  late final List<Map<String, dynamic>> announcements;
  late final List<Map<String, dynamic>> meetings;
  late final List<Map<String, dynamic>> tasks;

  @override
  void initState() {
    super.initState();
    final announcementsJson = jsonDecode(DummyData.announcements);
    announcements = (announcementsJson as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

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
    // // Wrap in try-catch to handle potential initialization errors
    // try {
    //   // await context.read<MatkulProvider>().loadMatkulData();
    // } catch (e) {
    //   // Handle or rethrow error as needed
    //   rethrow;
    // }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPresensiDialog(BuildContext context) {
    String? selectedStatus;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Presensi'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Hadir'),
                    value: 'Hadir',
                    groupValue: selectedStatus,
                    onChanged: (value) =>
                        setState(() => selectedStatus = value),
                  ),
                  RadioListTile<String>(
                    title: const Text('Izin'),
                    value: 'Izin',
                    groupValue: selectedStatus,
                    onChanged: (value) =>
                        setState(() => selectedStatus = value),
                  ),
                  RadioListTile<String>(
                    title: const Text('Sakit'),
                    value: 'Sakit',
                    groupValue: selectedStatus,
                    onChanged: (value) =>
                        setState(() => selectedStatus = value),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedStatus != null) {
                  try {
                    // await context
                    //     .read<MatkulProvider>()
                    //     .submitPresensi(selectedStatus!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Presensi berhasil disubmit')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPengumumanTab() {
    return ListView.builder(
      itemCount: announcements.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              announcement['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(announcement['date']),
                Text(announcement['content']),
                if (announcement['hasAttachment'] == true)
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Handle download or view attachment
                    },
                    icon: const Icon(Icons.file_download, size: 18),
                    label: const Text('Unduh Materi'),
                  ),
              ],
            ),
            trailing: announcement['hasTask'] == true
                ? const Icon(Icons.assignment, color: Colors.orange)
                : announcement['hasAttachment'] == true
                    ? const Icon(Icons.book, color: Colors.blue)
                    : null,
            onTap: announcement['hasTask'] == true
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubmitTaskPage(
                              taskTitle: announcement['title'],
                              taskDescription: announcement['content'],
                              deadline: announcement['deadline'] ?? " ",
                            )))
                : null,
          ),
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
                    onPressed: () => _showPresensiDialog(context),
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pemrograman Mobile',
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
