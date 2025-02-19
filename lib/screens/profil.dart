import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tobetoappv1/constants/constants_firebase.dart';
import 'package:tobetoappv1/models/profile_edit.dart';
import 'package:tobetoappv1/screens/homepage.dart';
import 'package:tobetoappv1/widgets/profile/profile_homepage/background_sliver.dart';
import 'package:tobetoappv1/widgets/profile/profile_homepage/body_sliver.dart';
import 'package:tobetoappv1/widgets/profile/profile_homepage/button_back.dart';
import 'package:tobetoappv1/widgets/profile/profile_homepage/cover_photo.dart';
import 'package:tobetoappv1/widgets/profile/profile_homepage/cut_rectangle.dart';
import 'package:tobetoappv1/widgets/profile/profile_homepage/data_cut_rectangle.dart';
import 'package:tobetoappv1/widgets/profile/profile_homepage/edit_circle_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime? selectedDate;
  Province? selectedprovince;
  String _imageUrl = "";
  String _name = "";
  String _surname = "";
  String _phoneNumber = "";
  Timestamp? _birthDate;
  String _birthDateString = "";
  String _tc = "";
  String _email = "";
  String _country = "";
  String _city = "";
  String _district = "";
  String _street = "";
  String _aboutMe = "";
  String _userRole = "";

  String userName = "Kullanıcı Adı";

  final firebaseAuthInstance = FirebaseAuth.instance;

  final firebaseFireStore = FirebaseFirestore.instance;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde bu fonksiyon çağrılır
    _getUserInfo();
  }

  void _getUserInfo() async {
    setState(() {
      _isLoading =
      true; // Set loading state to true when starting data fetching
    });
    final user = firebaseAuthInstance.currentUser;
    final document = firebaseFireStore.collection(ConstanstFirebase.USERS).doc(user!.uid);
    final documentSnapshot = await document.get();
    var profileCollectionRef = document.collection(ConstanstFirebase.PROFILE).doc(ConstanstFirebase.PERSONAL);
    var querySnapshot = await profileCollectionRef.get();
    if (!querySnapshot.exists) {
      setState(() {
        _isLoading =
        false;
      });
    }


    String formatTimestamp(Timestamp timestamp, String format) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat(format).format(dateTime);
    }

    if (mounted) {
      if (documentSnapshot.exists && querySnapshot.exists) {
        setState(() {
          _isLoading = false;
          _name = querySnapshot.get("name");
          _surname = querySnapshot.get("surname");
          _imageUrl = querySnapshot.get("imageUrl");
          _phoneNumber = querySnapshot.get("phoneNumber");
          _birthDate = querySnapshot.get("birthDate");
          _birthDateString =
              formatTimestamp(querySnapshot.get("birthDate"), 'yyyy-MM-dd');
          _tc = querySnapshot.get("tc");
          _email = querySnapshot.get("email");
          _country = querySnapshot.get("country");
          _city = querySnapshot.get("city");
          _district = querySnapshot.get("district");
          _street = querySnapshot.get("street");
          _aboutMe = querySnapshot.get("aboutMe");
          _userRole = querySnapshot.get("userRole");

          print(_imageUrl);
          print(_tc);
          print(_email);
          print(_aboutMe);
          print(_userRole);

          if (_name.isNotEmpty) {
            userName = "$_name $_surname";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? const Center(
        child:
        CircularProgressIndicator(), // Show CircularProgressIndicator while loading
      )
          : CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _AppBarNetflix(
                minExtended: kToolbarHeight,
                maxExtended: size.height * 0.32,
                size: size,
                imageUrl: _imageUrl,
                name: _name,
                surname: _surname,
                phoneNumber: _phoneNumber,
                birthDate: _birthDateString,
                email: _email),
          ),
          SliverToBoxAdapter(
            child: Body(
              size: size,
              aboutMe: _aboutMe,
            ),
          )
        ],
      ),
    );
  }
}

class _AppBarNetflix extends SliverPersistentHeaderDelegate {
  const _AppBarNetflix({
    required this.maxExtended,
    required this.minExtended,
    required this.size,
    required this.imageUrl,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.birthDate,
    required this.email,
  });
  final double maxExtended;
  final double minExtended;
  final Size size;
  final String imageUrl;
  final String name;
  final String surname;

  final String phoneNumber;
  final String birthDate;
  final String email;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxExtended;
    //validate the angle at which the card returns
    const uploadlimit = 13 / 100;
    //return value of the card
    final valueback = (1 - percent - 0.77).clamp(0, uploadlimit);
    final fixrotation = pow(percent, 1.5);

    final card = _CoverCard(
      size: size,
      percent: percent,
      uploadlimit: uploadlimit,
      valueback: valueback,
      imageUrl: imageUrl,
    );

    final bottomsliverbar = _CustomBottomSliverBar(
        size: size,
        fixrotation: fixrotation,
        percent: percent,
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
        email: email);

    return Stack(
      children: [
        const BackgroundSliver(),
        if (percent > uploadlimit) ...[
          card,
          bottomsliverbar,
        ] else ...[
          bottomsliverbar,
          card,
        ],
        ButtonBack(
          size: size,
          percent: percent,
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const HomepageScreen())),
        ),
        EditCircleButton(size: size, percent: percent)
      ],
    );
  }

  @override
  double get maxExtent => maxExtended;

  @override
  double get minExtent => minExtended;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _CoverCard extends StatelessWidget {
  const _CoverCard(
      {Key? key,
        required this.size,
        required this.percent,
        required this.uploadlimit,
        required this.valueback,
        required this.imageUrl})
      : super(key: key);
  final Size size;
  final double percent;
  final double uploadlimit;
  final num valueback;
  final String imageUrl;

  final double angleForCard = 6.5;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.15,
      left: size.width / 24,
      child: Transform(
        alignment: Alignment.topRight,
        transform: Matrix4.identity()
          ..rotateZ(percent > uploadlimit
              ? (valueback * angleForCard)
              : percent * angleForCard),
        child: CoverPhoto(
          size: size,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}

class _CustomBottomSliverBar extends StatelessWidget {
  const _CustomBottomSliverBar({
    Key? key,
    required this.size,
    required this.fixrotation,
    required this.percent,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.birthDate,
    required this.email,
  }) : super(key: key);
  final Size size;
  final num fixrotation;
  final double percent;
  final String name;
  final String surname;

  final String phoneNumber;
  final String birthDate;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: -size.width * fixrotation.clamp(0, 0.35),
        right: 0,
        child: _CustomBottomSliver(
            size: size,
            percent: percent,
            name: name,
            surname: surname,
            phoneNumber: phoneNumber,
            birthDate: birthDate,
            email: email));
  }
}

class _CustomBottomSliver extends StatelessWidget {
  const _CustomBottomSliver({
    Key? key,
    required this.size,
    required this.percent,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.birthDate,
    required this.email,
  }) : super(key: key);

  final Size size;
  final double percent;
  final String name;
  final String surname;

  final String phoneNumber;
  final String birthDate;
  final String email;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.12,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: CutRectangle(),
          ),
          DataCutRectangle(
              size: size,
              percent: percent,
              name: name,
              surname: surname,
              phoneNumber: phoneNumber,
              birthDate: birthDate,
              email: email)
        ],
      ),
    );
  }
}