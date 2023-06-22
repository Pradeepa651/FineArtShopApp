import 'package:fine_art_shop/Componets/Database.dart';
import 'package:fine_art_shop/Screen/Login.dart';
import 'package:fine_art_shop/Screen/ResetPassword.dart';
import 'package:fine_art_shop/Screen/UserDetailEdit.dart';
import 'package:fine_art_shop/Screen/SpecificScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Screen/Cart.dart';
import 'Screen/Paints.dart';
import 'Screen/ProfileScreen.dart';
import 'Screen/Sculpture.dart';
import 'Screen/SignUp.dart';
import 'Screen/StartScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fine_art_shop/Screen/ForgotPassword.dart';
import 'package:fine_art_shop/Screen/home.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.brown,
                ),
              ),
            );
          } else {
            return ScreenUtilInit(
                designSize: Size(360, 640),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (_) => DataBase())
                    ],
                    child: MaterialApp(
                      title: 'Fine Art Shop App',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                          scaffoldBackgroundColor: Colors.grey[100],
                          appBarTheme: AppBarTheme(
                            backgroundColor: Colors.brown[600],
                          )),
                      initialRoute: '/',
                      routes: {
                        '/': (context) => const MainPage(),
                        '/signup': (context) => SignUp(),
                        '/login': (context) => Login(),
                        '/forgotpassword': (context) => ForgotPassword(),
                        '/resetpassword': (context) => ResetPassword(),
                        '/home': (context) => const Home(),
                        '/specificscreen': (context) => SpecificScreen(),
                        '/individual': (context) => Individual(),
                        '/individual2': (context) => Individual2(),
                        '/cart': (context) => const Cart(),
                        '/showscreen': (context) => Show(),
                        '/profile': (context) => ProfileScreen(),
                      },
                    ),
                  );
                });
          }
        });
  }
}
