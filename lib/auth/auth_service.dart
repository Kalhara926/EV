// lib/auth/auth_service.dart

import 'dart:io'; // <-- මෙන්න අලුතෙන් එකතු කරන import එක
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the user cancels the process, googleUser will be null. Return null.
      if (googleUser == null) {
        debugPrint("Google sign-in cancelled by user.");
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);

      // After signing in, create a user document in Firestore if it doesn't exist
      await _createOrUpdateUserDocument(userCredential.user);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Google Sign-in Firebase Error: ${e.message}");
      // Rethrow a more specific error or handle it as needed in the UI
      throw Exception('Google sign-in failed. Please try again.');
    } catch (e) {
      debugPrint("An unexpected error occurred with Google Sign-in: $e");
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  // Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
    // Check if Apple Sign-In is available on the current platform
    if (kIsWeb || !Platform.isIOS && !Platform.isMacOS) {
      debugPrint("Apple Sign-in is not supported on this platform.");
      // You can show a message to the user here if you want
      return null;
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Create user document, passing the name parts from Apple credential
      await _createOrUpdateUserDocument(
        userCredential.user,
        firstName: appleCredential.givenName,
        lastName: appleCredential.familyName,
      );

      return userCredential;
    } catch (e) {
      // This can happen if the user cancels the sign-in
      debugPrint("Apple Sign-in Error: $e");
      // Don't throw an error, just return null as the user likely cancelled
      return null;
    }
  }

  // Create a new user document in Firestore if it doesn't exist
  Future<void> _createOrUpdateUserDocument(User? user,
      {String? firstName, String? lastName}) async {
    if (user == null) return;

    final userDocRef = _firestore.collection('users').doc(user.uid);
    final doc = await userDocRef.get();

    // If the user document doesn't exist, create it with all necessary fields
    if (!doc.exists) {
      // Try to get name from the social provider
      final nameParts = user.displayName?.split(' ') ?? [];
      final fName = firstName ?? (nameParts.isNotEmpty ? nameParts.first : '');
      final lName = lastName ??
          (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');

      await userDocRef.set({
        'uid': user.uid,
        'email': user.email,
        'first_name': fName,
        'last_name': lName,
        'profile_image_url': user.photoURL ?? '',
        'role': 'user',
        'ev_points': 0,
        'mobile_number': user.phoneNumber ?? '',
        'company_name': '',
        'country': '',
      });
    }
  }
}
