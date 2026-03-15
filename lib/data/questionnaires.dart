import 'package:questionnaire_app/models/question.dart';
import 'package:questionnaire_app/models/questionnaire.dart';

final List<Questionnaire> questionnaires = [
  Questionnaire(
    id: 1,
    title: "Workplace Experience",
    description: "Share your day-to-day work experience",
    questions: [
      Question(
        question: "How satisfied are you with your current role?",
        options: ["Very satisfied", "Satisfied", "Neutral", "Unsatisfied"],
      ),
      Question(
        question: "How manageable is your current workload?",
        options: ["Easy to manage", "Mostly manageable", "Difficult", "Very difficult"],
      ),
      Question(
        question: "How would you rate team collaboration?",
        options: ["Excellent", "Good", "Average", "Poor"],
      ),
      Question(
        question: "How often do you receive useful feedback?",
        options: ["Weekly", "Monthly", "Rarely", "Never"],
      ),
      Question(
        question: "Would you recommend this workplace to others?",
        options: ["Definitely", "Maybe", "Not likely"],
      ),
    ],
  ),
  Questionnaire(
    id: 2,
    title: "Developer Tooling",
    description: "Tell us about your coding tools and habits",
    questions: [
      Question(
        question: "Which IDE do you use most often?",
        options: ["VS Code", "Android Studio", "IntelliJ", "Other"],
      ),
      Question(
        question: "How often do you use version control branches?",
        options: ["Always", "Sometimes", "Rarely"],
      ),
      Question(
        question: "How often do you run tests before commit?",
        options: ["Always", "Often", "Sometimes", "Never"],
      ),
      Question(
        question: "What is your preferred debugging method?",
        options: ["IDE debugger", "Logs", "Unit tests", "Manual checks"],
      ),
      Question(
        question: "How comfortable are you with code reviews?",
        options: ["Very comfortable", "Comfortable", "Needs improvement"],
      ),
    ],
  ),
  Questionnaire(
    id: 3,
    title: "Product Feedback",
    description: "Help us improve the application experience",
    questions: [
      Question(
        question: "How intuitive is the app navigation?",
        options: ["Very intuitive", "Somewhat intuitive", "Confusing", "Very confusing"],
      ),
      Question(
        question: "How useful are the current features?",
        options: ["Very useful", "Useful", "Somewhat useful", "Not useful"],
      ),
      Question(
        question: "How often do you face app issues?",
        options: ["Never", "Sometimes", "Often"],
      ),
      Question(
        question: "How satisfied are you with app performance?",
        options: ["Very satisfied", "Satisfied", "Neutral", "Unsatisfied"],
      ),
      Question(
        question: "How likely are you to continue using the app?",
        options: ["Very likely", "Likely", "Unlikely"],
      ),
    ],
  ),
  Questionnaire(
    id: 4,
    title: "Learning & Growth",
    description: "Understand training and upskilling needs",
    questions: [
      Question(
        question: "How often do you learn a new skill each month?",
        options: ["Very often", "Often", "Rarely", "Never"],
      ),
      Question(
        question: "How relevant are available learning resources?",
        options: ["Highly relevant", "Relevant", "Somewhat relevant", "Irrelevant"],
      ),
      Question(
        question: "Preferred format for learning content?",
        options: ["Videos", "Articles", "Hands-on projects", "Mentoring"],
      ),
      Question(
        question: "How confident are you applying new skills at work?",
        options: ["Very confident", "Confident", "Not confident"],
      ),
      Question(
        question: "How supported do you feel in career growth?",
        options: ["Highly supported", "Supported", "Limited support", "Not supported"],
      ),
    ],
  ),
  Questionnaire(
    id: 5,
    title: "Wellbeing Check",
    description: "Help us understand team wellbeing",
    questions: [
      Question(
        question: "How would you rate your work-life balance?",
        options: ["Excellent", "Good", "Average", "Poor"],
      ),
      Question(
        question: "How often do you feel stressed at work?",
        options: ["Rarely", "Sometimes", "Often", "Always"],
      ),
      Question(
        question: "How comfortable are you taking breaks during work?",
        options: ["Very comfortable", "Comfortable", "Uncomfortable"],
      ),
      Question(
        question: "How would you rate your current energy level?",
        options: ["High", "Moderate", "Low"],
      ),
      Question(
        question: "How supported do you feel by your manager?",
        options: ["Very supported", "Supported", "Partially supported", "Not supported"],
      ),
    ],
  ),
];
