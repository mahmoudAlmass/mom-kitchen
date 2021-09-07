import 'package:kitchen_ware_project/models/category.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:flutter/cupertino.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/utli/enum/connectionStatus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealProvider extends ChangeNotifier {
  ConnectionStatus connectionStatus = ConnectionStatus.loading;

  final CollectionReference mealsCollection =
      FirebaseFirestore.instance.collection('meals');

  Stream<List<Meal>> getMealStream(List<Meal> mealData) {
    BehaviorSubject<List<Meal>> _data =
        new BehaviorSubject<List<Meal>>.seeded(mealData);
    return _data.stream;
  }

  bool hasNext = true;
  bool isLoadingMeals = false;
  bool hasNextMostRated = true;
  bool isLoadingMealsMostRated = false;
  bool hasNextFavorites = true;
  bool isLoadingFavorites = false;

  List<Meal> _meals = [];
  List<Meal> _mostRated = [];
  List<Meal> _recentlyAdded = [];
  List<Meal> _favorites = [];

  List<Meal> categoryMeals = [];
  List<DocumentSnapshot> _mealsDocs = [];
  List<DocumentSnapshot> _mostRatedDocs = [];
  List<DocumentSnapshot> _recentlyAddedDocs = [];
  List<DocumentSnapshot> _favoritesDocs = [];

  List<Meal> get meals {
    return _meals;
  }

  List<Meal> get mostRated {
    return _mostRated;
  }

  List<Meal> get recentlyAdded {
    return _recentlyAdded;
  }

  List<Meal> get favorites {
    return _favorites;
  }

  Future<void> newAddMeal(Meal meal) async {
    //root collection
    await FirebaseFirestore.instance
        .collection('meals')
        .doc(meal.id)
        .set(meal.toJson());

    //chief collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(meal.chefId)
        .collection("meals")
        .doc(meal.id)
        .set(meal.toJson());
  }

  Future<List<Meal>> fetchAllMealInCategory(Category category) async {
    List<Meal> _newData = [];
    await FirebaseFirestore.instance
        .collection("meals")
        .where("cats.${category.title}", isEqualTo: category.title)
        .get()
        .then((snapshots) {
      snapshots.docs.forEach((snapshot) {
        _newData.add(Meal.fromJson(snapshot.data()));
      });
    });
    return _newData;
  }

  Future<List<Meal>> fetchSuggestion(Meal meal) async {
    List<Meal> _newData = [];
    for (var category in meal.cats!.values) {
      await FirebaseFirestore.instance
          .collection("meals")
          .where("cats.$category", isEqualTo: category)
          .get()
          .then((snapshots) {
        snapshots.docs.forEach((snapshot) {
          _newData.add(Meal.fromJson(snapshot.data()));
        });
      });
    }
    return _newData;
  }

//start of pagenition

  Future<void> getMeals() async {
    if (isLoadingMeals) return;

    isLoadingMeals = true;

    final snapshots = await fetchMeals(
        startAfter: _mealsDocs.isNotEmpty ? _mealsDocs.last : null, query: 0);
    _mealsDocs.addAll(snapshots.docs);

    if (snapshots.docs.length < 8) hasNext = false;

    isLoadingMeals = false;

    snapshots.docs.forEach((snapshot) {
      _meals.add(Meal.fromJson(snapshot.data()));
    });

    notifyListeners();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> fetchMeals(
      {DocumentSnapshot? startAfter, int? query}) async {
    var snapshots;
    //most rated
    if (query == 1) {
      snapshots = FirebaseFirestore.instance
          .collection("meals")
          .orderBy("rate", descending: true)
          .limit(8);
    }
    //all meals
    else {
      snapshots = FirebaseFirestore.instance.collection("meals").limit(8);
    }
    if (startAfter == null) {
      return snapshots.get();
    } else {
      return snapshots.startAfterDocument(startAfter).get();
    }
  }

// start of most rated

  Future<void> getMostRated() async {
    if (isLoadingMealsMostRated) return;

    isLoadingMealsMostRated = true;

    final snapshots = await fetchMeals(
        startAfter: _mostRatedDocs.isNotEmpty ? _mostRatedDocs.last : null,
        query: 1);
    _mostRatedDocs.addAll(snapshots.docs);

    if (snapshots.docs.length < 8) hasNextMostRated = false;

    isLoadingMealsMostRated = false;

    snapshots.docs.forEach((snapshot) {
      _mostRated.add(Meal.fromJson(snapshot.data()));
    });

    notifyListeners();
  }

//end of most rated

//end of pagenition

  Future<List<Meal>> mealsByCheifId(String cheifId) async {
    List<Meal> _mealsByThisCheif = [];
    await FirebaseFirestore.instance
        .collection("users")
        .doc(cheifId)
        .collection("meals")
        .get()
        .then((snapshots) {
      snapshots.docs.forEach((snapshot) {
        _mealsByThisCheif.add(Meal.fromJson(snapshot.data()));
      });
    });
    return _mealsByThisCheif;
  }

  Future<void> clearAllMealToSingleCheif(String cheifID) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(cheifID)
        .collection("meals")
        .get()
        .then((snapshots) async {
      for (var snap in snapshots.docs) {
        await snap.reference.delete();
      }
    });

    await FirebaseFirestore.instance
        .collection("meals")
        .where("chefId", isEqualTo: cheifID)
        .get()
        .then((snapshots) async {
      for (var snap in snapshots.docs) {
        await snap.reference.delete();
      }
    });
  }

  Future<void> updateMeal(Meal meal) async {
    //root collection
    await FirebaseFirestore.instance
        .collection('meals')
        .doc(meal.id)
        .update(meal.toJson());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(meal.chefId)
        .collection("meals")
        .doc(meal.id)
        .update(meal.toJson());
  }

  Future<void> deleteMeal(Meal meal) async {
    print("here");
    await FirebaseFirestore.instance.collection('meals').doc(meal.id).delete();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(meal.chefId)
        .collection("meals")
        .doc(meal.id)
        .delete();
  }

  Future<void> rateMeal(Meal meal, int newRate) async {
    print(newRate);
    var totalRate;
    var raterNumber;
    await FirebaseFirestore.instance
        .collection('meals')
        .doc(meal.id)
        .get()
        .then((snapshot) {
      totalRate = snapshot.data()!['rate'];
      raterNumber = snapshot.data()!['raterNumber'];
  
    });

    await FirebaseFirestore.instance.collection('meals').doc(meal.id).update({
      'rate': (((raterNumber * totalRate) + newRate) / (raterNumber + 1)).floor(),
      'raterNumber': raterNumber + 1
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(meal.chefId)
        .collection("meals")
        .doc(meal.id)
        .update({
          'rate': (((raterNumber * totalRate) + newRate) / (raterNumber + 1)).floor(),

      'raterNumber': raterNumber + 1
    });
  }

  Future<Meal> fetchMealById(String mealID) async {
    Meal m = Meal();
    await FirebaseFirestore.instance
        .collection("meals")
        .doc(mealID)
        .get()
        .then((value) {
      m = Meal.fromJson(value.data()!);
    });
    return m;
  }

  Future<List<Meal>> getFavoritesMeals(String userId) async {
    List<Meal> _data = [];
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .get()
        .then((snapsDocs) async {
      for (var reference in snapsDocs.docs) {
        await fetchMealById(reference.id).then((meal) {
          _data.add(meal);
        });
      }
    });
    return _data;
  }

  setConnectionStatus(value) {
    connectionStatus = value;
    notifyListeners();
  }
}
