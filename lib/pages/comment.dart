import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/home.dart';
import 'package:travel_app/services/database.dart';

class Comment extends StatefulWidget {
  final String userName;
  final String postId;
  final String userId;

  const Comment({
    super.key,
    required this.userName,
    required this.postId,
    required this.userId,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final TextEditingController commentController = TextEditingController();
  Stream<QuerySnapshot>? commentStream;

  @override
  void initState() {
    super.initState();
    commentStream = DatabaseMethods().getComments(widget.postId);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  /// ---------------- COMMENTS LIST ----------------
  Widget allComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: commentStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No comments yet"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 220, 218, 218),
                        radius: 25,
                        child: Icon(Icons.person,
                        color: Colors.orange,),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds["UserName"] ?? "User",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ds["Comment"] ?? "",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_outlined),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                  ),
                  const Spacer(),
                  const Text(
                    "Comments",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            /// COMMENTS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: allComments(),
              ),
            ),

            /// ADD COMMENT FIELD
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: "Add a comment...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      if (commentController.text.trim().isEmpty) return;

                      Map<String, dynamic> addComment = {
                        "UserName": widget.userName,
                        "Comment": commentController.text.trim(),
                        "UserId": widget.userId,
                        "Time": FieldValue.serverTimestamp(),
                      };

                      await DatabaseMethods()
                          .addComment(addComment, widget.postId);

                      commentController.clear();
                    },
                    child: const Icon(Icons.send, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
