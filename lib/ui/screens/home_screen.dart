import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/controllers/submission_controller.dart';
import 'package:questionnaire_app/data/questionnaires.dart';
import 'package:questionnaire_app/models/questionnaire.dart';
import 'package:questionnaire_app/routes/app_routes.dart';
import 'package:questionnaire_app/utils/common.dart';
import 'package:questionnaire_app/utils/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final submissionController = getOrPut(SubmissionController.new);

  @override
  void initState() {
    super.initState();
    submissionController.loadSubmissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            // Ensure Obx registers this reactive dependency in its own scope.
            final _ = submissionController.submittedQuestionnaireIds.length;
            return _buildQuestionnaireList();
          },
        ),
      ),
    );
  }

  Widget _buildQuestionnaireList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
      child: ListView.builder(
        itemCount: questionnaires.length,
        itemBuilder: (context, index) {
          return _buildQuestionnaireCard(questionnaires[index]);
        },
      ),
    );
  }

  Widget _buildQuestionnaireCard(Questionnaire questionnaire) {
    final isSubmitted = submissionController.isSubmitted(questionnaire.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(questionnaire.title),
        subtitle: Text(questionnaire.description),
        trailing: Icon(
          isSubmitted ? Icons.check_circle_rounded : Icons.pending,
          color: isSubmitted ? Colors.green : Colors.grey,
        ),
        onTap: () async {
          final result = await navigateTo(
            AppRoutes.questions,
            data: {'id': questionnaire.id},
          );

          if (result == true) {
            await submissionController.loadSubmissions();
            snackBar("Success", "Questionnaire submitted");
          }
        },
      ),
    );
  }
}
