import 'package:flutter/material.dart';

void ShowPresensiDialog(BuildContext context) {
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
                  onChanged: (value) => setState(() => selectedStatus = value),
                ),
                RadioListTile<String>(
                  title: const Text('Izin'),
                  value: 'Izin',
                  groupValue: selectedStatus,
                  onChanged: (value) => setState(() => selectedStatus = value),
                ),
                RadioListTile<String>(
                  title: const Text('Sakit'),
                  value: 'Sakit',
                  groupValue: selectedStatus,
                  onChanged: (value) => setState(() => selectedStatus = value),
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
                    const SnackBar(content: Text('Presensi berhasil disubmit')),
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
