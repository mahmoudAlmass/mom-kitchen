import 'package:json_annotation/json_annotation.dart';
part 'notifications.g.dart';

@JsonSerializable(explicitToJson: true)

// enum NotificationsType {
//   //from the customer to the chef
//   gettingOrder,

//   //from the chef to the customer
//   cancellingOrder,
//   confirmingOrder,
//   changingOrderStatus,
// }

class Notifications {
  // NotificationsType? notificationType;
  String? imageUrl;
  String? notificationContent;
  Notifications({this.imageUrl,this.notificationContent});

  factory Notifications.fromJson(Map<String, dynamic> json) => _$NotificationsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsToJson(this);
}
