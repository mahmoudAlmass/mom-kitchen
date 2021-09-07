import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/meal.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/app_provider.dart';
import 'package:provider/provider.dart';

class CustomUserSearch extends SearchDelegate {
  
  final Stream<List<User>>? data;
  final Stream<List<String>>? searchQueries;
  CustomUserSearch({this.data,this.searchQueries});
  
  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   final ThemeData theme = Theme.of(context);
  //   return theme;
  // }

  //   @override
  //   PreferredSizeWidget buildBottom(BuildContext context) {
  //     return  PreferredSize(
  //       preferredSize: Size.fromHeight(56.0),
  //       child: TextButton(child: Text("search"),onPressed: null,
  //       style: TextButton.styleFrom(
  //         backgroundColor: Colors.amber
  //       ),)
  //     );
  // }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
return StreamBuilder<List<User>>(
      stream:data,
      builder: (context,AsyncSnapshot<List<User>>snapshot){
          if(!snapshot.hasData){
            return Center(child: Text('no data !'),);
          }
          //  tolowercase made me lose of my fucking minde !!!!!!!!!
          final result= snapshot.data!.where((element) => element.userName!.toLowerCase().contains(query.toLowerCase()));
          Provider.of<AppProvider>(context,listen: false).storeUserSearchQuery(query.toString());
          return ListView(
            children: 
              result.map<Card>((a) =>
                Card(
                  child: InkWell(
                    onTap: (){
                      close(context, a.userID);
                    },
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                      
                      mainAxisAlignment: MainAxisAlignment.start,
                      
                      children: [
                        Container(
                          //todo fix size
                          width:60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(a.imageUrl!),
                              
                              fit: BoxFit.fill
                            )
                          ),
                        ),
                          Container(
                            //todo fix size
                          height: 60,
                          width: MediaQuery.of(context).size.width-100,
                          child: ListTile(
                            title: Text(a.userName!),
                          ),
                        ),
                      ],
                ),
                    ),
                  ),)
              ).toList(),
            
          );
      }
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream:searchQueries,
      builder: (context,AsyncSnapshot<List<String>>snapshot){
          if(!snapshot.hasData){
            return Center(child: Text('no data !'),);
          }
          final result= snapshot.data!.where((element) => element.toLowerCase().contains(query));
          return ListView(
            children: 
              result.map<ListTile>((a) =>
                ListTile(
                    title: Text(a,style: TextStyle(color: Colors.blue),),
                    trailing: IconButton(icon: Icon(Icons.arrow_forward),onPressed: (){
                      query = a;
                    },),

                    // close does it make any sense ?
                    //like
                    // onTap: (){close(context, a);},

                    onTap:(){
                      query = a;
                      },
                ),
              ).toList(),
            
          );
      }
      );
  }
}
