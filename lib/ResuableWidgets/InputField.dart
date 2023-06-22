import 'package:flutter/material.dart';
import 'package:fine_art_shop/Constant/Constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {
  final textEdithControler;
  final keyboardType;
  InputField(
      {super.key,
      required this.hinText,
      this.textEdithControler,
      this.keyboardType});

  final String hinText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEdithControler,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        filled: true,
        fillColor: textFieldColor,
        hintText: hinText,
        hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
      ),
    );
  }
}
