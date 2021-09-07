import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitchen_ware_project/models/message.dart';
class Utlis{

    static StreamTransformer transformer<T>(
          T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
          final snaps = data.docs.map((doc) => doc.data()).toList();
          final users = snaps.map((json) => fromJson(json as Map<String, dynamic>)).toList();
          sink.add(users);
        },
      );

    static DateTime toDateTime(Timestamp value) {
    return value.toDate();
  }
  static dynamic fromDateTimeToJson(DateTime date) {
    return date.toUtc();
  }
}