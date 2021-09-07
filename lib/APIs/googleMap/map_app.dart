import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/APIs/googleMap/placesProvider.dart';
import 'package:kitchen_ware_project/components/loading_widget.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'place.dart';
import 'place_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';



class MapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  _MapAppHomePage();
  }
}

class _MapAppHomePage extends StatefulWidget {
  const _MapAppHomePage({Key? key}) : super(key: key);

  @override
  __MapAppHomePageState createState() => __MapAppHomePageState();
}

class __MapAppHomePageState extends State<_MapAppHomePage> {
  double? lati;
  double? long;
  LatLng? latLng;
  bool _isInit=true;
  bool _isLoading=true;
  User? logedUser;
  @override
  void initState() {
    setState(() {
      logedUser=Provider.of<UserProvider>(context,listen: false).logedUser!;
    });
    super.initState();
  }
  @override
  void didChangeDependencies() async{
    if(_isInit){
      await Provider.of<MapState>(context).getCurrentLocation().then((_) async{
        var state = Provider.of<MapState>(context,listen: false);
        await Provider.of<PlacesProvider>(context,listen: false).fetchAllPlaces().then((value) {
          state.setPlaces(value);
        });
        latLng= new LatLng(state.lati, state.long);
        setState(() {
          _isLoading=false;
        });
    });
    }
    setState(() {
      _isInit=false;
    });
  
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return _isLoading? LoadingWidget():  Scaffold(
        body: Container(
          child: PlaceMap(center: latLng!,logedUser: logedUser,),
          ),
    );
  }
}


class MapState extends ChangeNotifier {

  late double lati;
  late double long;

  Future<void> getCurrentLocation() async{
    var location= await Location().getLocation();
    lati=location.latitude!;
    long=location.longitude!;
    notifyListeners();
  }
  List<Place> places=[];
  void setAppState(){
    
  }



  void setPlaces(List<Place> newPlaces) {
    places = newPlaces;
    notifyListeners();
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapState &&
        other.places == places;
  }

  @override
  int get hashCode => places.hashCode;
}