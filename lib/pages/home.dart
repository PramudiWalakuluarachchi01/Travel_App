import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/add_page.dart';
import 'package:travel_app/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? postStream;

  getontheload() async {
    postStream = await DatabaseMethods().getPosts();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allPosts() {
    return StreamBuilder(
      stream: postStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(left: 30.0, right: 35.0),

                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                left: 10.0,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.network(
                                      ds["UserImage"],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    ds["UserName"],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Karla',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Image.network(ds["Image"] ! null
                            ? Image.network( ds["Image"],
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,)),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue),
                                  Text(
                                    ds["Place"] + ", " + ds["City"],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Karla',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                               ds["Caption"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Karla',
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.comment_outlined),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/img01.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  color: Colors.black.withOpacity(0.65),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset(
                          "assets/images/world_location.png",
                          height: 30,
                          width: 30,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPage(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 15),

                      Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(60),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            "assets/images/boy.jpg",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 110.0, left: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "Travelers",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Caveat',
                        ),
                      ),
                      const SizedBox(height: 1.0),

                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          "Travel  Community App",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 209, 206, 206),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Karla',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    top: MediaQuery.of(context).size.height / 3.3,
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search for places",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            allPosts(),
          ],
        ),
      ),
    );
  }
}
