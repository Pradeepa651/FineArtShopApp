import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Componets/Database.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late final photo = user?.photoURL.toString() ?? '';
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var providerFile = Provider.of<DataBase>(context).getFile;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: providerFile != null
                      ? CircleAvatar(
                          foregroundImage: FileImage(providerFile),
                          radius: 60.r,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                        )
                      : CircleAvatar(
                          foregroundImage: NetworkImage(photo),
                          radius: 60.r,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                        ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  user!.displayName.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  user!.email ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 25.h,
                ),
                SizedBox(
                  width: 200.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/showscreen');
                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.grey[100],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 30.h,
                    bottom: 15.h,
                  ),
                  child: const Divider(thickness: 1),
                ),
                // Container(
                //   height: 35.h,
                //   margin: EdgeInsets.symmetric(vertical: 5.h),
                //   child: ProfileMenuWidget(
                //     icon: FontAwesomeIcons.treeCity,
                //     title: 'Address',
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  child: Container(
                    height: 35.h,
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    child: ProfileMenuWidget(
                      icon: Icons.logout,
                      title: 'Logout',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/resetpassword');
                  },
                  child: Container(
                    height: 35.h,
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    child: ProfileMenuWidget(
                      icon: Icons.lock_reset_rounded,
                      title: 'ResetPassword',
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final icon;
  final title;
  final function;
  const ProfileMenuWidget({
    super.key,
    this.icon,
    this.title,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: function,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            100.r,
          ),
          color: Colors.brown.withOpacity(0.2),
        ),
        child: Icon(
          icon,
          color: Colors.brown,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
