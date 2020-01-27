import 'dart:collection';
import 'package:diabetes_app/quiz.dart';
import 'package:flutter/cupertino.dart';

class QuizNotifier with ChangeNotifier{

  List<Quiz> _quizList = [];
  Quiz _currentQuiz;

  UnmodifiableListView<Quiz> get quizList => UnmodifiableListView(_quizList);

  Quiz get currentQuiz => _currentQuiz;

  set quizList (List<Quiz> quizList){
    _quizList = quizList;
    notifyListeners();
  }

  set currentQuiz(Quiz quiz){
    _currentQuiz = quiz;
    notifyListeners();
  }


}