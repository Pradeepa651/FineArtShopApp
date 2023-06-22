import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fine_art_shop/Screen/Login.dart';
import 'package:fine_art_shop/Screen/home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something has a error"),
            );
          } else if (snapshot.hasData) {
            return const Home();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
