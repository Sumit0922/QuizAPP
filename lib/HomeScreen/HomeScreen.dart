import 'package:flutter/material.dart';
import 'package:quiz_game/API%20Connection/apiConnect.dart';
import 'package:quiz_game/AnswerCard/answercards.dart';
import 'package:quiz_game/module/module.dart';
import 'package:quiz_game/SplashScreen/SplashScreen.dart'; // Import your SplashScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QuizQuestion> questions = [];
  int selectedAnswerIndex = -1;
  bool showCorrectAnswer = false;
  List<List<String>> selectedAnswersList = [];
  bool nextButtonClickable = false;
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData().then((fetchedQuestions) {
      if (mounted) {
        setState(() {
          questions = fetchedQuestions;
          nextButtonClickable = true;
          selectedAnswersList = List.generate(questions.length, (_) => []);
        });
      }
    });
  }

  void handleAnswerSelection(String selectedAnswer, int index) {
    setState(() {
      selectedAnswerIndex = index;
      selectedAnswersList[currentQuestionIndex].clear();
      selectedAnswersList[currentQuestionIndex].add(selectedAnswer);
      nextButtonClickable = true;
      showCorrectAnswer = true; // Enable the "Show Answer" option when an answer is selected
    });
    print("Selected answer: $selectedAnswer");
  }

  void handleNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = -1;
        nextButtonClickable = false;
        showCorrectAnswer = false; // Disable the "Show Answer" option when moving to the next question
      });
    } else {
      // Calculate the number of correct and incorrect answers
      int correctAnswers = 0;
      int incorrectAnswers = 0;
      for (int i = 0; i < questions.length; i++) {
        if (selectedAnswersList[i].isNotEmpty && selectedAnswersList[i].first == questions[i].correctAnswer) {
          correctAnswers++;
        } else {
          incorrectAnswers++;
        }
      }

      // Show the result dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Quiz Results"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Total Questions: ${questions.length}"),
                Text("Correct Answers: $correctAnswers"),
                Text("Incorrect Answers: $incorrectAnswers"),
                SizedBox(height: 20),
                Text("Thank you!"),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the result dialog
                  Navigator.of(context).pushReplacement( // Navigate back to the splash screen
                    MaterialPageRoute(
                      builder: (_) => SplashScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
            child: Text(
              questions.isEmpty
                  ? "Loading question..."
                  : questions[currentQuestionIndex].question,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Select the correct answer:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          if (questions.isNotEmpty) // Check if questions list is not empty
            ...[
              for (int i = 0; i < questions[currentQuestionIndex].incorrectAnswers.length; i++)
                AnswerCard(
                  questions[currentQuestionIndex].incorrectAnswers[i],
                  selectedAnswerIndex == i,
                      (selectedAnswer) {
                    handleAnswerSelection(selectedAnswer, i);
                  },
                ),
              AnswerCard(
                questions[currentQuestionIndex].correctAnswer,
                selectedAnswerIndex == questions[currentQuestionIndex].incorrectAnswers.length,
                    (selectedAnswer) {
                  handleAnswerSelection(selectedAnswer, questions[currentQuestionIndex].incorrectAnswers.length);
                },
              ),
            ]
          else
            AnswerCard("Loading...", false, (selectedAnswer) => {}),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              setState(() {
                showCorrectAnswer = !showCorrectAnswer;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Show Answer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: nextButtonClickable ? Colors.blue : Colors.grey, // Change color based on nextButtonClickable
                    ),
                  ),
                  Icon(
                    showCorrectAnswer
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: nextButtonClickable ? Colors.blue : Colors.grey, // Change color based on nextButtonClickable
                  ),
                ],
              ),
            ),
          ),
          if (showCorrectAnswer)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Correct Answer: ${questions[currentQuestionIndex].correctAnswer}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          SizedBox(height: 20),
          Text(
            "Selected Answers:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(selectedAnswersList[currentQuestionIndex].join(", ")),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedAnswerIndex != -1
                ? () {
              handleNextQuestion();
            }
                : null,
            child: Text(currentQuestionIndex < questions.length - 1 ? "Next" : "Submit"),
          ),
        ],
      ),
    );
  }
}
