import 'package:flutter/material.dart';
import 'package:tobetoappv1/screens/evaluation.dart';
import 'package:tobetoappv1/screens/profil.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade900,
                        Colors.purple,
                        Colors.white
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      tileMode: TileMode.mirror)),
              width: screenWidth,
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Profilini Oluştur",
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const ProfilePage()));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 34),
                          backgroundColor:
                          const Color.fromRGBO(103, 82, 195, 1)),
                      child: const Text(
                        "Başla",
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade900,
                        Colors.purple,
                        Colors.blueAccent
                      ],
                      transform: const GradientRotation(15),
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft)),
              width: screenWidth,
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Kendini Değerlendir",
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const Evaluation()));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 34),
                          backgroundColor:
                          const Color.fromRGBO(103, 82, 195, 1)),
                      child: const Text(
                        "Başla",
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 103, 255, 174),
                        Colors.purple,
                        Colors.blue
                      ],
                      transform: GradientRotation(15),
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft)),
              width: screenWidth,
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Öğrenmeye Başla",
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 34),
                          backgroundColor:
                          const Color.fromRGBO(103, 82, 195, 1)),
                      child: const Text(
                        "Başla",
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}