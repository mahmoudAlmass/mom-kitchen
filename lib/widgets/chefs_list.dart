import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/components/shimmer_loading.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/widgets/chef_item.dart';
import 'package:provider/provider.dart';

class ChefsList extends StatefulWidget {
  @override
  _ChefsListState createState() => _ChefsListState();
}

class _ChefsListState extends State<ChefsList> {
  List<User> cheifs=[];
  bool _isLoading=true;
  bool _isInit=true;

  @override
  void didChangeDependencies() async{
    if(_isInit){
      await Provider.of<UserProvider>(context).fetchAllChiefs().then((value) {
      setState(() {
        cheifs=value;
        _isLoading=false;
        _isInit=false;
      });
    } );
    }
  
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return _isLoading ?ShimmerLoading(): ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: 10,
        );
      },
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: cheifs.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ChefItem(
          cheifs[index]
        );
      },
    );
  }
}
