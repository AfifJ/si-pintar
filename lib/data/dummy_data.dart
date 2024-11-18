class DummyData {
  static const String announcements = '''

  [
      {
        "title": "UTS Minggu Depan",
        "date": "10 Oktober 2023", 
        "content": "UTS akan dilaksanakan minggu depan secara offline",
        "hasTask": false
      },
      {
        "title": "Tugas Kelompok",
        "date": "5 Oktober 2023",
        "content": "Kerjakan tugas kelompok implementasi Flutter", 
        "hasTask": true
      },
      {
        "title": "Materi Pertemuan 5",
        "date": "3 Oktober 2023",
        "content": "Materi tentang State Management di Flutter sudah dapat diakses di E-Learning",
        "hasTask": false,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/materi-state-management.pdf"
      },
      {
        "title": "Materi Widget & Layout", 
        "date": "28 September 2023",
        "content": "Slide dan contoh kode tentang Widget & Layout Flutter telah diunggah",
        "hasTask": false,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/flutter-widget-layout.pdf"
      }
    ]

  ''';

  static const String tasks = '''
 [
      {
        "title": "Tugas Kelompok Flutter",
        "deadline": "15 Oktober 2023",
        "status": "Belum dikumpulkan"
      },
      {
        "title": "Implementasi Widget",
        "deadline": "8 Oktober 2023",
        "status": "Sudah dikumpulkan"
      }
    ]

  ''';

  static const String meetings = '''
 [
      {"week": "Minggu 1", "date": "1 September 2023", "status": "Hadir"},
      {"week": "Minggu 2", "date": "2 September 2023", "status": "Hadir"},
      {"week": "Minggu 3", "date": "3 September 2023", "status": "Hadir"},
      {"week": "Minggu 4", "date": "4 September 2023", "status": "Hadir"},
      {"week": "Minggu 5", "date": "5 September 2023", "status": "Hadir"},
      {"week": "Minggu 6", "date": "6 September 2023", "status": null},
      {"week": "Minggu 7", "date": "7 September 2023", "status": null},
      {"week": "Minggu 8", "date": "8 September 2023", "status": null},
      {"week": "Minggu 9", "date": "9 September 2023", "status": null},
      {"week": "Minggu 10", "date": "10 September 2023", "status": null},
      {"week": "Minggu 11", "date": "11 September 2023", "status": null},
      {"week": "Minggu 12", "date": "12 September 2023", "status": null},
      {"week": "Minggu 13", "date": "13 September 2023", "status": null},
      {"week": "Minggu 14", "date": "14 September 2023", "status": null},
      {"week": "Minggu 15", "date": "15 September 2023", "status": null},
      {"week": "Minggu 16", "date": "16 September 2023", "status": null}
    ]

  ''';

  static String profile = '''
    {
      "user_id": "123456",
      "username": "afif_jamhari",
      "npm": "124220018",
      "password": "password123",
      "email": "afif@example.com",
      "full_name": "Afif Jamhari",
      "role": "mahasiswa",
      "semester": "5",
      "image_url": "https://imgs.search.brave.com/9lEhL1vTnoiJt1H8A_e-WI1QXcKV1iw4W_YLF65ZdC4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/ZnJlZS1wc2QvM2Qt/cmVuZGVyLWF2YXRh/ci1jaGFyYWN0ZXJf/MjMtMjE1MDYxMTc2/NS5qcGc_c2VtdD1h/aXNfaHlicmlk",
      "nim": "124220018", 
      "academic_year": "2023/2024"
    }
  ''';

  static const String classes = '''
    [
      {
        "title": "Pemrograman Mobile",
        "description": "Pembelajaran tentang pengembangan aplikasi mobile menggunakan Flutter dan React Native",
        "fileUrl": "https://elearning.com/mobile-dev.pdf",
        "date": "2023-10-10",
        "hasTask": true,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/mobile-attachment.pdf",
        "subtitle": "Mobile App Development",
        "semester": 5,
        "credits": 3,
        "lecturer": "Dr. John Doe",
        "room": "Lab Mobile 1",
        "classSection": "A",
        "schedule": {
          "day": "Senin",
          "time": "08:00-10:30"
        }
      },
      {
        "title": "Basis Data Lanjut",
        "description": "Mempelajari konsep advanced database, optimization, dan data warehousing",
        "fileUrl": "https://elearning.com/database.pdf",
        "date": "2023-10-10",
        "hasTask": false,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/db-attachment.pdf",
        "subtitle": "Advanced Database",
        "semester": 5,
        "credits": 3,
        "lecturer": "Prof. Jane Smith",
        "room": "Lab Database",
        "classSection": "B",
        "schedule": {
          "day": "Selasa",
          "time": "13:00-15:30"
        }
      },
      {
        "title": "Kecerdasan Buatan",
        "description": "Pengenalan konsep AI, machine learning, dan deep learning",
        "fileUrl": "https://elearning.com/ai.pdf",
        "date": "2023-10-10",
        "hasTask": true,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/ai-attachment.pdf",
        "subtitle": "Artificial Intelligence",
        "semester": 5,
        "credits": 3,
        "lecturer": "Dr. Alan Turing",
        "room": "Lab AI",
        "classSection": "A",
        "schedule": {
          "day": "Rabu",
          "time": "09:00-11:30"
        }
      },
      {
        "title": "Jaringan Komputer",
        "description": "Mempelajari konsep jaringan komputer, protokol, dan keamanan jaringan",
        "fileUrl": "https://elearning.com/network.pdf",
        "date": "2023-10-10",
        "hasTask": false,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/network-attachment.pdf",
        "subtitle": "Computer Networks",
        "semester": 5,
        "credits": 3,
        "lecturer": "Dr. Vint Cerf",
        "room": "Lab Networking",
        "classSection": "C",
        "schedule": {
          "day": "Kamis",
          "time": "10:00-12:30"
        }
      },
      {
        "title": "Pengembangan Web",
        "description": "Pembelajaran pengembangan aplikasi web modern dengan React dan Node.js",
        "fileUrl": "https://elearning.com/web.pdf",
        "date": "2023-10-10",
        "hasTask": true,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/web-attachment.pdf",
        "subtitle": "Web Development",
        "semester": 5,
        "credits": 3,
        "lecturer": "Prof. Tim Berners-Lee",
        "room": "Lab Internet",
        "classSection": "B",
        "schedule": {
          "day": "Selasa",
          "time": "08:00-10:30"
        }
      },
      {
        "title": "Sistem Terdistribusi",
        "description": "Mempelajari arsitektur dan implementasi sistem terdistribusi",
        "fileUrl": "https://elearning.com/distributed.pdf",
        "date": "2023-10-10",
        "hasTask": false,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/distributed-attachment.pdf",
        "subtitle": "Distributed Systems",
        "semester": 5,
        "credits": 3,
        "lecturer": "Dr. Leslie Lamport",
        "room": "Lab Distributed",
        "classSection": "A",
        "schedule": {
          "day": "Jumat",
          "time": "13:00-15:30"
        }
      },
      {
        "title": "Keamanan Informasi",
        "description": "Pembelajaran tentang keamanan informasi dan kriptografi",
        "fileUrl": "https://elearning.com/security.pdf",
        "date": "2023-10-10",
        "hasTask": true,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/security-attachment.pdf",
        "subtitle": "Information Security",
        "semester": 5,
        "credits": 3,
        "lecturer": "Prof. Bruce Schneier",
        "room": "Lab Security",
        "classSection": "A",
        "schedule": {
          "day": "Rabu",
          "time": "13:00-15:30"
        }
      },
      {
        "title": "Cloud Computing",
        "description": "Pengenalan teknologi cloud computing dan implementasinya",
        "fileUrl": "https://elearning.com/cloud.pdf",
        "date": "2023-10-10",
        "hasTask": false,
        "hasAttachment": true,
        "attachmentUrl": "https://elearning.com/cloud-attachment.pdf",
        "subtitle": "Cloud Technologies",
        "semester": 5,
        "credits": 3,
        "lecturer": "Dr. Werner Vogels",
        "room": "Lab Cloud",
        "classSection": "D",
        "schedule": {
          "day": "Kamis",
          "time": "13:00-15:30"
        }
      }
    ]
  ''';
}
