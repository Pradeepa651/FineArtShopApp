import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_art_shop/Componets/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Componets/ItemTile.dart';

class Individual extends StatelessWidget {
  final fireStore = FirebaseFirestore.instance;
  int screenWidth = ScreenUtil().screenWidth.toInt();

  Individual({Key? key}) : super(key: key);

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
            const Divider(thickness: 1.5),
            Padding(
              padding: EdgeInsets.only(left: 10.w, bottom: 5.h, top: 5.h),
              child: Text(
                "Paints",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
            Expanded(
              child: Consumer<DataBase>(
                builder: (context, value, child) => StreamBuilder(
                    stream: value.database,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        );
                      } else {
                        var snap = snapshot.data;
                        return Container(
                          color: Colors.grey[200],
                          child: GridView.builder(
                            itemCount: snap?.length,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.w),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50.h,
                                  vertical: 15.w,
                                ),
                                child: ItemTile(
                                  description: snap![index].description ?? '',
                                  place: snap[index].place ?? '',
                                  itemName: snap[index].name,
                                  itemPrice: snap[index].price.toString(),
                                  imagePath: snap[index].imagePath ?? '',
                                  color: Colors.grey[50],
                                  docId: snap[index].docId,
                                  collection: 'AvialablePaints',
                                ),
                              );
                            },
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: screenWidth < 500
                                        ? 1
                                        : screenWidth < 800
                                            ? 2
                                            : screenWidth < 1200
                                                ? 3
                                                : 4,
                                    childAspectRatio: 11 / 10),
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
