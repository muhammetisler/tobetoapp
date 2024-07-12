import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckEmailVerificationScreen extends StatefulWidget {
  @override
  _CheckEmailVerificationScreenState createState() => _CheckEmailVerificationScreenState();
}

class _CheckEmailVerificationScreenState extends State<CheckEmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    await _user?.reload();
    if (_user != null && _user!.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email onaylandı!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email henüz onaylanmadı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('E-posta Doğrulamasını Kontrol Edin')),
      body: Center(
        child: Text('E-posta Doğrulaması Kontrol Ediliyor...'),
      ),
    );
  }
}
