import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../Core/Errors/exception.dart';
import '../../../../core/Utils/Constants/auth_constants.dart';
import '../../Features/Auth/Model/auth_model.dart';

abstract class AuthRemoteServices {
  Future<AuthModel> getuserData();
  Future<Unit> setUserData(AuthModel authModel);
  Future<UserCredential> createAccount(AuthModel authModel);
  Future<UserCredential> emailAndPasswordLogIn(AuthModel authModel);
  Future<UserCredential> faceBookLogIn();

  Future<UserCredential> googleLogIn();
  Future<Unit> logOut();
}

class AuthRemoteServicesFireBase implements AuthRemoteServices {
  late String verificationId;
  @override
  Future<UserCredential> createAccount(AuthModel authModel) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: authModel.email,
        password: authModel.password!,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      }
    } catch (e) {
      throw ServerException();
    }
    throw ServerException();
  }

  @override
  Future<UserCredential> emailAndPasswordLogIn(AuthModel authModel) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: authModel.email, password: authModel.password!);

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
    } catch (e) {
      throw ServerException();
    }
    throw ServerException();
  }

  @override
  Future<UserCredential> googleLogIn() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserCredential> faceBookLogIn() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if the login was successful
      if (result.accessToken != null) {
        // Exchange the Facebook access token for a Firebase credential
        AuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        // Sign in to Firebase with the Facebook credential
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential;
      } else {
        throw FaceBookLogInException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<AuthModel> getuserData() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the user document from Firestore using the current user ID
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection(AuthConstants.kUsersCollection)
          .doc(userId)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Convert the document data to a User object
        AuthModel authModel = AuthModel(
          userName: documentSnapshot.data()![AuthConstants.kUserName],
          email: documentSnapshot.data()![AuthConstants.kEmail],
          phone: documentSnapshot.data()![AuthConstants.kPhone],
        );
        return authModel;
      } else {
        throw NoSavedUserException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> setUserData(AuthModel authModel) async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Convert AuthModel object to a map using toJson() method
      Map<String, dynamic> authData = authModel.toJson();

      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Set the authData map to a document with the current user ID in a 'users' collection
      await firestore
          .collection(AuthConstants.kUsersCollection)
          .doc(userId)
          .set({
        AuthConstants.kUserName: authData[AuthConstants.kUserName],
        AuthConstants.kEmail: authData[AuthConstants.kEmail],
      });

      return Future.value(unit);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> logOut() async {
    try {
      // Sign out the current user using FirebaseAuth
      await FirebaseAuth.instance.signOut();

      return Future.value(unit);
    } catch (e) {
      throw ServerException();
    }
  }
}
