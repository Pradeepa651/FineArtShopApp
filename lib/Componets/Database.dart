import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'Item.dart';

class DataBase extends ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser?.uid;
  File? _file;
  get getFile => _file;
  set setFile(file) {
    _file = file;
    notifyListeners();
  }

  Stream<List<Item>> get database {
    return fireStore
        .collection("AvialablePaints")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map(
              (e) => Item(
                name: e.get("Name"),
                price: e.get("Price"),
                description: e.get("Description"),
                imagePath: e.get("Image"),
                place: e.get("Place"),
                docId: e.reference.id,
              ),
            )
            .toList());
  }

  Future<List> get list async {
    var data = await fireStore.collection('User').doc(user).get();
    var list;
    try {
      list = data.get('CartItem');
    } catch (e) {
      list.add(data.get('CartItem'));
    }
    return list;
  }
}
