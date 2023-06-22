import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_art_shop/Componets/Database.dart';
import 'package:fine_art_shop/Payment/RazorPayment.dart';
import 'package:fine_art_shop/Screen/ShowDetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ItemTileSmall extends StatefulWidget {
  final collection;

  ItemTileSmall({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.description,
    required this.place,
    required this.docId,
    required this.collection,
  }) : super(key: key);
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final color;
  final String description;
  final String place;
  final String docId;

  @override
  State<ItemTileSmall> createState() => _ItemTileSmallState();
}

class _ItemTileSmallState extends State<ItemTileSmall> {
  bool addToCart = false;
  bool heart = false;
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    getList();

    super.initState();
  }

  List? list;
  List? hlist;

  void getList() async {
    var data = await firestore.collection('User').doc(user).get();

    try {
      list = await data.get('CartItem');
    } catch (e) {
      list?.add(await data.get('CartItem'));
    }
    try {
      hlist = data.get('FavouriteList');
    } catch (e) {
      hlist?.add(data.get('FavouriteList'));
    }

    addToCart =
        list?.where((element) => element == widget.itemName).length == 1;
    heart = hlist?.where((element) => element == widget.docId).length == 1;

    setState(() {
      addToCart;
      heart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(builder: (context, value, child) {
      return InkWell(
        radius: 15,
        overlayColor: MaterialStatePropertyAll(Colors.white30),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowDetails(
                      docid: widget.docId,
                      collection: widget.collection,
                      name: widget.itemName,
                      price: widget.itemPrice,
                      place: widget.place,
                      image: widget.imagePath,
                      description: widget.description)));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: Color(0xff9598AF), spreadRadius: 1),
            ],
            color: widget.color,
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
          child: Ink(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.itemName,
                  child: AspectRatio(
                    aspectRatio: widget.collection != 'AvailableSculptures'
                        ? 13 / 10
                        : 10 / 9,
                    child: Image.network(
                      widget.imagePath,
                      alignment: widget.collection != 'AvailableSculptures'
                          ? FractionalOffset(0, 1)
                          : Alignment.center,
                    ),
                  ),
                ),
                Text(
                  widget.itemName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                  // softWrap: true,
                  softWrap: true, textAlign: TextAlign.center,
                ),
                Text(
                  widget.itemPrice,
                  style:
                      TextStyle(fontWeight: FontWeight.w300, fontSize: 15.sp),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 80.w,
                      height: 30.h,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RazorPay(
                                  image: widget.imagePath,
                                  itemName: widget.itemName,
                                  amount: widget.itemPrice,
                                  collection: widget.collection,
                                  docId: widget.docId,
                                ),
                              ),
                            );
                          },
                          style: const ButtonStyle(
                              textStyle: MaterialStatePropertyAll(
                                  TextStyle(fontWeight: FontWeight.bold)),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.brown)),
                          child: const Text("Order")),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            addToCart = !addToCart;
                          });
                          addToCart
                              ? {
                                  firestore
                                      .collection('User')
                                      .doc(user)
                                      .update({
                                    'CartItem': FieldValue.arrayUnion(
                                        [widget.itemName]),
                                  }),
                                }
                              : {
                                  firestore
                                      .collection('User')
                                      .doc(user)
                                      .update({
                                    'CartItem': FieldValue.arrayRemove(
                                        [widget.itemName])
                                  }),
                                };
                        },
                        icon: Icon(
                          addToCart
                              ? Icons.shopping_cart_sharp
                              : Icons.add_shopping_cart_rounded,
                          color: Colors.brown,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
