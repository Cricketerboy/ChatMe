import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileDialogue extends StatelessWidget {
  final ChatUser user;
  const ProfileDialogue({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
          width: mq.width * 0.5,
          height: mq.height * 0.40,
          child: Stack(children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.3),
                child: CachedNetworkImage(
                  width: mq.width * 0.6,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  //placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      CircleAvatar(child: Icon(Icons.person_2_rounded)),
                ),
              ),
            ),
            Positioned(
              left: mq.width * 0.04,
              top: mq.height * 0.02,
              width: mq.width * 0.55,
              child: Text(user.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            Positioned(
              right: 8,
              top: 5,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewProfileScreen(user: user)));
                },
                minWidth: 0,
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
                child: Icon(Icons.info_outline, color: Colors.blue, size: 30),
              ),
            )
          ])),
    );
  }
}
