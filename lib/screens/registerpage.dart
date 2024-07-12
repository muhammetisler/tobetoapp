import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoappv1/blocs/auth_bloc/auth_bloc.dart';
import 'package:tobetoappv1/blocs/auth_bloc/auth_state.dart';
import 'package:tobetoappv1/constants/constants_firebase.dart';
import 'package:tobetoappv1/screens/check_email_verification.dart';
import 'package:tobetoappv1/screens/homepage.dart';
import 'package:tobetoappv1/screens/loginpage.dart';
import 'package:tobetoappv1/theme/app_color.dart';

class NoSpecialCharactersFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regex = RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]*$');
    if (regex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  showSnackBarFun(BuildContext context, String mesaj) {
    SnackBar snackBar = SnackBar(
      content: Text(
        mesaj,
        style: TextStyle(fontSize: 18),
      ),
      backgroundColor: Colors.indigo,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 200,
        left: 10,
        right: 10,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _password2 = '';
  String _name = '';
  String _surname = '';
  DateTime? _birthDate;
  bool _isAuth = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebaseAuthInstance = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _register() async {
    if (_email.isEmpty ||
        _password.isEmpty ||
        _password2.isEmpty ||
        _name.isEmpty ||
        _surname.isEmpty ||
        _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen eksik alanları giriniz")));
    } else {
      if (_password == _password2) {
        try {
          final userCredentials =
          await firebaseAuthInstance.createUserWithEmailAndPassword(
              email: _email, password: _password);
          print(userCredentials);
          firebaseFirestore
              .collection(ConstanstFirebase.USERS)
              .doc(userCredentials.user!.uid)
              .set({
            "uid": userCredentials.user!.uid,
          });
          firebaseFirestore
              .collection(ConstanstFirebase.USERS)
              .doc(userCredentials.user!.uid)
              .collection(ConstanstFirebase.PROFILE)
              .doc(ConstanstFirebase.PERSONAL)
              .set({
            "uid": userCredentials.user!.uid,
            "imageUrl": "",
            "name": _name,
            "surname": _surname,
            "phoneNumber": "",
            "birthDate": _birthDate,
            "tc": "",
            'email': _email,
            "country": "",
            "city": "",
            "district": "",
            "street": "",
            "aboutMe": "",
            "userRole": "0",
          });
          User? user = userCredentials.user;
          if (user != null && !user.emailVerified) {
            await user.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Aktivasyon Emaili gönderildi!')),
            );
          }
        } on FirebaseAuthException catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.message ?? "Kayıt başarısız.")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Parola eşleşmiyor")));
      }
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    String imageName = currentBrightness == Brightness.light
        ? 'assets/images/tobeto_logo.png'
        : 'assets/images/tobeto_logo_d.png';
    String backgroundLogin = currentBrightness == Brightness.light
        ? "assets/images/appbg.jpg"
        : 'assets/images/appbg.jpg';
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
        backgroundColor: (AppColorDark.elevatedButtonColor),
        minimumSize: const Size(290, 40));

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CheckEmailVerificationScreen()),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundLogin),
                fit: BoxFit.cover,
              )),
          child: Center(
            child: SizedBox(
              child: SizedBox(
                width: 400,
                height: 650,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Image.asset(imageName),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: TextField(
                            onChanged: (value) => _name = value,
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            inputFormatters: [NoSpecialCharactersFormatter()],
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                Theme.of(context).colorScheme.background,
                                labelText: "Adınız",
                                hintStyle:
                                const TextStyle(fontFamily: "Poppins"),
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: TextField(
                            onChanged: (value) => _surname = value,
                            controller: _surnameController,
                            keyboardType: TextInputType.name,
                            inputFormatters: [NoSpecialCharactersFormatter()],
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                Theme.of(context).colorScheme.background,
                                labelText: "Soyadınız",
                                hintStyle:
                                const TextStyle(fontFamily: "Poppins"),
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: TextEditingController(
                              text: _birthDate == null
                                  ? ''
                                  : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                              Theme.of(context).colorScheme.background,
                              labelText: "Doğum Tarihi",
                              hintStyle: const TextStyle(fontFamily: "Poppins"),
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: TextField(
                            onChanged: (value) => _email = value,
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                Theme.of(context).colorScheme.background,
                                labelText: "Email giriniz",
                                hintStyle:
                                const TextStyle(fontFamily: "Poppins"),
                                prefixIcon: const Icon(Icons.email),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              onChanged: (value) => _password = value,
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                  Theme.of(context).colorScheme.background,
                                  labelText: "Parola giriniz",
                                  hintStyle:
                                  const TextStyle(fontFamily: "Poppins"),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordVisible =
                                        !_isPasswordVisible;
                                      });
                                    },
                                    child: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              onChanged: (value) => _password2 = value,
                              controller: _passwordController2,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                  Theme.of(context).colorScheme.background,
                                  labelText: "Parolayı tekrar giriniz",
                                  hintStyle:
                                  const TextStyle(fontFamily: "Poppins"),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordVisible =
                                        !_isPasswordVisible;
                                      });
                                    },
                                    child: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),

                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          _register();
                        },
                        child: Text(
                          "KAYIT OL",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontFamily: "Poppins"),
                        ),
                      ),
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const LoginPage()));
                        },
                        child: const Text(
                          "GİRİŞ YAP",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Poppins"),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Çizgi
                          Container(
                            height: 2.0,
                            width: 90.0,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                  colors: [
                                    Colors.black26,
                                    Colors.white,
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
