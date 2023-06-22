import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fine_art_shop/Constant/Constant.dart';
import 'package:fine_art_shop/ResuableWidgets/InputField.dart';
import 'package:fine_art_shop/googlelogin.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final auth = FirebaseAuth.instance;
  FirebaseFirestore userDetail = FirebaseFirestore.instance;
  final firstName = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final reEnteredPasswordTextController = TextEditingController();
  @override
  void dispose() {
    reEnteredPasswordTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print('$width \n$height');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52.h,
                  ),
                  Text(
                    "Sign Up",
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
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: lightTextColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          "Login",
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
                    textEdithControler: firstName,
                    hinText: "Fist Name",
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(
                    height: 16.h,
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
                      hinText: "Enter Password",
                      textEdithControler: passwordTextController),
                  SizedBox(
                    height: 16.h,
                  ),
                  InputField(
                    hinText: "Re-enter Password",
                    textEdithControler: reEnteredPasswordTextController,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: const CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                ));
                        try {
                          await auth.createUserWithEmailAndPassword(
                              email: emailTextController.text.trim(),
                              password: passwordTextController.text.trim());
                          auth.currentUser?.updateDisplayName(firstName.text);
                          final user = <String, dynamic>{
                            "Name": firstName.text.trim(),
                            "Email": emailTextController.text.trim()
                          };
                          userDetail
                              .collection('User')
                              .doc(auth.currentUser?.uid)
                              .set(user);

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
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(purpleColor),
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 14.h)),
                        textStyle: MaterialStatePropertyAll(
                          const TextStyle().copyWith(
                              fontSize: 14.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      child: const Text(
                        "Create Account",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Text(
                        "or Sign Up via",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: lightTextColor,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      const Expanded(
                        child: Divider(thickness: 2),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        try {
                          var authg = await Authservice().signInWithGoogle();
                          if (authg.user!.emailVerified) {
                            userDetail
                                .collection("User")
                                .doc(authg.user?.uid)
                                .set(
                              {
                                "Name": auth.currentUser?.displayName,
                                "Email": auth.currentUser?.email,
                                "phoneNumber": auth.currentUser?.phoneNumber,
                                "photoUrl": auth.currentUser!.photoURL
                              },
                            );

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );

                            print(authg.user);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(darkTextColor),
                        side: MaterialStatePropertyAll(BorderSide(
                          color: borderColor,
                        )),
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 14.h)),
                        textStyle: MaterialStatePropertyAll(
                          const TextStyle().copyWith(
                              fontSize: 14.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FontAwesomeIcons.google,
                              color: Colors.green),
                          SizedBox(
                            width: 16.h,
                          ),
                          const Text(
                            "Create Account",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "By Signing up to Fine Art Shop you agree to our",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: lightTextColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "term and conditions",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: purpleColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
