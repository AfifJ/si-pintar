import 'package:flutter/material.dart';
import 'package:si_pintar/services/conversion/convert_currency.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UktPage extends StatefulWidget {
  const UktPage({super.key});

  @override
  State<UktPage> createState() => _UktPageState();
}

class _UktPageState extends State<UktPage> {
  bool _isLoading = false;
  String? _error;

  // Tambahkan variabel untuk menyimpan mata uang yang dipilih
  String _selectedCurrency = 'IDR';
  String _currentCurrency = '0';
  String _baseCurrency = '7500000';

  // Add this map
  final List<String> _exchangeRates = ['IDR', 'USD', 'EUR', 'SGD', 'MYR'];

  // Add this field
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Update to use async conversion
  Future<void> _convertCurrency(double amount) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String convertedAmount = await convertCurrency(
        amount.toString(),
        'IDR',
        _selectedCurrency,
      );

      convertedAmount = convertedAmount.replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');

      String symbol = _getCurrencySymbol(_selectedCurrency);
      String result = '$symbol $convertedAmount';
      setState(() {
        _currentCurrency = result;
        _isLoading = false;
      });
    } catch (e) {
      print('Error converting currency');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'SGD':
        return 'S\$';
      case 'MYR':
        return 'RM';
      default:
        return 'Rp';
    }
  }

  // Add this method to initialize notifications
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Add this method to show notification
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'payment_channel', // channel id
      'Payment Notifications', // channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      'Pembayaran UKT Berhasil', // notification title
      'Terima kasih telah melakukan pembayaran UKT sebesar $_currentCurrency', // notification body
      platformChannelSpecifics,
    );
  }

  void _showPaymentSuccessDialog() {
    _showNotification(); // Add this line to show notification
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pembayaran Berhasil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pembayaran UKT sebesar $_currentCurrency telah berhasil',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Terima kasih telah melakukan pembayaran UKT tepat waktu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan cek email Anda untuk bukti pembayaran.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'OK',
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
  }

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _convertCurrency(double.parse(_baseCurrency));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran UKT'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh logic
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with gradient background
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informasi Pembayaran",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      "Total UKT",
                      _currentCurrency,
                      Icons.payment,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      "Status",
                      "Belum Dibayar",
                      Icons.info_outline,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      "Batas Pembayaran",
                      "31 Januari 2024",
                      Icons.calendar_today,
                      Colors.red,
                    ),
                    const SizedBox(height: 24),

                    // Tambahkan pilihan mata uang
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _exchangeRates.map((currency) {
                          return ChoiceChip(
                            label: Text(currency),
                            selected: _selectedCurrency == currency,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCurrency = currency;
                                print("===============selected currency");
                                print(_selectedCurrency);
                                _convertCurrency(double.parse(_baseCurrency));
                                print("===============current currency");
                                print(_currentCurrency);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Payment Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null // This will disable the button when loading
                            : () {
                                _showPaymentSuccessDialog();
                                // TODO: Implement actual payment logic
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                          // Add disabled color styling
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Bayar Sekarang',
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
            ],
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
        trailing: title == "Total UKT" && _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(
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
}
