import 'package:cached_network_image/cached_network_image.dart';

import 'package:chatapp/helper/date_util.dart';

import 'package:chatapp/main.dart';
import 'package:chatapp/models/chat_user.dart';

import 'package:flutter/material.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Joined On:  ',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showyear: true),
                  style: TextStyle(color: Colors.black87, fontSize: 16)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: Column(
              children: [
                SizedBox(width: mq.width, height: mq.height * 0.03),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.1),
                  child: CachedNetworkImage(
                    width: mq.height * 0.2,
                    height: mq.height * 0.2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        CircleAvatar(child: Icon(Icons.person_2_rounded)),
                  ),
                ),
                SizedBox(height: mq.height * 0.03),
                Text(widget.user.email,
                    style: TextStyle(color: Colors.black87, fontSize: 16)),
                SizedBox(height: mq.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('About:  ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text(widget.user.about,
                        style: TextStyle(color: Colors.black87, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
