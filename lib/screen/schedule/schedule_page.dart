import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key});

  final List<Map<String, dynamic>> jadwalKuliah = [
    {
      'matkul': 'Pemrograman Mobile',
      'sks': 3,
      'kelas': 'A',
      'jadwal': {'hari': 'Senin', 'jam': '08:00-10:30'},
      'ruang': 'Lab Mobile 1',
      'dosen': 'Dr. John Doe'
    },
    {
      'matkul': 'Basis Data',
      'sks': 4,
      'kelas': 'B',
      'jadwal': {'hari': 'Selasa', 'jam': '13:00-15:30'},
      'ruang': 'Lab Database',
      'dosen': 'Prof. Jane Smith'
    },
    {
      'matkul': 'Algoritma dan Struktur Data',
      'sks': 4,
      'kelas': 'A',
      'jadwal': {'hari': 'Rabu', 'jam': '09:00-11:30'},
      'ruang': 'Lab Komputer 2',
      'dosen': 'Dr. Alice Johnson'
    },
    {
      'matkul': 'Jaringan Komputer',
      'sks': 3,
      'kelas': 'C',
      'jadwal': {'hari': 'Kamis', 'jam': '10:00-12:30'},
      'ruang': 'Lab Networking',
      'dosen': 'Prof. Bob Wilson'
    },
    {
      'matkul': 'Sistem Operasi',
      'sks': 3,
      'kelas': 'B',
      'jadwal': {'hari': 'Jumat', 'jam': '13:00-15:30'},
      'ruang': 'Lab OS',
      'dosen': 'Dr. Carol Brown'
    },
    {
      'matkul': 'Kecerdasan Buatan',
      'sks': 4,
      'kelas': 'A',
      'jadwal': {'hari': 'Senin', 'jam': '13:00-15:30'},
      'ruang': 'Lab AI',
      'dosen': 'Prof. David Lee'
    },
    {
      'matkul': 'Pemrograman Web',
      'sks': 3,
      'kelas': 'B',
      'jadwal': {'hari': 'Selasa', 'jam': '08:00-10:30'},
      'ruang': 'Lab Internet',
      'dosen': 'Dr. Eva Green'
    },
    {
      'matkul': 'Keamanan Sistem',
      'sks': 3,
      'kelas': 'A',
      'jadwal': {'hari': 'Rabu', 'jam': '13:00-15:30'},
      'ruang': 'Lab Security',
      'dosen': 'Prof. Frank White'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            ...['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'].map((hari) {
              final jadwalHari = jadwalKuliah
                  .where((jadwal) => jadwal['jadwal']['hari'] == hari)
                  .toList();

              if (jadwalHari.isEmpty) return Container();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      hari,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...jadwalHari.map((jadwal) => Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            jadwal['matkul'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${jadwal['jadwal']['jam']}'),
                              Text('Ruang: ${jadwal['ruang']}'),
                              Text('Dosen: ${jadwal['dosen']}'),
                              Text('SKS: ${jadwal['sks']}'),
                            ],
                          ),
                        ),
                      )),
                ],
              );
            }),
          ],
        ));
  }
}
