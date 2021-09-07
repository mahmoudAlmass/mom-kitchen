import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/category.dart';
import 'package:kitchen_ware_project/providers/categoreis_provider.dart';
import 'package:kitchen_ware_project/shared/constant.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/meals_screen.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatefulWidget {
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _isInit=true;
  bool _isLoading=true;
  List<Category>categories=[];
  @override
  void initState() {
    categories=Provider.of<CategoriesProvider>(context,listen: false).categories;
    super.initState();
  }
  // @override
  // void didChangeDependencies()async {
  //   if(_isInit){
  //   await Provider.of<CategoriesProvider>(context).fetchAllCategories().then((_) {
  //     setState(() {
  //       categories  =Provider.of<CategoriesProvider>(context,listen: false).dummy_categories;
        
  //       _isLoading=false;
  //       _isInit=false;
  //     });
  //   });
  //   }
  //   super.didChangeDependencies();

  // }
  @override
  Widget build(BuildContext context) {
    
    
    return  ListView.separated(
      
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: 10,
        );
      },
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: 10,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CategoryItemBuilder(
          categoriesColors[index], categories[index]);
            
      },
    );
  }
}

class CategoryItemBuilder extends StatelessWidget {
    Color color;
    Category category;


  CategoryItemBuilder(this.color,this.category);

  void selectCategory(BuildContext context) {
    // Navigator.of(context).pushNamed(CategoryMealsScreen.routeName,
    //     arguments: {'title': title, 'id': id});
    MyRouter.pushPage(context, MealsScreen(category: category));
  }

  @override
  Widget build(BuildContext context) {


    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => selectCategory(context),
      child: Container(
        // alignment: Alignment.centerRight,
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.002,
        decoration: BoxDecoration(
          color: color,
          // gradient: LinearGradient(
          //   colors: [
          //     LightOrangeColor
          //   ]
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(right: 15, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(category.imageUrl.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Text(
                category.title.toString(),
                style: TextStyle(
                  fontSize: 13.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
