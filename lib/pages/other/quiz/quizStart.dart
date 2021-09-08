import 'package:flutter/material.dart';

import 'package:app/assets/components/buttons/darkButton.dart';
import 'package:app/assets/routes/customRoute.dart';

import 'package:app/pages/other/quiz/quizPage.dart';

import 'package:app/models/Quiz.dart';

class QuizStartPage extends StatelessWidget {
  final int id;

  QuizStartPage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: FutureBuilder<Quiz>(
            future: readQuizFromAssets(id),
            builder: (BuildContext context, AsyncSnapshot<Quiz> snapshot) {
              if (snapshot.hasData) {
                return DarkButton("Start Quiz", onPressed: () {
                  //Navigator.push(
                  // context,
                  // CustomRoute(builder: (context) => QuizPage(snapshot.data))
                  //);
                });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
