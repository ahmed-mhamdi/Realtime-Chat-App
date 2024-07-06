import 'package:chat_app_material3/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserModel userModel;
  final void Function()? ontap;
  const ChatTile({super.key, required this.userModel, this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      dense: false,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.profilePhotoURL!),
      ),
      title: Text(userModel.name!),
    );
  }
}
