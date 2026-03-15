import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/models/user_model.dart';
import 'package:questionnaire_app/utils/prefs.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/common.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = getOrPut(AuthController.new);

  Rxn<User> user = Rxn<User>();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final userData = await Prefs.getMap('userdata');
    user.value = userData != null ? User.fromJson(userData) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          children: [
            SizedBox(height: paddingLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingLarge),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user.value?.avatar ?? "",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  SizedBox(width: paddingLarge),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        user.value?.name ?? "",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: paddingMedium),
                      Text(
                        user.value?.phone ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: paddingLarge),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: paddingLarge),
              onTap: () async {
                Get.dialog(
                  AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Get.back();
                          await authController.logout();
                          navigateTo(AppRoutes.login, clearPreviousAll: true);
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                );
              },
              leading: Icon(Icons.logout_rounded, color: Colors.red),
              title: Text(
                "Logout",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
