import 'package:get/get.dart';
import 'package:questionnaire_app/routes/app_routes.dart';
import 'package:questionnaire_app/ui/screens/main_screen.dart';
import 'package:questionnaire_app/ui/screens/questions_screen.dart';
import 'package:questionnaire_app/ui/screens/register_screen.dart';

import '../ui/screens/login_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainScreen(screenKey: AppRoutes.home),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const MainScreen(screenKey: AppRoutes.profile),
    ),
    GetPage(name: AppRoutes.questions, page: () => const QuestionsScreen()),
  ];
}
