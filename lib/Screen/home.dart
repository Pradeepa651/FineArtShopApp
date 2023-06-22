import 'package:fine_art_shop/Componets/Database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final firestore = FirebaseFirestore.instance.collection('User');
  @override
  void initState() {
    getData();
    super.initState();
  }

  List cartdata = [];
  void getData() async {
    // var t = Provider.of<DataBase>(context);
    var data = await firestore.doc(userId).get();

    try {
      cartdata = await data.get('CartItem');
    } catch (e) {
      cartdata.add(await data.get('CartItem'));
    }
    cartdata.forEach((element) async {});
    print(await '${cartdata} gg');
  }

  get List1 async => await cartdata;
  @override
  Widget build(BuildContext context) {
    return Consumer<DataBase>(builder: (context, value, child) {
      return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    auth.signOut();

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Let's buy beautiful item for you",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34.sp,
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
            Text(
              "Category",
              style: TextStyle(
                fontSize: 16.h,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1 / 1.5),
                padding: EdgeInsets.only(
                    right: 15.w, bottom: 20.h, top: 10.h, left: 15.w),
                children: [
                  categeory(
                      imagepath: "assets/KalighatPainting.jpg",
                      text: "Paints",
                      function: () {
                        Navigator.pushNamed(
                          context,
                          '/individual',
                        );
                      }),
                  categeory(
                      imagepath: "assets/rama.jpeg",
                      text: "Sculpture",
                      function: () {
                        Navigator.pushNamed(
                          context,
                          '/individual2',
                        );
                      }),
                  categeory(
                      text: "All",
                      function: () {
                        Navigator.pushNamed(
                          context,
                          '/specificscreen',
                        );
                      }),
                  categeory(
                      text: "Cart",
                      function: () {
                        Navigator.pushNamed(
                          context,
                          '/cart',
                        );
                      }),
                ],
              ),
            )
          ]),
        ),
      );
    });
  }
}

class categeory extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final imagepath;

  final text;

  final function;
  categeory({super.key, this.imagepath, this.text, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
          padding: EdgeInsets.only(right: 15.w, bottom: 15.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              imagepath != null
                  ? AspectRatio(
                      aspectRatio: 8 / 11,
                      child: Image.asset(
                        imagepath,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox(),
              Container(
                color: const Color(0x59dadde3),
                width: double.maxFinite,
                height: double.maxFinite,
                child: Center(
                    child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                )),
              ),
            ],
          )),
    );
  }
}
