import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:quiz_game/module/module.dart';

Future<List<QuizQuestion>> fetchData() async {
  final apiUrl = Uri.parse('https://opentdb.com/api.php?amount=10&category=27&difficulty=easy&type=multiple');
  final List<QuizQuestion> questions = [];

  try {
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      for (var result in results) {
        final quizQuestion = QuizQuestion(
          category: result['category'],
          type: result['type'],
          difficulty: result['difficulty'],
          question: result['question'],
          correctAnswer: result['correct_answer'],
          incorrectAnswers: List<String>.from(result['incorrect_answers']),
        );

        questions.add(quizQuestion);
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  } catch (error) {
    // Handle network or other errors that may occur during the API call.
    print('Error: $error');
  }

  return questions;
}
