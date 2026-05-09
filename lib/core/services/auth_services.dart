import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_fitness_tracker/core/error/exceptions.dart';

class AuthService {
  //change later
  static final FirebaseAuth auth = FirebaseAuth.instance;

   User? get user => auth.currentUser;

  Future<User> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User user = result.user!;
      await user.updateDisplayName(username);

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Sign-up failed.');
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = result.user;

      if (user == null) {
        throw AuthException(message: "User not found");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Sign-in failed.');
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<User?> signInWithGoogle() async {

  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Failed to send reset email.');
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
}
