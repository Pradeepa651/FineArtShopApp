import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_art_shop/Componets/CartDesign.dart';
import 'package:fine_art_shop/Componets/DeliveryCartDesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final auth = FirebaseAuth.instance.currentUser?.uid;
  final Email = FirebaseAuth.instance.currentUser?.email;
  final firestore = FirebaseFirestore.instance;
  List list = [];
  @override
  void initState() {
    super.initState();
  }

  void getstore() async {
    var lt = await firestore.doc(auth!).get();
    try {
      list = lt.get('CartItem');
    } catch (e) {
      list.add(lt.get('CartItem'));
    }
    setState(() {
      list;
    });
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[600],
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
                  "Cart",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),

              const Divider(thickness: 1.5),

              cartItem(),
              Padding(
                padding: EdgeInsets.only(left: 10.w, bottom: 5.h, top: 5.h),
                child: Text(
                  "Delivered",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
              const Divider(thickness: 1.5),
              Container(
                color: Colors.grey[300],
                height: 200.h,
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('OrdersDetails')
                        .where("User-Email", isEqualTo: Email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      if (snapshot.hasError) {
                        return Center(
                          child: SizedBox(),
                        );
                      }
                      if (snapshot.hasData) {
                        var snap = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: snap.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 150.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                child: DeliveryCartDesign(
                                  itemName: snap[index]["Name"],
                                  itemPrice: snap[index]["Price"].toString(),
                                  imagePath: snap[index]["Image"],
                                  color: Colors.grey[50],
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        );
                      } else {
                        return Center(
                          child: Text('No data'),
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  cartItem() {
    return Container(
        height: 200.h,
        color: Colors.grey[300],
        child: StreamBuilder(
            stream: firestore.collection('User').doc(auth).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(child: CircularProgressIndicator());

              if (snapshot.hasData) {
                List list = snapshot.data?.get('CartItem');
                if (list.isEmpty)
                  return Center(child: Text('Cart is Empty'));
                else
                  return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
                      streams: StreamTuple2(
                          firestore
                              .collection('AvialablePaints')
                              .where('Name', whereIn: list)
                              .snapshots(),
                          firestore
                              .collection('AvailableSculptures')
                              .where('Name', whereIn: list)
                              .snapshots()),
                      builder: (context, snapshots) {
                        if (snapshots.snapshot1.hasError ||
                            snapshots.snapshot2.hasError) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshots.snapshot1.connectionState ==
                                ConnectionState.waiting ||
                            snapshots.snapshot2.connectionState ==
                                ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshots.snapshot1.hasData &&
                            snapshots.snapshot2.hasData) {
                          var snap1 = snapshots.snapshot1.data!.docs;
                          var snap2 = snapshots.snapshot2.data!.docs;
                          snap1.addAll(snap2);
                          var snap = snap1.toList();

                          return ListView.builder(
                            itemCount: snap.length,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 150.w,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  child: CartDesign(
                                    itemName: snap[index]["Name"] ?? "",
                                    itemPrice: snap[index]["Price"].toString(),
                                    imagePath: snap[index]["Image"] ?? "",
                                    color: Colors.grey[50],
                                    description:
                                        snap[index]["Description"] ?? "",
                                    place: snap[index]["Place"] ?? "",
                                    docId: snap[index].id,
                                    Collection:
                                        snap[index].reference.parent.path,
                                    fun: () {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(auth!)
                                            .update({
                                          'CartItem': FieldValue.arrayRemove(
                                              [snap[index]['Name']])
                                        });
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        } else
                          return Text('Cart is Empty');
                      });
              } else {
                return Text('Cart is Empty');
              }
            }));
  }
}
