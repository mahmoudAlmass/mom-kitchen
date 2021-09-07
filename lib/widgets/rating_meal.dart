import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MealRating extends StatefulWidget {
  final ValueChanged<double> onChanged;
  MealRating({required this.onChanged});
  @override
  _MealRatingState createState() => _MealRatingState();
}

class _MealRatingState extends State<MealRating> {
  double? _rating;
  double? _initialRating = 2.5;
  IconData? _selectedIcon;
  _MealRatingState();

  @override
  void initState() {
    super.initState();
    _rating = _initialRating;
  }
  double get rate=>_rating!;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        RatingBar.builder(
          initialRating: _initialRating!,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 25.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            widget.onChanged(rating);
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
