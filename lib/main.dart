import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/routes/app_pages.dart';
import 'package:questionnaire_app/ui/screens/splash_screen.dart';
import 'package:questionnaire_app/ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      home: const SplashScreen(),
    );
  }
}
