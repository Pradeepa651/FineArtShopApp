import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../Componets/AllCategory.dart';

class SpecificScreen extends StatefulWidget {
  SpecificScreen({Key? key}) : super(key: key);

  @override
  State<SpecificScreen> createState() => _SpecificScreenState();
}

class _SpecificScreenState extends State<SpecificScreen> {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    int l1 = 0, l2 = 0;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[600],
          title: const Text("All"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 25.h,
              // ),
              Padding(
                padding: EdgeInsets.only(top: 25.h, left: 10.w),
                child: Text(
                  "Recommended",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              Container(
                color: Colors.grey[300],
                height: 200.h,
                child: StreamBuilder2<QuerySnapshot, QuerySnapshot>(
                  streams: StreamTuple2(
                      firestore
                          .collection("AvialablePaints")
                          .orderBy("Heart", descending: true)
                          .limit(5)
                          .snapshots(),
                      firestore
                          .collection("AvailableSculptures")
                          .orderBy("Heart", descending: true)
                          .limit(4)
                          .snapshots()),
                  builder: (context, snapshots) {
                    if (snapshots.snapshot1.connectionState ==
                            ConnectionState.waiting ||
                        snapshots.snapshot2.connectionState ==
                            ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshots.snapshot1.hasError ||
                        snapshots.snapshot1.hasError) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshots.snapshot1.hasData ||
                        !snapshots.snapshot1.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var list1 = snapshots.snapshot1.data!.docs;
                      var list2 = snapshots.snapshot2.data!.docs;

                      int i = 0, j = 0;
                      List list = [];
                      while (i < list1.length && j < list2.length) {
                        if (list1[l1]['Heart'] > list2[l2]['Heart']) {
                          list.add(list1[i++]);
                        } else {
                          list.add(list2[j++]);
                        }
                      }
                      while (i < list1.length) {
                        list.add(list1[i++]);
                      }
                      while (j < list2.length) {
                        list.add(list1[j++]);
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return SizedBox(
                            width: 150.w,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              child: ItemTileSmall(
                                itemName: list[index]["Name"] ?? "",
                                itemPrice: list[index]["Heart"].toString(),
                                imagePath: list[index]["Image"] ?? "",
                                color: Colors.grey[50],
                                description: list[index]["Description"] ?? "",
                                place: list[index]["Place"] ?? "",
                                docId: list[index].id,
                                collection: list[index].reference.parent.path,
                              ),
                            ),
                          );
                        },
                        itemCount: list1.length + list2.length,
                      );
                    }
                  },
                ),
              ),
              const Divider(thickness: 1.5),
              Padding(
                padding: EdgeInsets.only(left: 10.w, bottom: 5.h, top: 5.h),
                child: Text(
                  "New",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              Container(
                height: 200.h,
                // width: 180.w,
                color: Colors.grey[300],
                child: StreamBuilder2<QuerySnapshot, QuerySnapshot>(
                  streams: StreamTuple2(
                      firestore
                          .collection("AvialablePaints")
                          .orderBy("Time", descending: true)
                          .limit(5)
                          .snapshots(),
                      firestore
                          .collection("AvailableSculptures")
                          .orderBy("Time", descending: true)
                          .limit(4)
                          .snapshots()),
                  builder: (context, snapshots) {
                    if (snapshots.snapshot1.connectionState ==
                            ConnectionState.waiting ||
                        snapshots.snapshot2.connectionState ==
                            ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshots.snapshot1.hasError ||
                        snapshots.snapshot1.hasError) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var list1 = snapshots.snapshot1.data!.docs;
                      var list2 = snapshots.snapshot2.data!.docs;

                      list1.addAll(list2);

                      var list = list1.toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return SizedBox(
                            width: 150.w,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              child: ItemTileSmall(
                                itemName: list[index]["Name"] ?? "",
                                itemPrice: list[index]["Price"].toString(),
                                imagePath: list[index]["Image"] ?? "",
                                color: Colors.grey[50],
                                description: list[index]["Description"] ?? "",
                                place: list[index]["Place"] ?? "",
                                docId: list[index].id,
                                collection: list[index].reference.parent.path,
                              ),
                            ),
                          );
                        },
                        itemCount: list.length,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
