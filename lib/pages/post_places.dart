import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/comment.dart';
import 'package:travel_app/services/database.dart';
import 'package:travel_app/services/shared_pref.dart';

class PostPlaces extends StatefulWidget {
  final String cityName;

  const PostPlaces({super.key, required this.cityName});

  @override
  State<PostPlaces> createState() => _PostPlacesState();
}

class _PostPlacesState extends State<PostPlaces> {
  String? name, image, id;
  Stream<QuerySnapshot>? postStream;

  @override
  void initState() {
    super.initState();
    getUserData();
    postStream = DatabaseMethods().getPostsPlace(widget.cityName);
  }

  getUserData() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  Widget allPosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: postStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No posts for this city"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            // Safe reads
            List likes = [];
            String userImage = "";
            String postImage = "";
            String userName = "User";
            String place = "";
            String city = "";
            String caption = "";

            try {
              likes = ds.get("Likes") ?? [];
            } catch (e) {}
            try {
              userImage = ds.get("UserImage") ?? "";
            } catch (e) {}
            try {
              postImage = ds.get("Image") ?? "";
            } catch (e) {}
            try {
              userName = ds.get("UserName") ?? "User";
            } catch (e) {}
            try {
              place = ds.get("Place") ?? "";
            } catch (e) {}
            try {
              city = ds.get("City") ?? "";
            } catch (e) {}
            try {
              caption = ds.get("Caption") ?? "";
            } catch (e) {}

            bool isLiked = id != null && likes.contains(id);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: userImage.isNotEmpty
                                  ? Image.network(
                                      userImage,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Post Image or blank 200px space
                      postImage.isNotEmpty
                          ? Image.network(
                              postImage,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                              ),
                            ),

                      const SizedBox(height: 5),

                      // Place & City
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "$place, $city",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Caption
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          caption,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Like / Comment / Share Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              if (id == null) return;
                              if (isLiked) {
                                await DatabaseMethods().unlikePost(ds.id, id!);
                              } else {
                                await DatabaseMethods().likePost(ds.id, id!);
                              }
                            },
                          ),
                          IconButton(
                            icon: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Comment(
                                      userName: name ?? "User",
                                      postId: ds.id,
                                      userId: id ?? "",
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(Icons.comment_outlined),
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                              icon: const Icon(Icons.share), onPressed: () {}),
                        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
        centerTitle: true,
      ),
      body: allPosts(),
    );
  }
}
