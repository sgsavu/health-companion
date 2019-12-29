import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetes_app/login/auth_notifier.dart';


signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

Future<void> sendPasswordResetEmail(String email) async {
  return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}


initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    authNotifier.setUser(firebaseUser);
  }
}