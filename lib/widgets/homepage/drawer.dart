import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobetoappv1/constants/constants_firebase.dart';
import 'package:tobetoappv1/datas/datas.dart';
import 'package:tobetoappv1/screens/calendar_firebase.dart';
import 'package:tobetoappv1/screens/catalog.dart';
import 'package:tobetoappv1/screens/catalog_firebase.dart';
import 'package:tobetoappv1/screens/educator_screen.dart';
import 'package:tobetoappv1/screens/evaluation.dart';
import 'package:tobetoappv1/screens/homepage.dart';
import 'package:tobetoappv1/screens/loginpage.dart';
import 'package:tobetoappv1/screens/profil.dart';
import 'package:tobetoappv1/widgets/profile/profile_edit/personal_edit.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String _name = '';
  String _surname = '';
  String userName = "Kullanıcı Adı";
  String _imageUrl = "";
  String? userRole;

  final firebaseAuthInstance = FirebaseAuth.instance;
  final firebaseFireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final user = firebaseAuthInstance.currentUser;
    final document =
        firebaseFireStore.collection(ConstanstFirebase.USERS).doc(user!.uid);
    final documentSnapshot = await document.get();
    var profileCollectionRef = document
        .collection(ConstanstFirebase.PROFILE)
        .doc(ConstanstFirebase.PERSONAL);
    var querySnapshot = await profileCollectionRef.get();

    if (mounted) {
      if (documentSnapshot.exists && querySnapshot.exists) {
        setState(() {
          _name = querySnapshot.get("name");
          _surname = querySnapshot.get("surname");
          userRole = querySnapshot.get("userRole");
          if (querySnapshot.exists) {
            _imageUrl = querySnapshot.get("imageUrl");
          }

          if (_name.isNotEmpty) {
            userName = "$_name $_surname";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    String imageName = currentBrightness == Brightness.light
        ? 'assets/images/tobeto_logo.png'
        : 'assets/images/tobeto_logo_d.png';

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 25),
        children: [
          Row(
            children: [
              Image.asset(
                imageName,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              title: const Text("Anasayfa"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const HomepageScreen()));
              },
              leading: const Icon(Icons.home_outlined)),
          ListTile(
            title: const Text("Değerlendirmeler"),
            leading: const Icon(Icons.assignment_turned_in_outlined),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const Evaluation()));
            },
          ),
          ListTile(
            title: const Text("Profilim"),
            leading: const Icon(Icons.person_outlined),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ProfilePage()));
            },
          ),
          if (userRole == '1')
            ListTile(
              title: const Text("Eğitimci Sayfası"),
              leading: const Icon(Icons.list_outlined),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const EducatorScreen()));
              },
            ),
          ListTile(
            title: const Text("Katalog"),
            leading: const Icon(Icons.list_outlined),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const Catalog()));
            },
          ),
          ListTile(
            title: const Text("Takvim"),
            leading: const Icon(Icons.date_range),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => CalendarFirebase(
                        educators: educators,
                      )));
            },
          ),
          const Divider(),
          const ListTile(
            title: Text("Tobeto"),
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/iconlogo.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              color: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    _imageUrl.isEmpty
                        ? ClipOval(
                            child: Image.asset(
                              'assets/images/ic_user.png',
                              width: 40.0,
                              height: 40.0,
                            ),
                          )
                        : ClipOval(
                            child: Image.network(
                              _imageUrl,
                              width: 40.0,
                              height: 40.0,
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
          ListTile(
              title: const Text(
                "Çıkış Yap",
              ),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                } catch (e) {
                  print('Error: $e');
                  // Hata durumunda kullanıcıya bilgi verebilirsiniz
                }
              },
              leading: const Icon(Icons.exit_to_app)),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text("© 2022 Tobeto"),
          ),
        ],
      ),
    );
  }
}
