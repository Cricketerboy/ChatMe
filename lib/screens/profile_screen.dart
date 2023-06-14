// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/helper/dialogue.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screens/auth/loadaing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final ChatUser user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chat Me'),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 18.0, right: 7.0),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                Dialogue.showProgressBar(context);
                await APIs.updateActiveStatus(false);
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);

                    APIs.auth = FirebaseAuth.instance;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Loading()));
                  });
                });
              },
              icon: Icon(Icons.add_comment_rounded),
              label: Text('Logout'),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(width: mq.width, height: mq.height * 0.03),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * 0.2,
                                  height: mq.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.1),
                                child: CachedNetworkImage(
                                  width: mq.height * 0.2,
                                  height: mq.height * 0.2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  //placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          child: Icon(Icons.person_2_rounded)),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            color: Colors.white,
                            shape: CircleBorder(),
                            child: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * 0.03),
                    Text(widget.user.email,
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                    SizedBox(height: mq.height * 0.05),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. Mohit Anand',
                        label: Text('Name'),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.02),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.info_outline, color: Colors.blue),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. Feeling Happy',
                        label: Text('About'),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.05),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(mq.width * 0.5, mq.height * 0.06),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogue.showSnackBar(
                                context, 'Profile Updated Sucessfully');
                          });
                        }
                      },
                      icon: Icon(Icons.edit, size: 28),
                      label: Text('UPDATE', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (_) {
          return ListView(
            padding: EdgeInsets.only(
                top: mq.height * 0.03, bottom: mq.height * 0.05),
            shrinkWrap: true,
            children: [
              Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: mq.height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(mq.width * 0.22, mq.height * 0.12),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        log('image path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset("assets/images/gallery.png"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(mq.width * 0.25, mq.height * 0.12),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log('image path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset("assets/images/camera.png"),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
