import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/block.jpg'),
          fit: BoxFit.cover,
        ),
      
      ),
      
    
    );
  }


}
