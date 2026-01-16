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

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

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
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 50),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
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
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.only(top: 60, left: 35, right: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                    ),
                  ),

                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: selectedImage != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Center(
                                child: GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black54,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      SizedBox(height: 15),
                      Text(
                        'Place Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 1, right: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextField(
                          controller: placeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            hintText: 'Enter place name',
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'City Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 1, right: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextField(
                          controller: cityController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            hintText: 'Enter City name',
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Caption',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 1, right: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextField(
                          controller: captionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            hintText: 'Enter caption.....',
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
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
                                  SnackBar(
                                    content: Text("Please fill all fields", style: TextStyle(color: Colors.white),),
                                  ),
                                );
                                return;
                              }

                              String addId = randomAlphaNumeric(10);

                              Map<String, dynamic> addPost = {
                                "Place": placeController.text,
                                "City": cityController.text,
                                "Caption": captionController.text,
                                "Image": null, // ❌ No Firebase Storage
                                "UserName": name,
                                "UserImage": image,
                                "createdAt": FieldValue.serverTimestamp(),
                              };

                              await DatabaseMethods().addPost(addPost, addId);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    "Post uploaded (without image)",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            },
                            child: Text("Post", style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
