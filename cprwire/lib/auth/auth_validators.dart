import 'package:firebase_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// Returns null if valid, or an error message string.
String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) {
    return 'Email is required.';
  }
  if (!RegExp(kTextValidatorEmailRegex).hasMatch(email)) {
    return 'Please enter a valid email address (e.g. example@gmail.com).';
  }
  return null;
}

/// Returns null if valid, or an error message for the first failed rule.
String? validatePassword(String? value) {
  final password = value ?? '';
  if (password.isEmpty) {
    return 'Password is required.';
  }
  if (password.length < 8) {
    return 'Password must be at least 8 characters.';
  }
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must contain at least 1 uppercase letter (A-Z).';
  }
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must contain at least 1 lowercase letter (a-z).';
  }
  if (!RegExp(r'[0-9]').hasMatch(password)) {
    return 'Password must contain at least 1 number (0-9).';
  }
  if (!RegExp(r'[@#$!%]').hasMatch(password)) {
    return 'Password must contain at least 1 special character (@, #, \$, !, or %).';
  }
  return null;
}

/// User-friendly Firebase Auth error messages (never expose passwords).
String mapFirebaseAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'This email is already registered. Please log in or use a different email.';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'weak-password':
      return 'Password is too weak. Use at least 8 characters with uppercase, lowercase, a number, and a special character.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Invalid email or password. Please try again.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
