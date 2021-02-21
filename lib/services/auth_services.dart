import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged => _auth.authStateChanges().map(
        (User user) => user?.uid,
      );

  //email and password sign up

  Future<String> createUserEmailandPassword(
      String email, String password, String name) async {
    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      await updateUserName(name);
    });
  }

//email and password sign in

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  //signOut
  signOut() {
    return _auth.signOut();
  }

  //reset password
  Future sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  //create anonymous user

  Future signInAnonymously() {
    return _auth.signInAnonymously();
  }

//Google
  Future<String> sinInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );

    return (await _auth.signInWithCredential(credential)).user.uid;
  }

  Future convertUserWithEmail(
      String email, String password, String name) async {
    final currentUser = _auth.currentUser;
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name);
  }

  Future convertWithGoogle() async {
    final currentUser = await _auth.currentUser;
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName);
  }

  Future updateUserName(String name) async {
    final user = _auth.currentUser;
    await user.updateProfile(displayName: name);

    await user.reload();
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters";
    }
    if (value.length > 25) {
      return "Name must be less than 25 characters";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
