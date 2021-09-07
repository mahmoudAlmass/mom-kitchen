import 'package:flutter/cupertino.dart';
import 'package:kitchen_ware_project/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitchen_ware_project/shared/constant.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> dummy_categories=[
    Category(
      title: 'Meats',
      imageUrl: 'https://i.imgur.com/cdYTd62.png',
    ),
    Category(
  
      title: 'Pizaa',
      imageUrl: 'https://i.imgur.com/5WmjeXV.png'
    ),
    Category(
  
      title: 'Sweets',
      imageUrl: 'https://i.imgur.com/PaprF3P.png'
    ),
    Category(

      title: 'Quick',
      imageUrl: 'https://i.imgur.com/ii9Fg37.png'
    ),
    Category(

      title: 'Fishes',
      imageUrl: 'https://i.imgur.com/xSWq0R5.png'

    ),
    Category(

      title: 'Kabab',
      imageUrl: 'https://i.imgur.com/8JPrCpL.png'

    ),
    Category(

      title: 'Cakes',
      imageUrl: 'https://i.imgur.com/BbVNWMZ.png'

    ),
    Category(

      title: 'Vegan',
      imageUrl: 'https://i.imgur.com/GGnC1Mp.png'

    ),
    Category(

      title: 'Bakery',
      imageUrl: 'https://i.imgur.com/OzhufSs.png'

    ),
    Category(

      title: 'Snacks',
      imageUrl: 'https://i.imgur.com/8YO2M3F.png'
    ),
  ];
  


  // ignore: non_constant_identifier_names
  List<Category> get categories {
    return dummy_categories;
  }
  
  
  //   Future addRandomCategories() async {
  //     List<Category> categories = dummy_categories ;
  //   final refCat = FirebaseFirestore.instance.collection('categories');

  //   final allCats = await refCat.get();
  //   if (allCats.size != 0) {
  //     return;
  //   } else {
  //     for (final category in categories) {
  //       final cateDoc = refCat.doc();
  //       final newCate = category.copyWith(id: cateDoc.id);
  //       await cateDoc.set(newCate.toJson());
  //     }
  //   }
  // }
  
  // Future<void> fetchAllCategories()async{
  //   List<Category>_data=[];
  //   final snapshot = await FirebaseFirestore.instance.collection('categories').get();

  //   for(var snap in snapshot.docs){
  //     _data.add(Category.fromJson(snap.data()));
  //   }
  //   dummy_categories =_data;
  //   notifyListeners();
  // }


  List<Category> get editedCategories=>_editedCategoriesForNewMeal;
  List<Category>_editedCategoriesForNewMeal=[];

  void clearCategoriesForNewMeal(){
    _editedCategoriesForNewMeal=[];
  
  } 
  void addCategoriesForNewMeal(Category cat){
    _editedCategoriesForNewMeal.add(cat);
    notifyListeners();
  }
    void removeCategoriesForNewMeal(Category cat){
      _editedCategoriesForNewMeal.removeWhere((element) => element.title==cat.title);
    notifyListeners();
  }
}