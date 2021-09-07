import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitchen_ware_project/models/message.dart';

class ReportsProvider extends ChangeNotifier {
  Future<void> reportOnMeal(String mealId, String reporterId) async {
    Map<String, dynamic> reportMap = {};
    reportMap.putIfAbsent("reporterId", () => reporterId);
    reportMap.putIfAbsent("reportedMealId", () => mealId);

    await FirebaseFirestore.instance
        .collection("mealsReports")
        .doc()
        .set(reportMap);
  }

  Future<void> reportOnMessage(Message message, String reporterId) async {
    Map<String, dynamic> reportMap = {};
    reportMap.putIfAbsent("reporterId", () => reporterId);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("messageReports").doc();
    await documentReference.set(reportMap);

    await documentReference.collection("message").doc().set(message.toJson());
  }

  Future<bool> isBlockedUser(String userID) async {
    bool res = false;
    await FirebaseFirestore.instance.collection("blocked").get().then((snaps) {
      for (var snap in snaps.docs) {
        if (snap.data()['blocked'] == userID) res = true;
      }
    });
    return res;
  }
}
