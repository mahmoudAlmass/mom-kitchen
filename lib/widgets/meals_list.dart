import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:provider/provider.dart';
import './meal_item.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/providers/meal_provider.dart';

class MealsList extends StatefulWidget {
  int? query;
  MealsList({this.query});
  @override
  _MealsListState createState() => _MealsListState();
}

class _MealsListState extends State<MealsList> {
  List<Meal> meals = [];
  bool _isLoading = true;
  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      if (widget.query == 1) {
        await Provider.of<MealProvider>(context).getMostRated().then((_) {
          setState(() {
            meals = Provider.of<MealProvider>(context, listen: false).mostRated;
            _isLoading = false;
            _isInit = false;
          });
        });
      } else {
        await Provider.of<MealProvider>(context).getMeals().then((_) {
          setState(() {
            meals = Provider.of<MealProvider>(context, listen: false).meals;
            _isLoading = false;
            _isInit = false;
          });
        });
      }
    }

    super.didChangeDependencies();
  }

  final scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    final mealProv = Provider.of<MealProvider>(context, listen: false);
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if(widget.query==1){
        if (mealProv.hasNextMostRated) {
            mealProv.getMostRated();
        }
      }else{
        if (mealProv.hasNext) {
            mealProv.getMeals();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? ShimmerLoading()
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return MealItem(meals[index]);
            },
          );
  }
}
