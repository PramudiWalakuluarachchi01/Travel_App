import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:travel_app/pages/home.dart';
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
                            onPressed: () async {
                              {
                                if (selectedImage != null &&
                                    placeController.text != "" &&
                                    cityController.text != "" &&
                                    captionController.text != "") {}
                                String addId = randomAlphaNumeric(10);

                                Reference firebaseStorageRef = FirebaseStorage
                                    .instance
                                    .ref()
                                    .child('blogImage')
                                    .child(addId);

                                final UploadTask task = firebaseStorageRef
                                    .putFile(selectedImage!);

                                var downloadUrl = await (await task).ref
                                    .getDownloadURL();

                                Map<String, dynamic> addPost = {
                                  "place": placeController.text,
                                  "city": cityController.text,
                                  "caption": captionController.text,
                                  "img": downloadUrl.toString(),
                                };
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Post',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
