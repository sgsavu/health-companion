import 'dart:collection';
import 'package:diabetes_app/exercises/exercise.dart';
import 'package:flutter/cupertino.dart';

class ExerciseNotifier with ChangeNotifier{

  List<Exercise> _exerciseList = [];
  Exercise _currentExercise;

  UnmodifiableListView<Exercise> get exerciseList => UnmodifiableListView(_exerciseList);

  Exercise get currentExercise => _currentExercise;

  set exerciseList (List<Exercise> exerciseList){
    _exerciseList = exerciseList;
    notifyListeners();
  }

  set currentExercise(Exercise exercise){
    _currentExercise = exercise;
    notifyListeners();
  }


}