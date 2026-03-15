import 'package:get/get.dart';
import 'package:questionnaire_app/core/database_helper.dart';

class SubmissionController extends GetxController {
  RxSet<int> submittedQuestionnaireIds = <int>{}.obs;

  Future<void> loadSubmissions() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'submissions',
      distinct: true,
      columns: ['questionnaire_id'],
    );

    final submittedIds = result
        .map((row) => row['questionnaire_id'])
        .whereType<int>()
        .toSet();

    submittedQuestionnaireIds
      ..clear()
      ..addAll(submittedIds);
    submittedQuestionnaireIds.refresh();
  }

  bool isSubmitted(int questionnaireId) {
    return submittedQuestionnaireIds.contains(questionnaireId);
  }
}
