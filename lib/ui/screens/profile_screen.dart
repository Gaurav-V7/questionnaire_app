import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/controllers/submission_controller.dart';
import 'package:questionnaire_app/core/database_helper.dart';
import 'package:questionnaire_app/data/questionnaires.dart';
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
  final submissionController = getOrPut(SubmissionController.new);

  Rxn<User> user = Rxn<User>();
  final RxList<Map<String, dynamic>> submissionHistory =
      <Map<String, dynamic>>[].obs;
  final RxBool isHistoryLoading = true.obs;
  final RxnString historyError = RxnString();
  late Worker _submissionWorker;

  @override
  void initState() {
    super.initState();
    getUserData();
    loadSubmissionHistory();

    _submissionWorker = ever(
      submissionController.submittedQuestionnaireIds,
          (_) => loadSubmissionHistory(),
    );
  }

  void getUserData() async {
    final userData = await Prefs.getMap('userdata');
    user.value = userData != null ? User.fromJson(userData) : null;
  }

  Future<void> loadSubmissionHistory() async {
    try {
      isHistoryLoading.value = true;
      historyError.value = null;

      final history = await DatabaseHelper.instance.getSubmissionHistory();
      submissionHistory.assignAll(history);
    } catch (e) {
      historyError.value = "Unable to load submission history";
    } finally {
      isHistoryLoading.value = false;
    }
  }

  String getQuestionnaireTitle(int questionnaireId) {
    try {
      return questionnaires
          .firstWhere((q) => q.id == questionnaireId)
          .title;
    } catch (_) {
      return "Questionnaire #$questionnaireId";
    }
  }

  String formatSubmittedAt(String submittedAt) {
    final dateTime = DateTime.tryParse(submittedAt)?.toLocal();
    if (dateTime == null) return submittedAt;

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$day/$month/$year $hour:$minute";
  }

  @override
  void dispose() {
    _submissionWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
              () =>
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: paddingLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: paddingLarge),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.value?.avatar ?? "",
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          const SizedBox(width: paddingLarge),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  user.value?.name ?? "",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                const SizedBox(height: paddingMedium),
                                Text(
                                  user.value?.phone ?? "",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: paddingLarge),
                          TextButton.icon(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                    title: Text("Logout"),
                                    content: Text(
                                        "Are you sure you want to logout?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          await authController.logout();
                                          navigateTo(AppRoutes.login,
                                              clearPreviousAll: true);
                                        },
                                        child: Text("Logout"),
                                      ),
                                    ]),
                              );
                            },
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                            ),
                            label: Text("Logout", style: TextStyle(color: Colors.red),),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: paddingLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: paddingLarge),
                      child: Text(
                        "Submission History (${submissionHistory.length})",
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium,
                      ),
                    ),
                    const SizedBox(height: paddingMedium),
                    _buildSubmissionHistory(),
                    const SizedBox(height: paddingLarge),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildSubmissionHistory() {
    final placeholderHeight = MediaQuery
        .sizeOf(context)
        .height * 0.5;

    if (isHistoryLoading.value) {
      return SizedBox(
        height: placeholderHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (historyError.value != null) {
      return SizedBox(
        height: placeholderHeight,
        child: Center(
          child: Text(
            historyError.value!,
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,
          ),
        ),
      );
    }

    if (submissionHistory.isEmpty) {
      return SizedBox(
        height: placeholderHeight,
        child: Center(
          child: Text(
            "No submissions yet",
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: submissionHistory.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      padding: const EdgeInsets.symmetric(horizontal: paddingLarge),
      itemBuilder: (context, index) {
        final item = submissionHistory[index];
        final questionnaireId = (item['questionnaire_id'] as num?)?.toInt() ??
            0;
        final submittedAt = item['submitted_at'] as String? ?? "";

        return Card(
          child: ListTile(
            leading: const Icon(Icons.assignment_turned_in),
            title: Text(getQuestionnaireTitle(questionnaireId)),
            subtitle: Text(formatSubmittedAt(submittedAt)),
          ),
        );
      },
    );
  }
}
