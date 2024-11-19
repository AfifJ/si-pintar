import 'package:flutter/material.dart';
import 'package:si_pintar/services/remote/schedule_service.dart';
import 'package:si_pintar/services/session_manager.dart';
import 'package:si_pintar/services/database_service.dart';

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = false;
  double _ipk = 0.0;
  int _totalSks = 0;
  List<Map<String, dynamic>> _mataKuliah = [];
  final ScheduleService _scheduleService = ScheduleService();

  void _calculateIPK() {
    if (_mataKuliah.isEmpty) {
      setState(() {
        _ipk = 0.0;
        _totalSks = 0;
      });
      return;
    }

    double totalNilai = 0;
    int totalSks = 0;

    for (var mk in _mataKuliah) {
      totalNilai += (mk['nilai_angka'] as double) * (mk['sks'] as int);
      totalSks += mk['sks'] as int;
    }

    setState(() {
      _ipk = totalNilai / totalSks;
      _totalSks = totalSks;
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final storedMataKuliah = await _dbService.getAllMataKuliah();
      if (storedMataKuliah.isNotEmpty) {
        setState(() {
          _mataKuliah = storedMataKuliah;
          _calculateIPK();
        });
      } else {
        await _loadScheduledCourses();
      }
    } catch (e) {
      print('Error loading data: $e');
      _addMataKuliah();
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addMataKuliah() async {
    final newMataKuliah = {
      'nama': '',
      'sks': 2,
      'nilai_huruf': 'A',
      'nilai_angka': 4.0,
    };

    final id = await _dbService.insertMataKuliah(newMataKuliah);
    newMataKuliah['id'] = id;

    setState(() {
      _mataKuliah.add(newMataKuliah);
    });
  }

  Future<void> _updateMataKuliah(int index) async {
    if (_mataKuliah[index]['id'] != null) {
      await _dbService.updateMataKuliah(_mataKuliah[index]);
    }
  }

  Future<void> _removeMataKuliah(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Konfirmasi Hapus',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Apakah Anda yakin ingin menghapus ${_mataKuliah[index]['nama'].isEmpty ? "mata kuliah ini" : _mataKuliah[index]['nama']}?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_mataKuliah[index]['id'] != null) {
                            await _dbService
                                .deleteMataKuliah(_mataKuliah[index]['id']);
                          }
                          setState(() {
                            _mataKuliah.removeAt(index);
                            _calculateIPK();
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Hapus',
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
        );
      },
    );
  }

  Future<void> _loadScheduledCourses() async {
    try {
      final userId = await SessionManager.getCurrentUserId();
      if (userId != null) {
        final scheduleData = await _scheduleService.getSchedule(userId);

        await _dbService.deleteAllMataKuliah();

        for (var course in scheduleData) {
          final mataKuliah = {
            'nama': course['title'] ?? '',
            'sks': int.parse(course['credits']?.toString() ?? '2'),
            'nilai_huruf': 'A',
            'nilai_angka': 4.0,
          };
          final id = await _dbService.insertMataKuliah(mataKuliah);
          mataKuliah['id'] = id;
          _mataKuliah.add(mataKuliah);
        }

        setState(() {
          _calculateIPK();
        });
      }
    } catch (e) {
      print('Error loading scheduled courses: $e');
      _addMataKuliah();
    }
  }

  Future<void> _handleRefresh() async {
    await _loadData();
    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    // _initializeDatabase();
    _loadData();
  }

  Future<void> _showImportDialog() async {
    try {
      final userId = await SessionManager.getCurrentUserId();
      if (userId == null) return;

      final scheduleData = await _scheduleService.getSchedule(userId);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxHeight: 600),
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
                      Icons.add_circle_rounded,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Mata Kuliah',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: scheduleData.length,
                      itemBuilder: (context, index) {
                        final course = scheduleData[index];
                        final title = course['title'] ?? '';
                        final credits = course['credits']?.toString() ?? '2';

                        // Check if course already exists
                        final isDuplicate = _mataKuliah.any((mk) =>
                            mk['nama'].toString().toLowerCase() ==
                            title.toLowerCase());

                        return ListTile(
                          title: Text(title),
                          subtitle: Text('SKS: $credits'),
                          enabled: !isDuplicate,
                          tileColor: isDuplicate ? Colors.grey.shade200 : null,
                          trailing: isDuplicate
                              ? const Icon(Icons.check_circle,
                                  color: Colors.grey)
                              : const Icon(Icons.add_circle_outline,
                                  color: Colors.blue),
                          onTap: isDuplicate
                              ? null
                              : () async {
                                  final mataKuliah = {
                                    'nama': title,
                                    'sks': int.parse(credits),
                                    'nilai_huruf': 'A',
                                    'nilai_angka': 4.0,
                                  };

                                  final id = await _dbService
                                      .insertMataKuliah(mataKuliah);
                                  mataKuliah['id'] = id;

                                  setState(() {
                                    _mataKuliah.add(mataKuliah);
                                    _calculateIPK();
                                  });

                                  Navigator.of(context).pop();
                                },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
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
            ),
          );
        },
      );
    } catch (e) {
      print('Error showing import dialog: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulasi IPK'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: _showImportDialog,
              icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
              label: const Text(
                'Import',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi IPK",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        "IPK",
                        _ipk.toStringAsFixed(2),
                        Icons.grade,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        "Total SKS",
                        _totalSks.toString(),
                        Icons.book,
                        Colors.green,
                      ),
                      const SizedBox(height: 24),

                      // Daftar Mata Kuliah
                      ListView.builder(
                        key: ValueKey(_mataKuliah.length),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _mataKuliah.length,
                        itemBuilder: (context, index) {
                          return _buildMataKuliahCard(index);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Tombol Tambah Mata Kuliah
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addMataKuliah,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Tambah Mata Kuliah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color color) {
    return Container(
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMataKuliahCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Mata Kuliah ${index + 1}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red.shade400,
                  onPressed: () {
                    final currentIndex = index;
                    _removeMataKuliah(currentIndex);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Course name input
            TextFormField(
              initialValue: _mataKuliah[index]['nama'],
              onChanged: (value) {
                setState(() {
                  _mataKuliah[index]['nama'] = value;
                  _updateMataKuliah(index);
                });
              },
            ),
            const SizedBox(height: 16),

            // SKS and Grade inputs
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'SKS',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      prefixIcon: const Icon(Icons.credit_card),
                    ),
                    value: _mataKuliah[index]['sks'],
                    items: [1, 2, 3, 4].map((sks) {
                      return DropdownMenuItem(
                        value: sks,
                        child: Text(sks.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _mataKuliah[index]['sks'] = value!;
                        _calculateIPK();
                        _updateMataKuliah(index);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Nilai',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      prefixIcon: const Icon(Icons.grade),
                    ),
                    value: _mataKuliah[index]['nilai_huruf'],
                    items: ['A', 'B', 'C', 'D', 'E'].map((nilai) {
                      return DropdownMenuItem(
                        value: nilai,
                        child: Text(
                          nilai,
                          style: TextStyle(
                            color: _getNilaiColor(nilai),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _mataKuliah[index]['nilai_huruf'] = value!;
                        _mataKuliah[index]['nilai_angka'] =
                            _getNilaiAngka(value);
                        _calculateIPK();
                        _updateMataKuliah(index);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getNilaiAngka(String nilaiHuruf) {
    switch (nilaiHuruf) {
      case 'A':
        return 4.0;
      case 'B':
        return 3.0;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      case 'E':
        return 0.0;
      default:
        return 0.0;
    }
  }

  Color _getNilaiColor(String nilai) {
    switch (nilai) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      case 'E':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
