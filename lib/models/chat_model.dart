import 'package:chat_app_material3/models/message_model.dart';

class ChatModel {
  String? id;
  List<String>? participants;
  List<MessageModel>? messages;

  ChatModel({
    required this.id,
    required this.participants,
    required this.messages,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']);
    messages = List.from(json['messages'])
        .map((m) => MessageModel.fromJson(m))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['participants'] = participants;
    data['messages'] = messages?.map((m) => m.toJson()).toList() ?? [];
    return data;
  }
}
