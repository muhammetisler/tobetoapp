import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoappv1/blocs/auth_bloc/auth_bloc.dart';
import 'package:tobetoappv1/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:tobetoappv1/firebase_options.dart';
import 'package:tobetoappv1/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:tobetoappv1/screens/loginpage.dart';
import 'package:tobetoappv1/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      BlocProvider<CatalogBloc>(create: (context) => CatalogBloc())
    ],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tobeto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (_user != null && _user!.emailVerified) {
              return const LoginPage();
            }
            return const LoginPage();
          }),
    );

  }
}