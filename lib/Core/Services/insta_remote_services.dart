import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/Core/Errors/exception.dart';

import '../../Features/Auth/Model/auth_model.dart';
import '../Utils/Constants/k_constants.dart';

abstract class InstaRemoteServices {
  Future<AuthModel> getuserData();

  Future<List<AuthModel>> getUsersByUserName(String name);
}

class InstaRemoteServicesFireBase implements InstaRemoteServices {
  @override
  Future<AuthModel> getuserData() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the user document from Firestore using the current user ID
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection(KConstants.kUsersCollection)
          .doc(userId)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Convert the document data to a User object
        AuthModel authModel = AuthModel(
          userName: documentSnapshot.data()![KConstants.kUserName],
          email: documentSnapshot.data()![KConstants.kEmail],
          phone: documentSnapshot.data()![KConstants.kPhone],
          bio: documentSnapshot.data()![KConstants.kBio],
          profileImgUrl: documentSnapshot.data()![KConstants.kProfileImageUrl],
          userId: documentSnapshot.data()![KConstants.kUserId],
          nFollowers: documentSnapshot.data()![KConstants.kNFollowers],
          nFollowing: documentSnapshot.data()![KConstants.kNFollowing],
          nPosts: documentSnapshot.data()![KConstants.kNPosts],
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
  Future<List<AuthModel>> getUsersByUserName(String userName) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    try {
      List<AuthModel> users = [];
      for (var doc in snapshot.docs) {
        String documentUserName = doc.get('userName').toString().toLowerCase();
        if (documentUserName.contains(userName.toLowerCase())) {
          AuthModel user =
              AuthModel.fromJson(doc.data() as Map<String, dynamic>);
          users.add(user);
        }
      }

      return users;
    } catch (e) {
      throw SearchException();
    }
  }
}
