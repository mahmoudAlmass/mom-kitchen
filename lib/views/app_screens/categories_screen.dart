import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/category.dart';
import 'package:kitchen_ware_project/providers/categoreis_provider.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/meals_screen.dart';
import 'package:provider/provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';


class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    final categoriesData = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: deviceSize.height * 0.05,
                left: deviceSize.width * 0.03,
                right: deviceSize.width * 0.01,
                bottom: deviceSize.height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: Theme.of(context).appBarTheme.backgroundColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: deviceSize.width * 0.03),
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
            Container(
              // height: deviceSize.height * 0.7,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.3),
                itemCount: categoriesData.dummy_categories.length,
                itemBuilder: (_, index) => Container(
                  child: CategoryItemBuilderScreen(
                      categoriesData.dummy_categories[index],
                      index < 10
                          ? categoriesColors[index]
                          : categoriesColors[0]),
                ),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItemBuilderScreen extends StatelessWidget {
  final Category category;
  final Color color;

  CategoryItemBuilderScreen(this.category, this.color);

  void selectCategory(BuildContext context) {
    // Navigator.of(context).pushNamed(CategoryMealsScreen.routeName,
    //     arguments: {'title': title, 'id': id});
    MyRouter.pushPage(context, MealsScreen(category: category));
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Container(
      height: deviceSize.height * 0.1,
      width: deviceSize.width * 0.3,
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => selectCategory(context),
        child: Container(
          // alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.002,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.only(right: 15, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  category.title!,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
