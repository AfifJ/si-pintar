import 'package:flutter/material.dart';

class MatkulPage extends StatelessWidget {
  const MatkulPage({super.key});

  @override
  Widget build(BuildContext context) {
    void _showTaskSubmissionDialog(BuildContext context) {
      final _formKey = GlobalKey<FormState>();
      String? description;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submit Tugas'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => description = value,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // TODO: Handle submission with description
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

    final List<String> weeks =
        List.generate(16, (index) => "Minggu ${index + 1}");
    final List<String> tasks =
        List.generate(16, (index) => "Tugas ${index + 1}");

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text(
              "Judul Matakuliah",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement presensi logic
                _showPresensiDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  'Presensi',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: weeks.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          child: Text(
                            weeks[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24, top: 12, bottom: 12),
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
                            SizedBox(height: 12),
                            MaterialButton(
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                _showTaskSubmissionDialog(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  'Submit Tugas',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
