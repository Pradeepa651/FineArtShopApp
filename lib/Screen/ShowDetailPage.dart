import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Payment/RazorPayment.dart';

class ShowDetails extends StatelessWidget {
  final name;
  final price;
  final place;
  final image;
  final description;
  final docid;
  final collection;

  const ShowDetails(
      {super.key,
      required this.name,
      required this.price,
      required this.place,
      required this.image,
      required this.description,
      required this.docid,
      required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5.h),
              margin: EdgeInsets.only(bottom: 5.h),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[300],
              child: Hero(
                tag: this.name,
                child: AspectRatio(
                  child: Image.network(
                    image,
                  ),
                  aspectRatio: 13 / 11,
                ),
              ),
              // padding: EdgeInsets.all(5.r),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20.w, height: 35.h),
                Text(
                  "Price:",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                ),
                Text(
                  "Place:",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  place,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200.h,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Text(
                  description,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 15.sp, backgroundColor: Colors.grey[200]),
                ),
              ),
            ),
            SizedBox(
              width: 200.w,
              height: 30.h,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RazorPay(
                          image: this.image,
                          itemName: this.name,
                          amount: this.price,
                          collection: this.collection,
                          docId: this.docid,
                        ),
                      ),
                    );
                  },
                  style: const ButtonStyle(
                      textStyle: MaterialStatePropertyAll(
                          TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: MaterialStatePropertyAll(Colors.brown)),
                  child: const Text("Order")),
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}
