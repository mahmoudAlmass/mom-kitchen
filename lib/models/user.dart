
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? userID;
  final String? userName;
  final String? email;
  final String? imageUrl;
  final bool? isChief;
  final String? openingTime;
  final String? closingTime;
  final String? backgroungProfileImage;
  final String? introduction;
  final String? location;
  final String? deviceToken;
  final int? numberOfLoves;

  const User({
    this.userID,
    this.userName,
    this.email,
    this.imageUrl,
    this.isChief,
    this.backgroungProfileImage,
    this.closingTime,
    this.openingTime,
    this.introduction,
    this.location,
    this.deviceToken,
    this.numberOfLoves,
  });
  
  User copyWith({
    String? userID,
    String? userName,
    String? email,
    String? imageUrl,
    bool? isChief,
    String? backgroungProfileImage,
    String? openingTime,
    String? closingTime,
    String? introduction,
    String? location,
    String? deviceToken,
  final int? numberOfLoves,

  }) =>
      User(
        userID: userID ?? this.userID,
        userName: userName ?? this.userName,
        email: email ?? this.email,
        imageUrl: imageUrl?? this.imageUrl,
        isChief: isChief?? this.isChief,
        backgroungProfileImage: backgroungProfileImage?? this.backgroungProfileImage,
        openingTime: openingTime?? this.openingTime,
        closingTime: closingTime?? this.closingTime,
        introduction: introduction?? this.introduction,
        location: location?? this.location,
        deviceToken: deviceToken?? this.deviceToken,
        numberOfLoves: numberOfLoves?? this.numberOfLoves
      );
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
