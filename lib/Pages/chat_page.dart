import 'dart:io';

import 'package:chat_app_material3/Utils.dart';
import 'package:chat_app_material3/models/chat_model.dart';
import 'package:chat_app_material3/models/message_model.dart';
import 'package:chat_app_material3/models/user_model.dart';
import 'package:chat_app_material3/services/auth_service.dart';
import 'package:chat_app_material3/services/db_service.dart';
import 'package:chat_app_material3/services/media_service.dart';
import 'package:chat_app_material3/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  final UserModel chatWith;
  const ChatPage({super.key, required this.chatWith});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser? currentUser, chatWith;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = ChatUser(
        id: GetIt.instance.get<AuthService>().user!.uid,
        firstName: GetIt.instance.get<AuthService>().user!.displayName);
    chatWith = ChatUser(
        id: widget.chatWith.uid!,
        firstName: widget.chatWith.name,
        profileImage: widget.chatWith.profilePhotoURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.chatWith.name!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder(
        stream: GetIt.instance
            .get<DbService>()
            .getChatData(uid1: currentUser!.id, uid2: chatWith!.id),
        builder: (context, snapshot) {
          ChatModel? chatModel = snapshot.data?.data();
          List<ChatMessage> chatMessages = [];
          if (chatModel != null && chatModel.messages != null) {
            chatMessages = _generateChatMessages(chatModel.messages!);
          }
          return DashChat(
              messageOptions: const MessageOptions(
                  showOtherUsersAvatar: true, showTime: true),
              inputOptions: InputOptions(alwaysShowSend: true, leading: [
                IconButton(
                    onPressed: () async {
                      File? file = await GetIt.instance
                          .get<MediaService>()
                          .selectImageFromGallery();
                      if (file != null) {
                        String chatID = generateChatID(
                            uid1: currentUser!.id, uid2: chatWith!.id);
                        String? downloadURL = await GetIt.instance
                            .get<StorageService>()
                            .uploadChatImage(file: file, chatID: chatID);
                        if (downloadURL != null) {
                          ChatMessage chatMessage = ChatMessage(
                              user: currentUser!,
                              createdAt: DateTime.now(),
                              medias: [
                                ChatMedia(
                                    url: downloadURL,
                                    fileName: "",
                                    type: MediaType.image)
                              ]);
                          _sendMessage(chatMessage);
                        }
                      }
                    },
                    icon: Icon(
                      Icons.image_outlined,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ]),
              currentUser: currentUser!,
              onSend: _sendMessage,
              messages: chatMessages);
        });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        MessageModel messageModel = MessageModel(
            senderID: chatMessage.user.id,
            content: chatMessage.medias!.first.url,
            messageType: MessageType.Image,
            sentAt: Timestamp.fromDate(chatMessage.createdAt));
        await GetIt.instance.get<DbService>().sendMessage(
            uid1: currentUser!.id,
            uid2: chatWith!.id,
            messageModel: messageModel);
      }
    } else {
      MessageModel messageModel = MessageModel(
          senderID: currentUser!.id,
          content: chatMessage.text,
          messageType: MessageType.Text,
          sentAt: Timestamp.fromDate(chatMessage.createdAt));
      await getService<DbService>().sendMessage(
          uid1: currentUser!.id,
          uid2: chatWith!.id,
          messageModel: messageModel);
    }
  }

  List<ChatMessage> _generateChatMessages(List<MessageModel> messagemodels) {
    List<ChatMessage> chatmessages = messagemodels
        .map((m) => ChatMessage(
            medias: m.messageType == MessageType.Image
                ? [
                    ChatMedia(
                        url: m.content!, fileName: '', type: MediaType.image)
                  ]
                : null,
            text: m.messageType == MessageType.Text ? m.content! : '',
            user: m.senderID == currentUser!.id ? currentUser! : chatWith!,
            createdAt: m.sentAt!.toDate()))
        .toList();
    chatmessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatmessages;
  }
}
