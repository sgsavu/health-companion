import 'package:diabetes_app/exercises/exercise.dart';
import 'package:diabetes_app/exercises/exercise_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



getExercise(ExerciseNotifier exerciseNotifier,String currentUser)async{

  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Exercises')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Exercise> _exerciseList = [];


  snapshot.documents.forEach((document) {
    Exercise exercise = Exercise.fromMap(document.data);
    if(exercise.userEmail==currentUser || exercise.userEmail=='Default')
      _exerciseList.add(exercise);
  });

  exerciseNotifier.exerciseList = _exerciseList;
}
getExerciseForUpdate(ExerciseNotifier exerciseNotifier,String currentUser)async{

  QuerySnapshot snapshot =  await Firestore.instance
      .collection('Exercises')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Exercise> _exerciseList = [];


  snapshot.documents.forEach((document) {
    Exercise exercise = Exercise.fromMap(document.data);
    if(exercise.userEmail==currentUser)
      _exerciseList.add(exercise);
  });

  exerciseNotifier.exerciseList = _exerciseList;
}


updateExercise(Exercise exercise) async{

  CollectionReference medicineRef =  await Firestore.instance.collection('Exercises');
    await medicineRef.document(exercise.id).updateData(exercise.toMap());

    print('updated exercise with id: ${exercise.id}');

}