import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tobetoappv1/constants/constants_firebase.dart';
import 'package:tobetoappv1/datas/datas.dart';
import 'package:tobetoappv1/models/profile_edit.dart';
import 'package:tobetoappv1/screens/homepage.dart';

class LanguageEdit extends StatefulWidget {
  const LanguageEdit({Key? key}) : super(key: key);

  @override
  _LanguageEditState createState() => _LanguageEditState();
}

class _LanguageEditState extends State<LanguageEdit> {
  final firebaseAuthInstance = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  DateTime? date;

  void _submitlanguage() async {
    final user = firebaseAuthInstance.currentUser;
    final document =
    firebaseFireStore.collection(ConstanstFirebase.USERS).doc(user!.uid);

    date = DateTime.now();
    try {
      final languageSnapshot = await document
          .collection(ConstanstFirebase.LANGUAGES)
          .where('language', isEqualTo: selectedlanguage?.language)
          .get();

      if (languageSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Bu dil zaten eklenmiş!'),
        ));
      } else {
        document.collection(ConstanstFirebase.LANGUAGES).doc().set({
          'language': selectedlanguage?.language,
          'date': date,
          'level': selectedlevel?.level,
        });
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  Language? selectedlanguage;
  Language? selectedlang;
  Level? selectedlevel;
  bool isLanguage = false;
  bool isLevel = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              DropdownButtonFormField2<Language>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: "Dil Seçiniz*",
                  hintStyle: const TextStyle(fontFamily: "Poppins"),
                ),
                value: selectedlanguage,
                onChanged: (Language? language) {
                  if (language != null) {
                    setState(() {
                      selectedlanguage = language;
                      isLanguage = true;
                    });
                  }
                },
                items: languages.map((Language language) {
                  return DropdownMenuItem<Language>(
                    enabled: true,
                    value: language,
                    child: Text(
                      language.language,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  );
                }).toList(),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  direction: DropdownDirection.left,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField2<Level>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: "Seviye Seçiniz*",
                  hintStyle: const TextStyle(fontFamily: "Poppins"),
                ),
                value: selectedlevel,
                onChanged: (Level? level) {
                  if (level != null) {
                    setState(() {
                      selectedlevel = level;
                      isLevel = true;
                    });
                  }
                },
                items: levels.map((Level level) {
                  return DropdownMenuItem<Level>(
                    enabled: true,
                    value: level,
                    child: Text(
                      level.level,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  );
                }).toList(),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  direction: DropdownDirection.left,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (isLevel && isLanguage) {
                      _submitlanguage();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Lütfen eksik alanları seçiniz")));
                    }
                  },
                  child: const Text("Kaydet"))
            ],
          ),
        ),
      ),
    );
  }
}