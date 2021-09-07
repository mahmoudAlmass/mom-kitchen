import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kitchen_ware_project/APIs/googleMap/placesProvider.dart';
import 'package:kitchen_ware_project/models/user.dart';
import 'package:kitchen_ware_project/providers/user_provider.dart';
import 'package:kitchen_ware_project/utli/router.dart';
import 'package:kitchen_ware_project/views/app_screens/chef_profile_screen.dart';
import 'place.dart';
import 'map_app.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:provider/provider.dart';


class MapConfiguration {
  final List<Place> places;

  const MapConfiguration({
    required this.places,

  });
  

  @override
  int get hashCode => places.hashCode ;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapConfiguration &&
        other.places == places ;
  }

  static MapConfiguration of(MapState mapState) {
    return MapConfiguration(
      places: mapState.places
    );
  }
}


class PlaceMap extends StatefulWidget {
  final LatLng center;
  User? logedUser;

  PlaceMap({
    Key? key,
    required this.center,
    required this.logedUser
  }) : super(key: key);

  @override
  _PlaceMapState createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {

  Completer<GoogleMapController> mapController = Completer();

  MapType _currentMapType = MapType.normal;

  late LatLng _lastMapPosition;

  final Map<Marker, Place> _markedPlaces = <Marker, Place>{};

  final Set<Marker> _markers = {};

  Marker? _pendingMarker;

  late MapConfiguration _configuration;

  @override
  Widget build(BuildContext context) {
    _maybeUpdateMapConfiguration();
    return Builder(builder: (context){
      return Center(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.center,
              zoom: 14.0),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: (position) => _lastMapPosition = position.target,
              ),
              _AddPlaceButtonBar(
              visible: _pendingMarker != null,
              onSavePressed: () => _confirmAddPlace(context),
              onCancelPressed: _cancelAddPlace,
            ),
            _MapFabs(
              logedUser: widget.logedUser!,
              visible: _pendingMarker == null,
              onAddPlacePressed: _onAddPlacePressed,
              onToggleMapTypePressed: _onToggleMapTypePressed,

            ),
              
        ],
      ),
    );
    });
  
  }
    Future<void> onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
    _lastMapPosition = widget.center;

    // Draw initial place markers on creation so that we have something
    // interesting to look at.
    var markers = <Marker>{};
    for (var place in Provider.of<MapState>(context, listen: false).places) {
      markers.add(await _createPlaceMarker(context, place));
    }
    setState(() {
      _markers.addAll(markers);
    });
}
  Future<Marker> _createPlaceMarker(BuildContext context, Place place) async {
    final marker = Marker(
      markerId: MarkerId(place.latLng.toString()),
      position: place.latLng,
      infoWindow: InfoWindow(
        title: place.name,
        snippet: place.chiefId==Provider.of<UserProvider>(context,listen:false).logedUser!.userID? 'tap to delete' :'${place.starRating} Star Rating',
        onTap: ()  {
          if(place.chiefId==Provider.of<UserProvider>(context,listen:false).logedUser!.userID){
          setState(() async{
                            await Provider.of<PlacesProvider>(context,listen: false).removePlace(place.id);

                            final newPlaces = await Provider.of<PlacesProvider>(context,listen: false).fetchAllPlaces();
                                  _configuration = MapConfiguration(
                                  places: newPlaces,
                                  );
                            Provider.of<MapState>(context, listen: false).setPlaces(newPlaces);
                            _markers.remove(_markers.last);
                        });
                      
          }else{
            MyRouter.pushPage(context, ChefProfileScreen(place.chiefId));
            
          }
        },
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    _markedPlaces[marker] = place;
    return marker;
  }




  Future<void> _confirmAddPlace(BuildContext context) async {
    if (_pendingMarker != null) {
      // Create a new Place and map it to the marker we just added.
      final newPlace = Place(
        id: Uuid().v1(),
        chiefId:  Provider.of<UserProvider>(context,listen:false).logedUser!.userID!,
        latLng: _pendingMarker!.position,
        name: Provider.of<UserProvider>(context,listen:false).logedUser!.userName??"new plase",
      );


      setState(() {
        final updatedMarker = _pendingMarker!.copyWith(
          
          infoWindowParam: InfoWindow(
            title: newPlace.name,
            snippet: null,
            onTap: () {
              // todo navigate to user page
            }
          ),
          draggableParam: false,
        );

        _updateMarker(
          marker: _pendingMarker!,
          updatedMarker: updatedMarker,
          place: newPlace,
        );
// edit1
        _pendingMarker = null;
      });

      await Provider.of<PlacesProvider>(context,listen: false).addNewPlace(newPlace);
      // Add the new place to the places stored in mapState.
      final newPlaces = await Provider.of<PlacesProvider>(context,listen: false).fetchAllPlaces();
          // List<Place>.from(Provider.of<MapState>(context, listen: false).places)
          //   ..add(newPlace);
      // Manually update our map configuration here since our map is already
      // updated with the new marker. Otherwise, the map would be reconfigured
      // in the main build method due to a modified MapState.
      _configuration = MapConfiguration(
        places: newPlaces,
      
      );
      Provider.of<MapState>(context, listen: false).setPlaces(newPlaces);
      
      // Show a confirmation snackbar that has an action to edit the new place.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content:
              const Text('New place added.', style: TextStyle(fontSize: 16.0)),
          action: SnackBarAction(
            label: 'cansel',
            onPressed: ()  {
              setState(() async{
                  await Provider.of<PlacesProvider>(context,listen: false).removePlace(newPlace.id);

                  final newPlaces = await Provider.of<PlacesProvider>(context,listen: false).fetchAllPlaces();
                  // List<Place>.from(Provider.of<MapState>(context, listen: false).places)
                  // ..remove(newPlace);
                        _configuration = MapConfiguration(
                        places: newPlaces,
                        );
                  Provider.of<MapState>(context, listen: false).setPlaces(newPlaces);
                  _markers.remove(_markers.last);
              });
            },
          ),
        ),
      );
    }
  }



    void _updateMarker({
    required Marker marker,
    required Marker updatedMarker,
    required Place place,
  }) {
    _markers.remove(marker);
    _markedPlaces.remove(marker);

    _markers.add(updatedMarker);
    
    _markedPlaces[updatedMarker] = place;
  }

    void _cancelAddPlace() {
    if (_pendingMarker != null) {
      setState(() {
        _markers.remove(_pendingMarker);
        //edit2
        _pendingMarker = null;
      });
    }
  }


  void _maybeUpdateMapConfiguration()  {
    //edit3
    _configuration =
        MapConfiguration.of(Provider.of<MapState>(context, listen: false));
    final newConfiguration =
        MapConfiguration.of(Provider.of<MapState>(context, listen: false));

    // Since we manually update [_configuration] when place or selectedCategory
    // changes come from the [place_map], we should only enter this if statement
    // when returning to the [place_map] after changes have been made from
    // [place_list].
    if (_configuration != newConfiguration && mapController != null) {
      if (_configuration.places != newConfiguration.places) {
        // At this point, we know the places have been updated from the list
        // view. We need to reconfigure the map to respect the updates.
        newConfiguration.places
            .where((p) => !_configuration.places.contains(p))
            .map((value) => _updateExistingPlaceMarker(place: value));

    
      }
      _configuration = newConfiguration;
    }
  }
    void _updateExistingPlaceMarker({required Place place}) {
    var marker = _markedPlaces.keys
        .singleWhere((value) => _markedPlaces[value]!.id == place.id);

    setState(() {
      final updatedMarker = marker.copyWith(
        infoWindowParam: InfoWindow(
          title: place.name,
          snippet:
              place.starRating != 0 ? '${place.starRating} Star Rating' : null,
        ),
      );
      _updateMarker(marker: marker, updatedMarker: updatedMarker, place: place);
    });
  }

    Future<void> _onAddPlacePressed() async {
    
    setState(() {
        final newMarker = Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(title: 'New Place'),
        draggable: true,
        onDragEnd: (newLastPosition){
        Marker finalMarker=_markers.firstWhere((marker) => marker.markerId==_pendingMarker!.markerId ).copyWith(
          positionParam: LatLng(newLastPosition.latitude,newLastPosition.longitude)
        );

        _markers.removeWhere((element) => element.markerId==_pendingMarker!.markerId);
        _markers.add(finalMarker);
        _pendingMarker=finalMarker;

        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    
      _markers.add(newMarker);
      _pendingMarker = newMarker;
    });
  }

    void _onToggleMapTypePressed() {
    final nextType =
        MapType.values[(_currentMapType.index + 1) % MapType.values.length];

    setState(() {
      _currentMapType = nextType;
    });
  }

}


