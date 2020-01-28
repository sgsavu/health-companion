import 'dart:math';
import 'package:diabetes_app/global_api.dart';
import 'package:diabetes_app/loading.dart';
import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/profile/profile.dart';
import 'package:diabetes_app/profile/profile_api.dart';
import 'package:diabetes_app/profile/profile_notifier.dart';
import 'package:diabetes_app/quiz.dart';
import 'package:diabetes_app/quiz_api.dart';
import 'package:diabetes_app/quiz_notifier.dart';
import 'package:diabetes_app/reward.dart';
import 'package:diabetes_app/reward_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String selectedAnswer = '';
  Quiz randomQuestion = Quiz();
  Reward newReward = Reward();

  @override
  void initState() {

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    QuizNotifier quizNotifier =
        Provider.of<QuizNotifier>(context, listen: false);
    getQuiz(quizNotifier);

    ProfileNotifier profileNotifier =
    Provider.of<ProfileNotifier>(context, listen: false);
    getProfile(profileNotifier,authNotifier.user.email);


    super.initState();
  }

  onProfileUploaded(Profile profile, bool hmm) {
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);
    if (hmm == false) {
      profileNotifier.addProfile(profile);
    }

    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context, listen: false);
    getProfile(profileNotifier, authNotifier.user.email);
  }

  checkCorrect() {
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);

    if (selectedAnswer==randomQuestion.correctAnswer)
      {

        createAlertDialogCustom(context, 'Correct', 'Your answer is correct, well done!', AssetImage('assets/check.png'));

        profileNotifier.currentProfile?.quizScore = profileNotifier.currentProfile?.quizScore + 10;

        if(profileNotifier.currentProfile?.quizScore==1000)
        {
          newReward.rewardName='Diploma of Diabetes Awareness';
          newReward.userEmail = profileNotifier.currentProfile.email;
          newReward.userName = profileNotifier.currentProfile.name;
          uploadReward(newReward);
          profileNotifier.currentProfile?.quizScore=profileNotifier.currentProfile?.quizScore+10;

          createAlertDialogCustom(context, 'Congratulations', 'You have reached 1000 points and have been awarded a Diploma of Diabetes Awareness. You can expect this in your email within 48 hours!', AssetImage('assets/diploma4.png'));

        }

        uploadProfile(profileNotifier.currentProfile, true, onProfileUploaded);


      }else
        {

          createAlertDialogCustom(context, 'Wrong', 'Your answer is wrong. Try again next time!', AssetImage('assets/wrong.png'));

        }
  }

  newQuestion() {
    final random = new Random();
    QuizNotifier quizNotifier = Provider.of<QuizNotifier>(context);

    randomQuestion = quizNotifier.quizList
        ?.elementAt(random.nextInt(quizNotifier.quizList?.length));
    createAlertDialogQuiz(
      context,
      'Question ${randomQuestion?.number}',
      randomQuestion?.question,
      randomQuestion?.answer1,
      randomQuestion?.answer2,
      randomQuestion?.answer3,
      randomQuestion?.answer4,
    );
  }

  createAlertDialogQuiz(BuildContext context, String title, String message,
      String answer1, String answer2, String answer3, String answer4) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 26.0 + 16.0,
                      bottom: 16,
                      left: 16,
                      right: 16,
                    ),
                    margin: EdgeInsets.only(top: 66.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // To make the card compact
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 24.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                setState(() {
                                  selectedAnswer = answer1;
                                }),
                                checkCorrect(),

                              },
                              child: Text('A. ${answer1}'),
                            ),
                            FlatButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                setState(() {
                                  selectedAnswer = answer2;
                                }),
                                checkCorrect(),
                              },
                              child: Text('B. ${answer2}'),
                            ),
                            FlatButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                setState(() {
                                  selectedAnswer = answer3;
                                }),
                                checkCorrect(),
                              },
                              child: Text('C. ${answer3}'),
                            ),
                            FlatButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                setState(() {
                                  selectedAnswer = answer4;
                                }),
                                checkCorrect()
                              },
                              child: Text(
                                'D. ${answer4}',
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/question.png'),
                        backgroundColor: Colors.white,
                        maxRadius: 50,
                      ),
                    ],
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {

    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Diabetes Quiz'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.90,
              child: Padding(
                padding: EdgeInsets.fromLTRB(32, 20, 32, 15),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Score: ${profileNotifier.currentProfile?.quizScore}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Test your knowledge about diabetes in this fantastic quiz aimed to raise awareness of the disease. Gather 1000 points and you will be rewarded a Diploma of Diabetes Awareness.',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30,),
                    Text(
                      'Types of topics you could encounter: ',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 35,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '○ Common practices combating diabetes',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          '○ Types of diabetes medication',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),SizedBox(height: 5,),
                        Text(
                          '○ Methods to prevent diabetes',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          '○ Diabetes tools and gadgets',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),SizedBox(height: 5,),
                        Text(
                          '○ Nutrition and diabetes',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          '○ Self-management and treatment',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700
                          ),
                        ),

                        SizedBox(height: 5,),
                        Text(
                          '○ and many more...',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () => {newQuestion()},
        icon: Icon(Icons.question_answer),
        label: Text('New Question'),
      ),
    );
  }
}
