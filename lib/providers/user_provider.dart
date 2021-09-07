
import 'package:flutter/cupertino.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';


class UserProvider extends ChangeNotifier{

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  User? logedUser;

    Stream<List<User>> getUserStream(List<User> userData) {
    BehaviorSubject<List<User>> _data =
        new BehaviorSubject<List<User>>.seeded(userData);
    return _data.stream;
  }

    Future<void> fetchAndSetUser(User user)async{
      
    await FirebaseFirestore.instance
    .collection('users')
    .doc(user.userID)
    .get()
    .then((docSnapshot) {
      if(docSnapshot.exists){
        setLogedUser(User.fromJson(docSnapshot.data()!));
      }
    });
  }

  Future<void> changeChiefStatus(bool isChief)async{
    
    await FirebaseFirestore.instance
    .collection('users')
    .doc(logedUser!.userID)
    .update({'isChief':isChief}).then((_) {
      User _user= logedUser!.copyWith(isChief: isChief);
      setLogedUser(_user);
    });
    

  // in meal provider you should delete all chief old data
    
    
  }
  Future<void>updateCheifDetailes(User _user)async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(_user.userID)
    .update(_user.toJson()).then((_) {
      setLogedUser(_user);
    });
    
  }
  Future<User>fetchChiefByid(String userID)async{
    User _user=User();
      await FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .get()
      .then((docSnapshot) {
      if(docSnapshot.exists){
        _user=User.fromJson(docSnapshot.data()!);
      }
    });
    return _user;
  }

    Future<List<User>>fetchAllChiefs()async{
    List<User> _users=[];

    await FirebaseFirestore.instance
    .collection('users')
    .where('isChief',isEqualTo: true)
    .limit(10)
    .get().then((docSnapshot) {
      docSnapshot.docs.forEach((snapshot) { 
        _users.add(User.fromJson(snapshot.data())); 
      });
    });
    return _users;


  }

  Future<void>updateDeviceToken(deviceToken)async{
    User temp= logedUser!.copyWith(deviceToken: deviceToken);
    await FirebaseFirestore.instance
    .collection('users')
    .doc( logedUser!.userID)
    .set( temp.toJson())
    .then((_) {
      setLogedUser(temp);
    });
  }

  Future<String>getDeviceTokenByUserId(String id)async{
    DocumentSnapshot<Map<String, dynamic>>
    querySnapshot= 
    await FirebaseFirestore.instance
    .collection('users')
    .doc(id)
    .get();

    User temp= User.fromJson(querySnapshot.data()!);
    return temp.deviceToken!;
  }

//stream of users for chat

Future<List<User>> fetchChatUsers(String id)async{

  List<User>_users=[];
    await FirebaseFirestore.instance
    .collection('users')
    .doc(id)
    .collection("users_chat")
    .get().then((snapshots) {
      snapshots.docs.forEach((doc) {
        _users.add(User.fromJson(doc.data()));
      });
    }); 
    return _users;
  }
  Stream<List<User>> cahtUsers(String id){
    BehaviorSubject<List<User>> _data= new BehaviorSubject();
    fetchChatUsers(id).then((value) {
      _data=BehaviorSubject<List<User>>.seeded(value);
    });
    return _data.stream;
    
  }

  Future<bool>hadOrderdThisMealBefor(String mealID)async{
    DocumentSnapshot snapshot= await FirebaseFirestore.instance
    .collection('users')
    .doc(logedUser!.userID)
    .collection("orders_history")
    .doc(mealID).get();
    print(snapshot.id);
    return snapshot.exists;
  }

  Future<void>increaseNumberOfLoves(String cheifId,int newNumber,String userId)async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(cheifId)
    .collection("lovers")
    .doc(userId)
    .set({"user_ref":userId});

    await FirebaseFirestore.instance
    .collection('users')
    .doc(cheifId).update({'numberOfLoves':newNumber});

  }
    Future<void>decreaseNumberOfLoves(String cheifId,int newNumber,String userId)async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(cheifId)
    .collection("lovers")
    .doc(userId)
    .delete();

    await FirebaseFirestore.instance
    .collection('users')
    .doc(cheifId).update({'numberOfLoves':newNumber});

  }
  Future<bool>hadLovedThisCheif(String cheifId,String userId)async{
    bool res=false;
    await FirebaseFirestore.instance
    .collection('users')
    .doc(cheifId)
    .collection("lovers")
    .doc(userId).get().then((value) {
      if(value.exists)
      res=true;
    });

    return res;
  }

  Future<bool>isInFavorite(String mealId)async{
    bool res=false;
    await FirebaseFirestore.instance
    .collection('users')
    .doc(logedUser!.userID)
    .collection("favorites")
    .doc(mealId).get().then((value) {
      if(value.exists)
      res=true;
    });
    return res;
  }
    Future<void>addMealToFavorite(String mealId)async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(logedUser!.userID)
    .collection("favorites")
    .doc(mealId)
    .set({"meal_ref":mealId});
  }
    Future<void>removeMealFromFavorite(String mealId)async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(logedUser!.userID)
    .collection("favorites")
    .doc(mealId)
    .delete();
  }


//localy


  void setLogedUser(User user){
    logedUser=user;
    notifyListeners();
  }

}