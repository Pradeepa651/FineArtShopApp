import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryCartDesign extends StatelessWidget {
  DeliveryCartDesign({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
  }) : super(key: key);
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(color: Color(0xff9598AF), spreadRadius: 1),
        ],
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 12 / 10,
            child: Image.network(
              imagePath,
            ),
          ),
          Text(
            itemName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
            // softWrap: true,
            softWrap: true, textAlign: TextAlign.center,
          ),
          Text(
            itemPrice,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
