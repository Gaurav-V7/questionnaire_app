import 'package:questionnaire_app/models/question.dart';

class Questionnaire {
  final int id;
  final String title;
  final String description;
  final List<Question> questions;

  Questionnaire({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });
}
