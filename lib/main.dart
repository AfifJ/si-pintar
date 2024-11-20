import 'package:flutter/material.dart';
// import 'package:si_pintar/providers/home_provider.dart';
// import 'package:si_pintar/providers/matkul_provider.dart';
import 'package:si_pintar/screen/auth/login_page.dart';
import 'package:si_pintar/screen/home/home_page.dart';
import 'package:si_pintar/services/session_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("07828ff3-1ccf-48ba-96c8-ea6fb514390e");
  OneSignal.Notifications.requestPermission(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionManager.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: snapshot.data == true ? const HomePage() : const LoginPage(),
        );
      },
    );
  }
}
