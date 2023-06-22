import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Componets/ItemTile.dart';

class Individual2 extends StatelessWidget {
  final fireStore = FirebaseFirestore.instance;
  Individual2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[600],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 25.h,
            // ),

            const Divider(thickness: 1.5),
            Padding(
              padding: EdgeInsets.only(left: 10.w, bottom: 5.h, top: 5.h),
              child: Text(
                "Sculpture",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: StreamBuilder<QuerySnapshot>(
                    stream:
                        fireStore.collection("AvailableSculptures").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        var snap = snapshot.data!.docs;
                        return GridView.builder(
                          itemCount: snap.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 50.w),
                              child: ItemTile(
                                docId:
                                    snapshot.data?.docs[index].reference.id ??
                                        '',
                                itemName: snap[index]["Name"],
                                itemPrice: snap[index]["Price"].toString(),
                                imagePath: snap[index]["Image"],
                                place: snap[index]["Place"],
                                description: snap[index]["Description"],
                                color: Colors.grey[50],
                                collection: 'AvailableSculptures',
                              ),
                            );
                          },
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                          ),
                        );
                      }
                    }),
              ),
            ),
          ],
        ));
  }
}
