import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/shared/theme/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class AppProvider extends ChangeNotifier{

    AppProvider(){
    checkTheme();
    setupSearchQueries();
    setupUserSearchQueries();
    cheackChanges().then((value) {
      firstUse=value;
      notifyListeners();
    });
  }

  ThemeData theme = ThemeConfig.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  void setTheme(value, c) async {
    theme = value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', c);
    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  Future<ThemeData> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ThemeData t;
    String r = prefs.getString('theme') ?? 'light';
    
    if (r == 'light') {
      t = ThemeConfig.lightTheme;
      setTheme(ThemeConfig.lightTheme, 'light');
    } else {
      
      t = ThemeConfig.darkTheme;
      setTheme(ThemeConfig.darkTheme, 'dark');
    }

    return t;
  }

  List<String>searchQueries=[];
  List<String>userQueries=[];

  Stream<List<String>> getUserQueriesStream(){
  BehaviorSubject<List<String>> _data= new BehaviorSubject<List<String>>.seeded(userQueries);
  return _data.stream;
}
Stream<List<String>> getQueriesStream(){
  BehaviorSubject<List<String>> _data= new BehaviorSubject<List<String>>.seeded(searchQueries);
  return _data.stream;
}
  void storeSearchQuery(String query)async{
    List<String> mealSearch=[];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    mealSearch=prefs.getStringList('meals_search')??[];
    if(mealSearch.length>0){
      mealSearch.add(query);
      mealSearch=mealSearch.toSet().toList();
      await prefs.remove("meals_search");
      await prefs.setStringList("meals_search", mealSearch);
    }else{
      await prefs.remove("meals_search");
      await prefs.setStringList("meals_search", ["meat"]);
    }
    searchQueries=mealSearch;
    notifyListeners();
  }
    void storeUserSearchQuery(String query)async{
    List<String> userSearch=[];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userSearch=prefs.getStringList('users_search')??[];
    if(userSearch.length>0){
      userSearch.add(query);
      userSearch=userSearch.toSet().toList();
      await prefs.remove("users_search");
      await prefs.setStringList("users_search", userSearch);
    }else{
      await prefs.remove("users_search");
      await prefs.setStringList("users_search", ["mah"]);
    }
    userQueries=userSearch;
    notifyListeners();
  }

  bool firstUse=true;


  void setupSearchQueries()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    searchQueries=prefs.getStringList('meals_search')??[];
    notifyListeners();
  }
  void setupUserSearchQueries()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    userQueries=prefs.getStringList('users_search')??[];
    notifyListeners();
  }
    void setFirstUse(value) async {
    firstUse = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_use', value.toString());
    notifyListeners();
  }
  void clearPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool>cheackChanges()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString('first_use')?? 'true';
    return res=='true'? true: false;
  }
}