import 'package:kitchen_ware_project/models/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable(explicitToJson: true)
class Chat {
  String? chatId;
  String? otherId;
  String? userId;
  List<Message>? messages;

  Chat({this.messages, this.chatId, this.otherId,this.userId});
  Chat copyWith({
    String? chatId,
    String? otherId,
    String? userId,
    List<Message>? messages,
  }) =>
      Chat(
        chatId: chatId ?? this.chatId,
        otherId: otherId ?? this.otherId,
        userId: userId?? this.userId,
        messages: messages ?? this.messages,
      );

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
