import 'package:fine_art_shop/Componets/Database.dart';
import 'package:fine_art_shop/Screen/ShowDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Payment/RazorPayment.dart';

class CartDesign extends StatefulWidget {
  CartDesign({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.description,
    required this.place,
    this.fun,
    required this.docId,
    required this.Collection,
  }) : super(key: key);
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final color;
  final String description;
  final String place;
  final String docId;
  final String Collection;
  var fun;

  @override
  State<CartDesign> createState() => _CartDesignState();
}

class _CartDesignState extends State<CartDesign> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(builder: (context, value, child) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowDetails(
                      collection: this.widget.Collection,
                      docid: this.widget.docId,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 12 / 10,
                child: Image.network(
                  widget.imagePath,
                ),
              ),
              Text(
                widget.itemName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
                // softWrap: true,
                softWrap: true, textAlign: TextAlign.center,
              ),
              Text(
                widget.itemPrice,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 65.w,
                    height: 25.h,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RazorPay(
                                image: this.widget.imagePath,
                                itemName: this.widget.itemName,
                                amount: this.widget.itemPrice,
                                collection: this.widget.Collection,
                                docId: this.widget.docId,
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
                      onPressed: widget.fun,

                      // print(value.cartList);

                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ))
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
