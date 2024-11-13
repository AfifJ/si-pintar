import 'package:flutter/material.dart';
import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/screen/matkul/submit_task_page.dart';

class MatkulPage extends StatefulWidget {
  const MatkulPage({super.key});

  @override
  State<MatkulPage> createState() => _MatkulPageState();
}

class _MatkulPageState extends State<MatkulPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final announcements = DummyData.announcements;
  final tasks = DummyData.tasks;
  final meetings = DummyData.meetings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _showPresensiDialog(BuildContext context) {
    String? selectedStatus;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Presensi'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text('Hadir'),
                    value: 'Hadir',
                    groupValue: selectedStatus,
                    onChanged: (value) =>
                        setState(() => selectedStatus = value),
                  ),
                  RadioListTile<String>(
                    title: Text('Izin'),
                    value: 'Izin',
                    groupValue: selectedStatus,
                    onChanged: (value) =>
                        setState(() => selectedStatus = value),
                  ),
                  RadioListTile<String>(
                    title: Text('Sakit'),
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
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (selectedStatus != null) {
                  // TODO: Handle presensi submission
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPengumumanTab() {
    return ListView.builder(
      itemCount: announcements.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              announcements[index]['title'] as String,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(announcements[index]['date'] as String),
                Text(announcements[index]['content'] as String),
                if (announcements[index]['hasAttachment'] == true)
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Handle download or view attachment
                    },
                    icon: Icon(Icons.file_download, size: 18),
                    label: Text('Unduh Materi'),
                  ),
              ],
            ),
            trailing: announcements[index]['hasTask'] == true
                ? Icon(Icons.assignment, color: Colors.orange)
                : announcements[index]['hasAttachment'] == true
                    ? Icon(Icons.book, color: Colors.blue)
                    : null,
            onTap: announcements[index]['hasTask'] == true
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubmitTaskPage(
                              taskTitle:
                                  announcements[index]['title'] as String,
                              taskDescription: announcements[index]['content'],
                              deadline: announcements[index]['deadline'] ?? " ",
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
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text('${index + 1}'),
            ),
            title: Text(meetings[index]['week']!),
            subtitle: Text(meetings[index]['date']!),
            trailing: meetings[index]['status'] != null
                ? Chip(
                    label: Text(
                      meetings[index]['status']!,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  )
                : ElevatedButton(
                    onPressed: () => _showPresensiDialog(context),
                    child: Text('Presensi'),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTugasTab() {
    return ListView.builder(
      itemCount: tasks.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final bool isSubmitted = tasks[index]['status'] == 'Sudah dikumpulkan';
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              isSubmitted ? Icons.check_circle : Icons.assignment,
              color: isSubmitted ? Colors.green : Colors.orange,
            ),
            title: Text(
              tasks[index]['title']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deadline: ${tasks[index]['deadline']}'),
                Text(
                  tasks[index]['status']!,
                  style: TextStyle(
                    color: isSubmitted ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            trailing: !isSubmitted
                ? ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubmitTaskPage(
                          taskTitle: tasks[index]['title']!,
                          taskDescription:
                              'Implementasikan sebuah aplikasi Flutter sederhana dengan menggunakan widget-widget dasar. Aplikasi harus memiliki minimal 3 halaman dan menggunakan state management.', // Tambahkan deskripsi tugas di dummy_data
                          deadline: tasks[index]['deadline']!,
                        ),
                      ),
                    ),
                    child: Text('Submit'),
                  )
                : null,
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
              "Pemrograman Mobile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "3 SKS • Semester 5",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
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
