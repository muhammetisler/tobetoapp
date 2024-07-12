import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tobetoappv1/constants/constants_firebase.dart';
import 'package:tobetoappv1/theme/app_color.dart';

import 'educator_screen.dart';
import 'homepage.dart';
import 'registerpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isPasswordVisible = false;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar('Lütfen kullanıcı adı ve şifre giriniz!');
      return;
    }

    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        final userRole = await getUserRole(user.uid);
        if (userRole == "1") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EducatorScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomepageScreen()),
          );
        }
      } else if (user != null) {
        showSnackBar('Email henüz onaylanmadı.');
      }
    } catch (e) {
      showSnackBar('Error: $e');
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      final document = FirebaseFirestore.instance
          .collection(ConstanstFirebase.USERS)
          .doc(uid);
      var profileCollectionRef = document
          .collection(ConstanstFirebase.PROFILE)
          .doc(ConstanstFirebase.PERSONAL);
      var querySnapshot = await profileCollectionRef.get();
      return querySnapshot.data()?['userRole'] as String?;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // Kullanıcı Google oturum açmayı iptal etti.
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
      await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } catch (error) {
      showSnackBar('Error: $error');
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar("Parola sıfırlama maili mail adresinize gönderildi.");
    } catch (e) {
      showSnackBar("Parola sıfırlama sırasında bir hata oluştu.");
    }
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
      backgroundColor: AppColorDark.elevatedButtonColor,
      minimumSize: const Size(160, 40),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundLogin),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 400,
            height: 485,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  child: Image.asset(imageName),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        labelText: "Kullanıcı adı",
                        hintStyle: const TextStyle(fontFamily: "Poppins"),
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        labelText: "Parola giriniz",
                        hintStyle: const TextStyle(fontFamily: "Poppins"),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                              child: Container(
                                height: 150,
                                color: Theme.of(context).colorScheme.background,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'E-posta Adresi',
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          resetPassword(_emailController.text);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Şifremi Sıfırla'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Parolamı Unuttum',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.33,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: _submit,
                      child: const Text(
                        "GİRİŞ YAP",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const RegisterPage()));
                      },
                      child: const Text(
                        "KAYIT OL",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ],
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
                          colors: <Color>[
                            Colors.grey,
                            Color.fromARGB(255, 229, 237, 238),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        'veya',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      height: 2.0,
                      width: 90.0,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(255, 229, 237, 238),
                            Colors.grey,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(160, 40),
                  ),
                  onPressed: () async {
                    final user = await _signInWithGoogle();
                    if (user != null) {
                      final userRole = await getUserRole(user.uid);
                      if (userRole == "1") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EducatorScreen()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomepageScreen()),
                        );
                      }
                    }
                  },
                  icon: Image.asset(
                    'assets/images/gologo.png',
                    height: 20,
                    width: 20,
                  ),
                  label: const Text(
                    'Google ile Giriş Yap',
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
