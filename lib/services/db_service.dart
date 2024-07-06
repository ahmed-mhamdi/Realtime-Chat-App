import 'dart:ffi';

import 'package:chat_app_material3/Utils.dart';
import 'package:chat_app_material3/models/chat_model.dart';
import 'package:chat_app_material3/models/message_model.dart';
import 'package:chat_app_material3/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../models/user_model.dart';

class DbService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;
  CollectionReference? _chatsCollection;
  DbService() {
    _setUpCollectionReferences();
  }

  void _setUpCollectionReferences() {
    _usersCollection = _firebaseFirestore
        .collection("users")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (userModel, _) => userModel.toJson(),
        );
    _chatsCollection =
        _firebaseFirestore.collection("chats").withConverter<ChatModel>(
      fromFirestore: (snapshot, _) {
        return ChatModel.fromJson(snapshot.data()!);
      },
      toFirestore: (chatModel, _) {
        return chatModel.toJson();
      },
    );
  }

  Future<void> createUserProfile({required UserModel userModel}) async {
    await _usersCollection!.doc(userModel.uid).set(userModel);
  }

  Stream<QuerySnapshot<UserModel>> getUsers() {
    return _usersCollection
        ?.where("uid",
            isNotEqualTo: GetIt.instance.get<AuthService>().user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserModel>>;
  }

  Future<bool> doesChatExists(
      {required String uid1, required String uid2}) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatsCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(
      {required String uid1, required String uid2}) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final chatReference = _chatsCollection!.doc(chatID);
    final ChatModel chat =
        ChatModel(id: chatID, participants: [uid1, uid2], messages: []);
    await chatReference.set(chat);
  }

  Stream<DocumentSnapshot<ChatModel>> getChatData({
    required String uid1,
    required String uid2,
  }) {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _chatsCollection!.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<ChatModel>>;
  }

  Future<void> sendMessage(
      {required String uid1,
      required String uid2,
      required MessageModel messageModel}) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final chatReference = _chatsCollection!.doc(chatID);
    await chatReference.update({
      "messages": FieldValue.arrayUnion([messageModel.toJson()])
    });
  }
}
