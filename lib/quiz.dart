import 'package:cloud_firestore/cloud_firestore.dart';


class Quiz {

  String question;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  String correctAnswer;
  int number;




  Quiz();

  Quiz.fromMap(Map<String, dynamic> data){

    question = data['question'];
    answer1 = data['answer1'];
    answer2 = data['answer2'];
    answer3 = data['answer3'];
    answer4 = data['answer4'];
    correctAnswer = data['correctAnswer'];
    number = data['number'];



  }

  Map<String,dynamic> toMap(){
    return{
      'question':question,
      'answer1':answer1,
      'answer2':answer2,
      'answer3':answer3,
      'answer4':answer4,
      'correctAnswer':correctAnswer,
      'number':number,

    };
  }

}