import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:questionnaire_app/constants/ui_constants.dart';
import 'package:questionnaire_app/controllers/submission_controller.dart';
import 'package:questionnaire_app/core/database_helper.dart';
import 'package:questionnaire_app/data/questionnaires.dart';
import 'package:questionnaire_app/models/question.dart';
import 'package:questionnaire_app/ui/widgets/ui_button.dart';
import 'package:questionnaire_app/utils/common.dart';
import 'package:questionnaire_app/utils/location.dart';
import 'package:questionnaire_app/utils/ui.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final submissionController = getOrPut(SubmissionController.new);

  RxnInt questionnaireId = RxnInt();

  Map<int, int?> selectedAnswers = {};

  final RxBool isSubmitting = false.obs;
  final RxBool isAlreadySubmitted = false.obs;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args != null && args.containsKey('id')) {
      final id = args['id'];
      if (id is int) {
        questionnaireId.value = id;
      } else if (id is String) {
        questionnaireId.value = int.tryParse(id);
      }
    }

    submissionController.loadSubmissions();
    _loadExistingAnswers();
  }

  Future<void> _loadExistingAnswers() async {
    final id = questionnaireId.value;
    if (id == null) return;

    final existingAnswers = await DatabaseHelper.instance.getSubmissionAnswers(
      id,
    );

    if (existingAnswers == null || existingAnswers.isEmpty) return;

    if (!mounted) return;
    setState(() {
      isAlreadySubmitted.value = true;
      selectedAnswers = {
        for (var i = 0; i < existingAnswers.length; i++) i: existingAnswers[i],
      };
    });
  }

  List<Question> getQuestionsByQuestionnaireId(int? id) {
    return questionnaires.firstWhere((q) => q.id == id).questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questions')),
      body: Obx(() => _buildQuestionsList()),
    );
  }

  Widget _buildQuestionsList() {
    final questions = getQuestionsByQuestionnaireId(questionnaireId.value);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingMedium),
      child: ListView.builder(
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == questions.length) {
            if (isAlreadySubmitted.value) return const SizedBox.shrink();
            return _buildSubmitButton(questions.length, questionnaireId.value);
          }

          return _buildQuestion(questions[index], index);
        },
      ),
    );
  }

  Widget _buildQuestion(Question question, int qIndex) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(paddingLarge),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioGroup<int>(
              groupValue: selectedAnswers[qIndex],
              onChanged: (value) {
                if (isAlreadySubmitted.value) return;
                setState(() {
                  selectedAnswers[qIndex] = value;
                });
              },
              child: Column(
                crossAxisAlignment: .start,
                children: List.generate(
                  question.options.length,
                  (index) => RadioListTile<int>(
                    value: index,
                    title: Text(question.options[index]),
                    enabled: !isAlreadySubmitted.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(int totalQuestions, int? questionnaireId) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: UiButton(
          isLoading: isSubmitting.value,
          onPressed: () async {
            if (questionnaireId != null) {
              isSubmitting.value = true;
              await submitQuestions(questionnaireId);
              isSubmitting.value = false;
            }
          },
          text: "Submit",
        ),
      ),
    );
  }

  Future<void> submitQuestions(int questionnaireId) async {
    if (selectedAnswers.length !=
        getQuestionsByQuestionnaireId(questionnaireId).length) {
      snackBar("Error", "Please answer all questions", type: .error);
      return;
    }

    final answers = selectedAnswers.values.toList();

    Position? position;

    try {
      position = await getLocation(context);
    } catch (e) {
      if (e is LocationException) {
      } else {
        rethrow;
      }
      return;
    }

    final data = {
      'questionnaire_id': questionnaireId,
      'answers': jsonEncode(answers),
      'submitted_at': DateTime.now().toIso8601String(),
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    try {
      await DatabaseHelper.instance.insertSubmission(data);
      await submissionController.loadSubmissions();
      navigateBack(result: true);
    } catch (e) {
      debugPrint('Submission error: $e');
      snackBar(
        "Error",
        "Failed to submit questionnaire. Please try again.",
        type: .error,
      );
    }
  }
}
