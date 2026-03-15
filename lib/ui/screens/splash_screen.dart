import 'dart:async';

import 'package:flutter/material.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/controllers/auth_controller.dart';
import 'package:questionnaire_app/routes/app_routes.dart';
import 'package:questionnaire_app/utils/common.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authController = getOrPut(AuthController.new);

  late final StreamSubscription<bool> _loginSubscription;

  @override
  void initState() {
    super.initState();

    _loginSubscription = authController.isLoggedIn.listen((loggedIn) async {
      await Future.delayed(const Duration(seconds: 2));

      if (loggedIn) {
        navigateTo(AppRoutes.home, clearPreviousAll: true);
      } else {
        navigateTo(AppRoutes.login, clearPreviousAll: true);
      }
    });
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(paddingLarge),
          child: Stack(
            children: [
              Center(
                child: Text(
                  "Questionnaire App",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
