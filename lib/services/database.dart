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

  Future addPost(Map<String, dynamic> userInfoMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("Posts")
        .doc(userId)
        .set(userInfoMap);
  }
 Future<Stream<QuerySnapshot>> getPosts() async {
    return await FirebaseFirestore.instance
        .collection("Posts")
        .snapshots();
  }

}
