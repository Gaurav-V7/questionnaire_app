import 'package:flutter/material.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/controllers/submission_controller.dart'
    show QuestionnaireStatusItem, SubmissionController;
import 'package:questionnaire_app/data/questionnaires.dart';
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
  late Future<List<QuestionnaireStatusItem>> _questionnairesFuture;

  @override
  void initState() {
    super.initState();
    _questionnairesFuture = submissionController.getQuestionnairesWithStatus(
      questionnaires,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<QuestionnaireStatusItem>>(
        future: _questionnairesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load questionnaires: ${snapshot.error}'),
            );
          }

          return _buildQuestionnaireList(snapshot.data ?? []);
        },
      ),
    );
  }

  Widget _buildQuestionnaireList(List<QuestionnaireStatusItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildQuestionnaireCard(items[index]);
        },
      ),
    );
  }

  Widget _buildQuestionnaireCard(QuestionnaireStatusItem item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(item.questionnaire.title),
        subtitle: Text(item.questionnaire.description),
        trailing: Icon(
          item.isSubmitted ? Icons.check_circle_rounded : Icons.pending,
          color: item.isSubmitted ? Colors.green : Colors.grey,
        ),
        onTap: () async {
          final result = await navigateTo(
            AppRoutes.questions,
            data: {'id': item.questionnaire.id},
          );

          if (result == true) {
            setState(() {
              _questionnairesFuture = submissionController
                  .getQuestionnairesWithStatus(questionnaires);
            });
            snackBar("Success", "Questionnaire submitted");
          }
        },
      ),
    );
  }
}
