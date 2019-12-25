import 'package:diabetes_app/exercises/exercise.dart';
import 'package:diabetes_app/exercises/exercise_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



getExercise(ExerciseNotifier exerciseNotifier)async{

  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Exercises')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Exercise> _exerciseList = [];


  snapshot.documents.forEach((document) {
    Exercise exercise = Exercise.fromMap(document.data);
    _exerciseList.add(exercise);
  });

  exerciseNotifier.exerciseList = _exerciseList;
}
