import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:travel_app/pages/home.dart';
import 'package:travel_app/services/database.dart';
import 'package:travel_app/services/shared_pref.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  String? name, image;

  late TextEditingController placeController;
  late TextEditingController cityController;
  late TextEditingController captionController;

  /// Get user data from SharedPreferences
  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  /// Pick image (optional)
  Future getImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  @override
  void initState() {
    super.initState();
    getthesharedpref();
    placeController = TextEditingController();
    cityController = TextEditingController();
    captionController = TextEditingController();
  }

  @override
  void dispose() {
    placeController.dispose();
    cityController.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 50),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 4),
                const Text(
                  'Add Post',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: Material(
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Image Picker
                      Center(
                        child: GestureDetector(
                          onTap: getImage,
                          child: selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Place
                      const Text("Place Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: placeController,
                        decoration: InputDecoration(
                          hintText: "Enter place name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// City
                      const Text("City Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          hintText: "Enter city name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Caption
                      const Text("Caption",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: captionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Write something...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Post Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            if (placeController.text.isEmpty ||
                                cityController.text.isEmpty ||
                                captionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                ),
                              );
                              return;
                            }

                            String postId = randomString(10);

                            Map<String, dynamic> addPost = {
                              "PostId": postId,
                              "Place": placeController.text,
                              "City": cityController.text,
                              "Caption": captionController.text,
                              "Image": null,
                              "UserName": name,
                              "UserImage": image,
                              "Likes": [],
                              "Time": FieldValue.serverTimestamp(),
                            };

                           String postDocId = randomAlphaNumeric(10); // or let Firestore auto-generate
await DatabaseMethods().addPost(addPost, postDocId);


                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content:
                                    Text("Post uploaded successfully"),
                              ),
                            );

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Post",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
