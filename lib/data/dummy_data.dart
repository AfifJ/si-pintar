import 'package:flutter/material.dart';
import 'package:si_pintar/models/activity.dart';
import 'package:si_pintar/models/course.dart';

class DummyData {
  static List<Map<String, dynamic>> announcements = [
    {
      'title': 'UTS Minggu Depan',
      'date': '10 Oktober 2023',
      'content': 'UTS akan dilaksanakan minggu depan secara offline',
      'hasTask': false
    },
    {
      'title': 'Tugas Kelompok',
      'date': '5 Oktober 2023',
      'content': 'Kerjakan tugas kelompok implementasi Flutter',
      'hasTask': true
    },
    {
      'title': 'Materi Pertemuan 5',
      'date': '3 Oktober 2023',
      'content':
          'Materi tentang State Management di Flutter sudah dapat diakses di E-Learning',
      'hasTask': false,
      'hasAttachment': true,
      'attachmentUrl': 'https://elearning.com/materi-state-management.pdf'
    },
    {
      'title': 'Materi Widget & Layout',
      'date': '28 September 2023',
      'content':
          'Slide dan contoh kode tentang Widget & Layout Flutter telah diunggah',
      'hasTask': false,
      'hasAttachment': true,
      'attachmentUrl': 'https://elearning.com/flutter-widget-layout.pdf'
    }
  ];

  static List<Map<String, dynamic>> tasks = [
    {
      'title': 'Tugas Kelompok Flutter',
      'deadline': '15 Oktober 2023',
      'status': 'Belum dikumpulkan'
    },
    {
      'title': 'Implementasi Widget',
      'deadline': '8 Oktober 2023',
      'status': 'Sudah dikumpulkan'
    }
  ];
  static List<Map<String, dynamic>> meetings = List.generate(
      16,
      (index) => {
            'week': 'Minggu ${index + 1}',
            'date': '${index + 1} September 2023',
            'status': index < 5 ? 'Hadir' : null
          });

  static Map<String, String> profile = {
    'imageUrl':
        'https://imgs.search.brave.com/9lEhL1vTnoiJt1H8A_e-WI1QXcKV1iw4W_YLF65ZdC4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/ZnJlZS1wc2QvM2Qt/cmVuZGVyLWF2YXRh/ci1jaGFyYWN0ZXJf/MjMtMjE1MDYxMTc2/NS5qcGc_c2VtdD1h/aXNfaHlicmlk',
    'fullName': "Afif Jamhari",
    'nim': "124220018",
    'semester': "5",
    'academicYear': "2023/2024",
  };

  static List<Course> courses = [
    Course(
      title: 'Pemrograman Mobile',
      subtitle: 'Mobile App Development',
      semester: 5,
      credits: 3,
      lecturer: 'Dr. John Doe',
      description:
          'Pembelajaran tentang pengembangan aplikasi mobile menggunakan Flutter dan React Native',
      room: 'Lab Mobile 1',
      classSection: 'A',
      schedule: {'day': 'Senin', 'time': '08:00-10:30'},
    ),
    Course(
      title: 'Basis Data Lanjut',
      subtitle: 'Advanced Database',
      semester: 5,
      credits: 3,
      lecturer: 'Prof. Jane Smith',
      description:
          'Mempelajari konsep advanced database, optimization, dan data warehousing',
      room: 'Lab Database',
      classSection: 'B',
      schedule: {'day': 'Selasa', 'time': '13:00-15:30'},
    ),
    Course(
      title: 'Kecerdasan Buatan',
      subtitle: 'Artificial Intelligence',
      semester: 5,
      credits: 3,
      lecturer: 'Dr. Alan Turing',
      description: 'Pengenalan konsep AI, machine learning, dan deep learning',
      room: 'Lab AI',
      classSection: 'A',
      schedule: {'day': 'Rabu', 'time': '09:00-11:30'},
    ),
    Course(
      title: 'Jaringan Komputer',
      subtitle: 'Computer Networks',
      semester: 5,
      credits: 3,
      lecturer: 'Dr. Vint Cerf',
      description:
          'Mempelajari konsep jaringan komputer, protokol, dan keamanan jaringan',
      room: 'Lab Networking',
      classSection: 'C',
      schedule: {'day': 'Kamis', 'time': '10:00-12:30'},
    ),
    Course(
      title: 'Pengembangan Web',
      subtitle: 'Web Development',
      semester: 5,
      credits: 3,
      lecturer: 'Prof. Tim Berners-Lee',
      description:
          'Pembelajaran pengembangan aplikasi web modern dengan React dan Node.js',
      room: 'Lab Internet',
      classSection: 'B',
      schedule: {'day': 'Selasa', 'time': '08:00-10:30'},
    ),
    Course(
      title: 'Sistem Terdistribusi',
      subtitle: 'Distributed Systems',
      semester: 5,
      credits: 3,
      lecturer: 'Dr. Leslie Lamport',
      description:
          'Mempelajari arsitektur dan implementasi sistem terdistribusi',
      room: 'Lab Distributed',
      classSection: 'A',
      schedule: {'day': 'Jumat', 'time': '13:00-15:30'},
    ),
    Course(
      title: 'Keamanan Informasi',
      subtitle: 'Information Security',
      semester: 5,
      credits: 3,
      lecturer: 'Prof. Bruce Schneier',
      description: 'Pembelajaran tentang keamanan informasi dan kriptografi',
      room: 'Lab Security',
      classSection: 'A',
      schedule: {'day': 'Rabu', 'time': '13:00-15:30'},
    ),
    Course(
      title: 'Cloud Computing',
      subtitle: 'Cloud Technologies',
      semester: 5,
      credits: 3,
      lecturer: 'Dr. Werner Vogels',
      description: 'Pengenalan teknologi cloud computing dan implementasinya',
      room: 'Lab Cloud',
      classSection: 'D',
      schedule: {'day': 'Kamis', 'time': '13:00-15:30'},
    ),
    // ... tambahkan course lainnya
  ];

  static List<Activity> activities = [
    Activity(
      title: 'Kuliah',
      subtitle: 'Mobile Development',
      color: Colors.blue.shade700,
      route: '/lecture',
      type: ActivityType.lecture,
      dateTime: DateTime.now().add(const Duration(days: 1)),
    ),
    Activity(
      title: 'UTS',
      subtitle: 'Basis Data Lanjut',
      color: Colors.red.shade700,
      route: '/exam',
      type: ActivityType.exam,
      dateTime: DateTime.now().add(const Duration(days: 2)),
    ),
    Activity(
      title: 'Project',
      subtitle: 'AI Implementation',
      color: Colors.green.shade700,
      route: '/project',
      type: ActivityType.project,
      dateTime: DateTime.now().add(const Duration(days: 3)),
    ),
    // ... tambahkan activity lainnya
  ];
}
