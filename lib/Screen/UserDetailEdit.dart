import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fine_art_shop/Componets/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Show extends StatefulWidget {
  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final photo = FirebaseStorage.instance;
  var image = FirebaseAuth.instance.currentUser?.photoURL.toString() ?? '';
  XFile? file;
  final userCollection = FirebaseFirestore.instance.collection('User');
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneNoTextController = TextEditingController();
  final CountryTextController = TextEditingController();
  late final currentUserDetail = userCollection.doc(currentUser?.uid);
  late final getcurrentUserDetail = userCollection.doc(currentUser?.uid).get();

  @override
  void initState() {
    super.initState();
    print(currentUser?.uid);
    nameTextController.value =
        TextEditingValue(text: currentUser!.displayName ?? '');

    emailTextController.value =
        TextEditingValue(text: currentUser!.email ?? '');
    setState(() {
      print(image);
    });

    currentUserDetail.update({
      'Name': currentUser!.displayName,
      'Email': currentUser?.email,
    });
    location;
  }

  void get location async {
    CountryTextController.value = TextEditingValue(
        text:
            await getcurrentUserDetail.then((value) => value.get('Country')) ??
                '');

    phoneNoTextController.value = TextEditingValue(
        text:
            await getcurrentUserDetail.then((value) => value.get('PhoneNo')) ??
                '');
  }

  @override
  void dispose() {
    nameTextController.dispose();
    emailTextController.dispose();
    phoneNoTextController.dispose();
    CountryTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    file != null
                        ? CircleAvatar(
                            foregroundImage:
                                FileImage(File(file?.path.toString() ?? '')),
                            radius: 60.r,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                          )
                        : CircleAvatar(
                            foregroundImage: NetworkImage(image),
                            radius: 60.r,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                          ),
                    Positioned(
                      right: 5.w,
                      bottom: 5.w,
                      child: Container(
                        height: 35.r,
                        width: 35.r,
                        child: IconButton(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();

                            file = await imagePicker.pickImage(
                                source: ImageSource.gallery);

                            print(file?.path);
                            if (file != null) {
                              String filename = "${currentUser?.uid}";

                              photo
                                  .ref('UserDetails')
                                  .child(filename)
                                  .putFile(File(file!.path));
                              var photoUrl = await photo
                                  .ref('UserDetails')
                                  .child(filename)
                                  .getDownloadURL();
                              currentUser?.updatePhotoURL(photoUrl);
                              print('${currentUser?.photoURL} pradeep');
                              print('$photoUrl pradeep');
                              setState(() {
                                file;
                              });
                              Provider.of<DataBase>(context, listen: false)
                                  .setFile = File(file!.path);
                            }
                          },
                          icon: Icon(Icons.camera_alt, size: 30.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "data",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "data",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 25.h,
              ),
              ProfileTextField(
                nameTextController: nameTextController,
                label: "Name",
                icon: FontAwesomeIcons.user,
              ),
              ProfileTextField(
                nameTextController: emailTextController,
                label: "Email",
                icon: Icons.email,
              ),
              ProfileTextField(
                nameTextController: phoneNoTextController,
                label: "Phone No.",
                icon: Icons.phone,
              ),
              ProfileTextField(
                nameTextController: CountryTextController,
                label: "Country",
                icon: Icons.location_on_sharp,
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                width: 200.w,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    currentUserDetail.update({
                      'Email': emailTextController.text,
                      'Name': nameTextController.text.trim(),
                      'Country': CountryTextController.text.trim(),
                      'PhoneNo': phoneNoTextController.text.trim(),
                    });
                    print(emailTextController.text);
                    currentUser
                        ?.updateDisplayName(nameTextController.text.trim());
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 18.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.nameTextController,
    this.label,
    this.icon,
  });

  final TextEditingController nameTextController;
  final label;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: TextField(
          controller: nameTextController,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.brown,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(100.r),
            ),
            prefixIcon: Icon(icon),
            prefixIconColor: Colors.brown,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.brown),
            ),
          )),
    );
  }
}
