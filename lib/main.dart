import 'package:chat_app_material3/Pages/login_page.dart';
import 'package:chat_app_material3/Utils.dart';
import 'package:chat_app_material3/services/auth_service.dart';
import 'package:chat_app_material3/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await setUp();
  runApp(const MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registreServices();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GetIt.instance.get<NavigationService>().navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute:
          GetIt.instance.get<AuthService>().user == null ? "/login" : "/home",
      routes: GetIt.instance.get<NavigationService>().routes,
      // home: const LoginPage(),
    );
  }
}