class _AddPlaceButtonBar extends StatelessWidget {
  final bool visible;

  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;

  const _AddPlaceButtonBar({
    Key? key,
    required this.visible,
    required this.onSavePressed,
    required this.onCancelPressed,
  })  :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
        alignment: Alignment.bottomCenter,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              onPressed: onSavePressed,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              onPressed: onCancelPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFabs extends StatelessWidget {
  User logedUser;
  final bool visible;
  final VoidCallback onAddPlacePressed;
  final VoidCallback onToggleMapTypePressed;

  _MapFabs({
    Key? key,
    required this.logedUser,
    required this.visible,
    required this.onAddPlacePressed,
    required this.onToggleMapTypePressed,
  }) 
        :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 12.0, right: 12.0),
      child: Visibility(
        visible: visible,
        child: Column(
          children: [
            logedUser.isChief! ? FloatingActionButton(
              heroTag: 'add_place_button',
              onPressed: onAddPlacePressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add_location, size: 36.0),
            ):SizedBox(height: 1.0),
            SizedBox(height: 12.0),
            FloatingActionButton(
              heroTag: 'toggle_map_type_button',
              onPressed: onToggleMapTypePressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              mini: true,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.layers, size: 28.0),
            ),
          ],
        ),
      ),
    );
  }
}