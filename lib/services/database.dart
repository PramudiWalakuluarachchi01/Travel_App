import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future<void> addPost(Map<String, dynamic> postData, String postId) async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId)
        .set(postData);
  }

  Future<void> likePost(String postId, String userId) async {
    await FirebaseFirestore.instance.collection("Posts").doc(postId).update({
      'Likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    await FirebaseFirestore.instance.collection("Posts").doc(postId).update({
      'Likes': FieldValue.arrayRemove([userId]),
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("Time", descending: true)
        .snapshots();
  }

  Future addComment(Map<String, dynamic> userInfoMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("Posts")
        .doc(userId)
        .collection("comments")
        .add(userInfoMap);
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId)
        .collection("comments")
        .orderBy("Time", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsPlace(String place) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .where("CityName", isEqualTo: place)
        .snapshots();
  }
}
