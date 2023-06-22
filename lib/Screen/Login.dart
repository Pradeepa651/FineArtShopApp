import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fine_art_shop/ResuableWidgets/InputField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fine_art_shop/Constant/Constant.dart';
import 'package:provider/provider.dart';

import '../Componets/Database.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final auth = FirebaseAuth.instance;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context, child) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 52.h,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: darkTextColor,
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "You don't  have account?",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: lightTextColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: purpleColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      InputField(
                        hinText: "Email-id",
                        textEdithControler: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      InputField(
                        hinText: "Password",
                        textEdithControler: passwordTextController,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await auth.signInWithEmailAndPassword(
                                  email: emailTextController.text.trim(),
                                  password: passwordTextController.text.trim());
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (route) => false,
                              );
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // print(database.CartListItemName);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(purpleColor),
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 14.h)),
                            textStyle: MaterialStatePropertyAll(
                              TextStyle().copyWith(
                                  fontSize: 16.sp, fontWeight: FontWeight.w700),
                            ),
                          ),
                          child: const Text(
                            "Login",
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotpassword');
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: purpleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
      create: (context) => DataBase(),
    );
  }
}
