import '../../../Core/Utils/Constants/k_constants.dart';

class AuthModel {
  final String? userId;
  final String? userName;
  final String email;
  final String? phone;
  final String? profileImgUrl;
  final String? bio;
  final String? nFollowers;
  final String? nFollowing;
  final String? nPosts;

  const AuthModel(
      {this.userName,
      required this.email,
      this.phone,
      this.userId,
      this.profileImgUrl,
      this.bio,
      this.nFollowers,
      this.nFollowing,
      this.nPosts});

  factory AuthModel.fromJson(Map<String, dynamic> map) {
    return AuthModel(
        email: map[KConstants.kEmail],
        userId: map[KConstants.kUserId] ?? '',
        userName: map[KConstants.kUserName] ?? '',
        phone: map[KConstants.kPhone] ?? '',
        bio: map[KConstants.kBio] ?? '',
        profileImgUrl: map[KConstants.kProfileImageUrl] ?? '',
        nFollowers: map[KConstants.kNFollowers] ?? '',
        nFollowing: map[KConstants.kNFollowing] ?? '',
        nPosts: map[KConstants.kNPosts] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      KConstants.kEmail: email,
      KConstants.kUserName: userName,
      KConstants.kPhone: phone,
      KConstants.kUserId: userId,
      KConstants.kProfileImageUrl: profileImgUrl,
      KConstants.kBio: bio,
      KConstants.kNFollowers: nFollowers,
      KConstants.kNFollowing: nFollowing,
      KConstants.kNPosts: nPosts,
    };
  }
}
