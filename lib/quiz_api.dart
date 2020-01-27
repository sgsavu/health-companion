import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/quiz.dart';
import 'package:diabetes_app/quiz_notifier.dart';



getQuiz(QuizNotifier quizNotifier)async{

  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Quiz')
      .getDocuments();

  List<Quiz> _quizList = [];


  snapshot.documents.forEach((document) {
    Quiz quiz = Quiz.fromMap(document.data);
      _quizList.add(quiz);
  });

  quizNotifier.quizList = _quizList;
}
