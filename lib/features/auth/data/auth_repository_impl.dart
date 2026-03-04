import '../domain/entities/app_user.dart';
import '../domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(uid: user.uid, email: user.email ?? '');
    });
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ); // after signUp we go info in credential variable type : UserCredential

    final user = credential.user!;
    return AppUser(uid: user.uid, email: user.email ?? '');
  }

  @override
  Future<AppUser> signUp(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;
    return AppUser(uid: user.uid, email: user.email ?? '');
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
