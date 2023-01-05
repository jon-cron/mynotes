import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// NOTE this immutable tag means that this class and all classes that inherit it can not change.
@immutable
class AuthUser {
  final bool isEmailVerified;
// NOTE the constructor below is mandatory for all variables in a class.
  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
