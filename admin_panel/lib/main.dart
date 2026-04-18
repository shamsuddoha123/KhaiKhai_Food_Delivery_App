import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khaikhai_admin/pages/admin_login.dart';
import 'package:khaikhai_admin/pages/home_admin.dart';
import 'package:khaikhai_admin/service/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KhaiKhai Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffef2b39)),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: SharedPreferenceHelper().getAdminLoginState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeAdmin();
          }
          return const AdminLogin();
        },
      ),
    );
  }
}
