


import 'package:flutter/cupertino.dart';

import 'place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PlacesProvider extends ChangeNotifier{
  Future<void>addNewPlace(Place place)async{
    await FirebaseFirestore.instance
    .collection("places")
    .doc(place.id)
    .set(Place.toMap(place));
  }


  List<Place>places=[];

  Future<List<Place>>fetchAllPlaces()async{
    List<Place>_newPlaces=[];
    await FirebaseFirestore.instance
    .collection("places").get().then((snapshot) {
      for(var snap in snapshot.docs ){
        _newPlaces.add(Place.fromQueryDocumentSnapshot(snap));
      }
    });
    places=_newPlaces;
    notifyListeners();
    return _newPlaces;
  }

  Future<void>removePlace(String id)async{
    await FirebaseFirestore.instance
    .collection("places").doc(id).delete();
  }

    void setNewPlaces(List<Place>_places){
    places=_places;
    notifyListeners();
  }

}

class StubData {
  static const List<Place> places = [
    // Place(
    //   id: '1',
    //   latLng: LatLng(33.524676, 36.681922),
    //   name: 'Deschutes Brewery',
    //   description:
    //       'Beers brewed on-site & gourmet pub grub in a converted auto-body shop with a fireplace & wood beams.',
  
    //   starRating: 5,
    // ),
    // Place(
    //   id: '2',
    //   latLng: LatLng(33.516887, 36.675417),
    //   name: 'Luc Lac Vietnamese Kitchen',
    //   description:
    //       'Popular counter-serve offering pho, banh mi & other Vietnamese favorites in a stylish setting.',
    
    //   starRating: 5,
    // ),
    // Place(
    //   id: '3',
    //   latLng: LatLng(33.528952, 36.698344),
    //   name: 'Salt & Straw',
    //   description:
    //       'Quirky flavors & handmade waffle cones draw crowds to this artisinal ice cream maker\'s 3 parlors.',

    //   starRating: 5,
    // ),
    // Place(
    //   id: '4',
    //   latLng: LatLng(33.525253, 36.684423),
    //   name: 'TILT',
    //   description:
    //       'This stylish American eatery offers unfussy breakfast fare, cocktails & burgers in industrial-themed digs.',

    //   starRating: 4,
    // ),
    // Place(
    //   id: '5',
    //   latLng: LatLng(33.513485, 36.657982),
    //   name: 'White Owl Social Club',
    //   description:
    //       'Chill haunt with local beers, burgers & vegan eats, plus live music & an airy patio with a fire pit.',
    //   starRating: 4,
    // ),
    // Place(
    //   id: '6',
    //   latLng: LatLng(33.487137, 36.799940),
    //   name: 'Buffalo Wild Wings',
    //   description:
    //       'Lively sports-bar chain dishing up wings & other American pub grub amid lots of large-screen TVs.',
    //   starRating: 5,
    // ),
    // Place(
    //   id: '7',
    //   latLng: LatLng(33.416986, 36.743171),
    //   name: 'Chevys',
    //   description:
    //       'Lively, informal Mexican chain with a colorful, family-friendly setting plus tequilas & margaritas.',
    //   starRating: 4,
    // ),
    // Place(
    //   id: '8',
    //   latLng: LatLng(33.5390767, 36.34694),
    //   name: 'Cinetopia',
    //   description:
    //       'Moviegoers can take food from the on-site eatery to their seats, with table service in 21+ theaters.',
    //   starRating: 4,
    // ),
    // Place(
    //   id: '9',
    //   latLng: LatLng(33.5390747, 36.36690),
    //   name: 'Thai Cuisine',
    //   description:
    //       'Informal restaurant offering Thai standards in a modest setting, plus takeout & delivery.',
    //   starRating: 4,
    // ),
  ];

  static const reviewStrings = <String>[
    'My favorite place in Portland. The employees are wonderful and so is the food. I go here at least once a month!',
    'Staff was very friendly. Great atmosphere and good music. Would reccommend.',
    'Best. Place. In. Town. Period.'
  ];
}