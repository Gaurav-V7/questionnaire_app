import 'package:get/get.dart';
import 'package:questionnaire_app/core/database_helper.dart';
import 'package:questionnaire_app/models/questionnaire.dart';

class QuestionnaireStatusItem {
  final Questionnaire questionnaire;
  final bool isSubmitted;

  QuestionnaireStatusItem({
    required this.questionnaire,
    required this.isSubmitted,
  });
}

class SubmissionController extends GetxController {
  RxSet<int> submittedQuestionnaireIds = <int>{}.obs;

  Future<Set<int>> getSubmittedQuestionnaireIds() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'submissions',
      distinct: true,
      columns: ['questionnaire_id'],
    );

    return result
        .map((row) => row['questionnaire_id'])
        .whereType<int>()
        .toSet();
  }

  Future<List<QuestionnaireStatusItem>> getQuestionnairesWithStatus(
    List<Questionnaire> questionnaireList,
  ) async {
    final submittedIds = await getSubmittedQuestionnaireIds();

    return questionnaireList
        .map(
          (questionnaire) => QuestionnaireStatusItem(
            questionnaire: questionnaire,
            isSubmitted: submittedIds.contains(questionnaire.id),
          ),
        )
        .toList();
  }

  Future<void> loadSubmissions() async {
    final submittedIds = await getSubmittedQuestionnaireIds();

    submittedQuestionnaireIds.clear();
    submittedQuestionnaireIds.addAll(submittedIds);
  }

  bool isSubmitted(int questionnaireId) {
    return submittedQuestionnaireIds.contains(questionnaireId);
  }
}
