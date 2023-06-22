import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPay extends StatefulWidget {
  final amount;
  final itemName;
  final image;
  final docId;
  final collection;
  const RazorPay(
      {Key? key,
      this.amount,
      this.itemName,
      this.docId,
      this.collection,
      required this.image})
      : super(key: key);

  @override
  State<RazorPay> createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  final _razorpay = Razorpay();
  var trs;

  @override
  void initState() {
    print(widget.docId);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    trs = FireTransaction(
        itemName: widget.itemName,
        imagePath: widget.image,
        price: widget.amount,
        collection: widget.collection,
        docId: widget.docId);
    await trs.orderTransaction();

    _showMyDialog(
      response: response,
      title: 'Payment success',
      body: "Payment-Id:${response.paymentId}\nOrder-Id:${widget.docId}",
    );
    // Navigator.of(context).pop();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //  when payment fails

    _showMyDialog(
      response: response,
      title: 'Payment success',
      body: "Failed due-to:${response.message}",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // when an external wallet was selected
  }

  Future<void> _showMyDialog({var response, var title, var body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var options = {
      'key': 'rzp_test_pWEOBZ0ochso86',
      'amount': 100 * int.parse(widget.amount),
      'name': 'Fine Art Shop App',
      'description': widget.itemName,
      'prefill': {
        'contact': '8660424122',
        'email': 'pradeepag651@gmail.com',
        // 'method': 'upi',
      },
    };
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.itemName,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.amount,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            Center(
              child: MaterialButton(
                  color: Colors.brown[400],
                  onPressed: () async {
                    try {
                      _razorpay.open(options);
                    } catch (e) {
                      print(e);
                    }
                  },
                  // },
                  child: const Text("Pay")),
            ),
          ],
        ),
      ),
    );
  }

  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
}

class FireTransaction {
  final docId;
  final collection;
  final imagePath;
  final itemName;
  final price;

  FireTransaction(
      {this.imagePath,
      required this.itemName,
      this.price,
      this.docId,
      this.collection});
  void orderTransaction() async {
    final firebase = await FirebaseFirestore.instance
        .collection(this.collection)
        .doc(this.docId);

    final delivery =
        await FirebaseFirestore.instance.collection('OrdersDetails').doc();

    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          await transaction.get(firebase);

          transaction.set(delivery, {
            'Name': this.itemName,
            'Doc-Id': this.docId,
            'Price': int.parse(this.price),
            'Image': this.imagePath,
            'User-Email': FirebaseAuth.instance.currentUser?.email,
          });

          transaction.delete(firebase);
        })
        .then((value) => print("Transaction successful: $value "))
        .catchError((error) => print("Transaction failed: $error"));
  }
}
