import 'package:flutter/material.dart';

class SurveyCard extends StatelessWidget {
  const SurveyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          children: [
            Image.asset(
              "assets/images/surveyError.png",
              height: 180,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:
              Text("Atanmış herhangi bir anketiniz bulunmamaktadır."),
            )
          ],
        ),
      ),
    );
  }
}