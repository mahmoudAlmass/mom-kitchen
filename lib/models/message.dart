import 'package:json_annotation/json_annotation.dart';
import '../utli/utilis.dart';
part 'message.g.dart';

@JsonSerializable(explicitToJson: true)

class Message {
    String? messageId;
    String? userId;
    String? message;
    DateTime? createdAt;

  Message({
      this.userId,
      this.messageId,
      this.message,
      this.createdAt,
  });
  
    Message copyWith({
    String? messageId,
    String? userId,
    String? message,
    DateTime? createdAt,
  }) =>
      Message(
        messageId: messageId ?? this.messageId,
        userId: userId ?? this.userId,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
      );
      


  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
