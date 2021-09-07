import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kitchen_ware_project/models/chat.dart';
import 'package:kitchen_ware_project/models/message.dart';
import 'package:kitchen_ware_project/utli/utilis.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];

  Future<void> setUpChatReferanceInUserDocument(
      String userId, String reference) async {
    Map<String, dynamic> ref = {};
    ref.putIfAbsent("chat_ref", () => reference);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("chats")
        .doc(reference)
        .set(ref);
  }

  Future<Chat> initChat(String otherId, String logedUser) async {
    Chat _chat = Chat();
    await FirebaseFirestore.instance
        .collection('chats')
        .where('otherId', isEqualTo: otherId)
        .get()
        .then((value) async {
      List<Message> _messages = [];
      if (value.docs.length > 0) {
        _chat = Chat.fromJson(value.docs.first.data());
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(_chat.chatId)
            .collection("messages")
            .get()
            .then((snapshots) {
          snapshots.docs.forEach((doc) {
            _messages.add(Message.fromJson(doc.data()));
          });
        });
        _chat = _chat.copyWith(messages: _messages);
      }
      
      else {
        String id = Uuid().v4();
        List<Message> messages = [];
        _chat =
            _chat.copyWith(chatId: id, otherId: otherId,userId: logedUser, messages: messages);
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(id)
            .set(_chat.toJson());

        await setUpChatReferanceInUserDocument(otherId, id);
        await setUpChatReferanceInUserDocument(logedUser, id);
      }
    });
    return _chat;
  }

  Future<List<String>> fetchChatsIdsFromUserCollection(String userID) async {
    List<String> chats_ids = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection("chats")
        .get()
        .then((snapshots) {
      snapshots.docs.forEach((doc) {
        chats_ids.add(doc.data()['chat_ref']);
      });
    });
    return chats_ids;
  }

  Future<void> uploadMessage(String chatId, Message message) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection("messages")
        .doc(message.messageId)
        .set(message.toJson());
  }

  Future<List<Chat>> getAllChats(String userID) async {
    List<String> chats_ids = [];
    List<Chat> _chats = [];
    await fetchChatsIdsFromUserCollection(userID).then((value) {
      chats_ids.addAll(value);
    });

    for (var singleChat in chats_ids) {
      await getSingleChat(singleChat).then((value) {
        _chats.add(value);
      });
    }
    chats = _chats;
    notifyListeners();
    return _chats;
  }

  Future<Chat> getSingleChat(String chatId) async {
    List<Message> _messages = [];
    Chat chat = Chat();
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .get()
        .then((value) {
      chat = Chat.fromJson(value.data()!);
    });
        _messages=await fetchAllMessagesInChat(chatId);
    chat = chat.copyWith(messages: _messages);
    return chat;
  }
  Future <List<Message>> fetchAllMessagesInChat(String chatId)async{
    List<Message> _messages = [];
      await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .get()
        .then((snapshots) {
      snapshots.docs.forEach((doc) {
        _messages.add(Message.fromJson(doc.data()));
      });
  });
  return _messages;
  
  }



    Stream<List<Message>> messages(chatid){
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatid)
        .collection("messages").orderBy("createdAt", descending: true).snapshots().map(_messagesFromSnapshot);
  }
    List<Message> _messagesFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Message(
        messageId:doc['messageId'],
        message:doc['message'],
        userId: doc['userId'],
        createdAt: doc['createdAt']== null ? null : DateTime.parse(doc['createdAt'] as String),
      );
    }).toList();
  }
}
