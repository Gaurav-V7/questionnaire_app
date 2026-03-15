import 'package:questionnaire_app/models/question.dart';
import 'package:questionnaire_app/models/questionnaire.dart';

final List<Questionnaire> questionnaires = [
  Questionnaire(
    id: 1,
    title: "Employee Feedback",
    description: "Tell us about your workplace experience",
    questions: [
      Question(
        question: "How satisfied are you with your job?",
        options: ["Very satisfied", "Satisfied", "Neutral", "Unsatisfied"],
      ),
      Question(
        question: "Do you like remote work?",
        options: ["Yes", "No", "Sometimes"],
      ),
      Question(
        question: "How is the work environment?",
        options: ["Excellent", "Good", "Average", "Poor"],
      ),
      Question(question: "Do you feel valued?", options: ["Yes", "No"]),
      Question(
        question: "Would you recommend this company?",
        options: ["Yes", "No", "Maybe"],
      ),
    ],
  ),
  Questionnaire(
    id: 2,
    title: "Technology Survey",
    description: "Tell us about your tech preferences",
    questions: [
      Question(question: "Preferred mobile OS?", options: ["Android", "iOS"]),
      Question(
        question: "Favorite framework?",
        options: ["Flutter", "React Native", "Native"],
      ),
      Question(
        question: "How many hours do you code daily?",
        options: ["1-2", "3-4", "5+"],
      ),
      Question(
        question: "Preferred work setup?",
        options: ["Office", "Remote", "Hybrid"],
      ),
      Question(
        question: "Experience level?",
        options: ["Beginner", "Intermediate", "Expert"],
      ),
    ],
  ),
];
