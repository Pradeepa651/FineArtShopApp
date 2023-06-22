import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fine_art_shop/ResuableWidgets/InputField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fine_art_shop/Constant/Constant.dart';

class ForgotPassword extends StatelessWidget {
  final emailTextController = TextEditingController();
  final auth = FirebaseAuth.instance;

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 52.h,
              // ),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: darkTextColor,
                ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await auth.sendPasswordResetEmail(
                          email: emailTextController.text.trim());
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("link sended to email"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );

                      var snackBar = const SnackBar(
                        content: Text("link sended to email"),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    } on FirebaseAuthException catch (e) {
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
                      var snackBar = SnackBar(
                        content: Text(emailTextController.text != ""
                            ? e.message.toString()
                            : "Enter email-id"),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(purpleColor),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 14.h)),
                    textStyle: MaterialStatePropertyAll(
                      const TextStyle().copyWith(
                          fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  child: const Text(
                    "Send a link to mail",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
