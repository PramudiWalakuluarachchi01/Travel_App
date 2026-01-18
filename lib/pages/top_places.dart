import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/post_places.dart' as post_places;
import 'package:travel_app/services/database.dart';

class TopPlaces extends StatelessWidget {
  const TopPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Places"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: DatabaseMethods().getPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // Extract unique cities and one post per city for image
            Set<String> cities = {};
            List<DocumentSnapshot> cityPosts = [];

            for (var ds in snapshot.data!.docs) {
              try {
                String city = ds.get("City") ?? "";
                if (city.isNotEmpty && !cities.contains(city)) {
                  cities.add(city);
                  cityPosts.add(ds); // store one post per city for image
                }
              } catch (e) {}
            }

            if (cityPosts.isEmpty) {
              return const Center(child: Text("No places yet"));
            }

            return GridView.builder(
              itemCount: cityPosts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                var ds = cityPosts[index];

                String cityName = "";
                String postImage = "";

                try {
                  cityName = ds.get("City") ?? "";
                } catch (e) {}

                try {
                  postImage = ds.get("Image") ?? "";
                } catch (e) {}

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            post_places.PostPlaces(cityName: cityName),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: postImage.isNotEmpty
                            ? Image.network(
                                postImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Container(
                                color: Colors.grey[300],
                                width: double.infinity,
                                height: double.infinity,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
                              ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Text(
                          cityName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
