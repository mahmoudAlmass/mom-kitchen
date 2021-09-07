import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()

class Category {
  final String? id;
  final String? title;

  final String? imageUrl;

  Category({
    this.id,
    this.title,
    this.imageUrl,
  
  });

    Category copyWith({
    String? id,
    String? title,
    String? imageUrl,
  }) =>
      Category(
        id: id ?? this.id,
        title: title ?? this.title,
        imageUrl: imageUrl?? this.imageUrl,
      );

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

