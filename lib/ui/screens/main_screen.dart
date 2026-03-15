import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/routes/app_routes.dart';
import 'package:questionnaire_app/ui/screens/home_screen.dart';
import 'package:questionnaire_app/ui/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String screenKey;

  const MainScreen({super.key, this.screenKey = AppRoutes.home});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final RxInt _selectedIndex = 0.obs;

  @override
  void initState() {
    super.initState();

    switch (widget.screenKey) {
      case AppRoutes.home:
        _selectedIndex.value = 0;
        break;
      case AppRoutes.profile:
        _selectedIndex.value = 1;
        break;
    }
  }

  String getTitle() {
    switch (_selectedIndex.value) {
      case 0:
        return "Home";
      case 1:
        return "Profile";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text(getTitle())),
        body: IndexedStack(
          index: _selectedIndex.value,
          children: [HomeScreen(), ProfileScreen()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.all(paddingMedium),
                child: Icon(Icons.home),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
          onTap: (index) {
            _selectedIndex.value = index;
          },
        ),
      ),
    );
  }
}
