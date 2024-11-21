import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:si_pintar/data/dummy_data.dart';
import 'package:si_pintar/models/class_model.dart';
import 'package:si_pintar/screen/matkul/matkul_page.dart';
import 'package:si_pintar/services/remote/schedule_service.dart';
import 'package:si_pintar/services/remote/user_service.dart';
import 'package:si_pintar/services/session_manager.dart';
import 'package:si_pintar/services/conversion/convert_time.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadUserId();
      }
    });
  }

  Future<void> _loadUserId() async {
    if (!mounted) return;

    try {
      final localUserId = await SessionManager.getCurrentUserId();
      if (!mounted) return;

      if (localUserId != null) {
        setState(() {
          userId = localUserId;
        });
        await _loadSchedule();
        await _loadUserData();
      }
    } catch (e) {
      print('Error loading user ID: $e');
    }
  }

  // final List<ClassModel> jadwalKuliah = (jsonDecode(DummyData.classes) as List)
  //     .map((item) => ClassModel.fromJson(item))
  //     .toList();

  final ScheduleService _scheduleService = ScheduleService();
  final UserService _userService = UserService();
  Map<String, dynamic>? _user;
  String? userId;

  // Add state variable for current timezone
  String currentTimezone = 'WIB';

  // Update timezone mapping to include cities
  final Map<String, String> timezones = {
    'Tokyo (JST)': 'JST',
    'Seoul (KST)': 'KST',
    'Beijing (CST)': 'CST',
    'New Delhi (IST)': 'IST',
    'Moscow (MSK)': 'MSK',
    'Paris (CET)': 'CET',
    'London (GMT)': 'GMT',
    'London (BST)': 'BST',
    'New York (EDT)': 'EDT',
    'Chicago (CDT)': 'CDT',
    'Denver (MDT)': 'MDT',
    'Los Angeles (PDT)': 'PDT',
    'Jakarta (WIB)': 'WIB',
    'Makassar (WITA)': 'WITA',
    'Jayapura (WIT)': 'WIT',
  };

  // Add converted schedule variable
  List<Map<String, dynamic>> _convertedSchedule = [];

  // Add loading state
  bool _isLoading = true;

  List<Map<String, dynamic>> jadwalKuliah = [];

  Future<void> _loadSchedule() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final scheduleData = await _scheduleService.getSchedule(userId!);
      if (!mounted) return;

      setState(() {
        jadwalKuliah = scheduleData;
        _convertedSchedule = scheduleData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // Handle error appropriately
    }
  }

  // Add method to convert schedule times
  Future<void> _convertScheduleTimes(String targetTimezone) async {
    if (!mounted) return;

    List<Map<String, dynamic>> newSchedule = [];

    try {
      for (var jadwal in jadwalKuliah) {
        if (!mounted) return; // Check mounted status in loop

        var newJadwal = Map<String, dynamic>.from(jadwal);
        List<String> timeRange = jadwal['schedule_time'].split('-');
        String startTime = timeRange[0].trim();
        String endTime = timeRange[1].trim();

        String convertedStartTime = convertTimeManual(
          startTime,
          'WIB',
          targetTimezone,
        );
        String convertedEndTime = convertTimeManual(
          endTime,
          'WIB',
          targetTimezone,
        );

        newJadwal['schedule_time'] =
            '${convertedStartTime.split(' (')[0]}-${convertedEndTime.split(' (')[0]}';
        newSchedule.add(newJadwal);
      }

      if (!mounted) return;
      setState(() {
        _convertedSchedule = newSchedule;
      });
    } catch (e) {
      if (!mounted) return;
      // Handle error appropriately
    }
  }

  Color _getRandomColor() {
    final List<Color> colors = [
      Colors.blue.shade50,
      Colors.green.shade50,
      Colors.orange.shade50,
      Colors.purple.shade50,
      Colors.pink.shade50,
      Colors.teal.shade50,
    ];
    return colors[DateTime.now().microsecond % colors.length];
  }

  // Update the mapping for the new JSON structure
  final dayMapping = {
    'Monday': 'Senin',
    'Tuesday': 'Selasa',
    'Wednesday': 'Rabu',
    'Thursday': 'Kamis',
    'Friday': 'Jumat'
  };

  // Update the schedule item rendering
  Widget _buildScheduleItem(Map<String, dynamic> jadwal) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatkulPage(courseId: jadwal['class_id']),
          ),
        );
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.calendar_today,
          color: Colors.blue.shade700,
        ),
      ),
      title: Text(
        jadwal['title'],
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${jadwal['schedule_time']} $currentTimezone"),
          Text("${jadwal['room']} • ${jadwal['lecturer_name']}"),
          Text("Kelas ${jadwal['class_section']} • ${jadwal['credits']} SKS"),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      isThreeLine: true,
    );
  }

  // Add skeleton widget
  Widget _buildSkeletonItem() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        width: 40,
        height: 40,
      ),
      title: Container(
        height: 20,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Container(
            height: 16,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 16,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    try {
      final userData = await _userService.getUserFromSession(userId!);
      if (!mounted) return;

      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Update the build method's body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _user?['full_name'] ?? '-',
              // "Jurusan Sistem Informasi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "Semester ${_user?['semester'] ?? '-'} • ${_user?['academic_year'] ?? '-'}",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _showTimeConversionDialog,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Konversi Waktu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '($currentTimezone)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  ...['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'].map((day) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 24,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        ...List.generate(2, (index) => _buildSkeletonItem()),
                      ],
                    );
                  }),
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  ...['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'].map((day) {
                    final englishDay = dayMapping.entries
                        .firstWhere((entry) => entry.value == day)
                        .key;
                    final jadwalDay =
                        _convertedSchedule // Use converted schedule instead
                            .where((jadwal) => jadwal['day'] == englishDay)
                            .toList();

                    if (jadwalDay.isEmpty) return Container();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            // color: Colors.b,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...jadwalDay
                            .map((jadwal) => _buildScheduleItem(jadwal)),
                      ],
                    );
                  }),
                ],
              ),
            ),
    );
  }

  void _showTimeConversionDialog() {
    String targetTimezone = timezones.keys.first;
    String currentTimezoneName = timezones.entries
        .firstWhere((entry) => entry.value == currentTimezone)
        .key;

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Colors.blue,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Konversi Waktu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Dari: $currentTimezoneName',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: targetTimezone,
                decoration: InputDecoration(
                  labelText: 'Ke Zona Waktu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: timezones.keys.map((String timezone) {
                  return DropdownMenuItem<String>(
                    value: timezone,
                    child: Text(timezone),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    targetTimezone = value;
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await _convertScheduleTimes(
                              timezones[targetTimezone]!);
                          setState(() {
                            currentTimezone = timezones[targetTimezone]!;
                          });
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Gagal mengkonversi waktu: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Konversi',
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
      ),
    );
  }
}
