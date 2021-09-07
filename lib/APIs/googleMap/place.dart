import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String chiefId;
  final LatLng latLng;
  final String name;
  final int starRating;

  const Place({
    required this.id,
    required this.chiefId,
    required this.latLng,
    required this.name,
    this.starRating = 0,
  })  : 
        assert(starRating >= 0 && starRating <= 5);

  double get latitude => latLng.latitude;

  double get longitude => latLng.longitude;

  Place copyWith({
    String? id,
    String? chiefId,
    LatLng? latLng,
    String? name,
    int? starRating,
  }) {
    return Place(
      id: id ?? this.id,
      chiefId:chiefId ?? this.chiefId,
      latLng: latLng ?? this.latLng,
      name: name ?? this.name,
      starRating: starRating ?? this.starRating,
    );
  }
    static Place fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot){
    Map<String,dynamic> data= snapshot.data()! as Map<String,dynamic>;
    return fromJson(data);
  }

  static Place fromJson(Map<String, dynamic> json) => Place(
      id: json['id'],
      chiefId: json['chiefId'],
      latLng: LatLng(json['lati'],json['longi']),
      name: json['name'],
      starRating: json['starRating']
    );
    
    static Map<String, dynamic> toMap(Place place) => {
    'id': place.id,
    'chiefId':place.chiefId,
    'lati': place.latitude,
    'longi': place.longitude,
    'name': place.name,
    'starRating': place.starRating,
  };

}
