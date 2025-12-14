import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/img01.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Image.asset("assets/images/boy.jpg",height: 50, width: 50,fit:BoxFit.cover ,),
                 )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
