import 'package:flutter/material.dart';
import 'package:kitchen_ware_project/models/user.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final User other;

  const ProfileHeaderWidget({
    required this.other,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: EdgeInsets.all(16).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                Expanded(
                  child: Row(
                    children: [
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 12),
                         child: CircleAvatar(
            radius: 16,
              backgroundImage: NetworkImage(other.imageUrl!),
          ),
                       ),
                      Text(
                        other.userName!,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )  ,       
                    ],
                  ),
                ),
                SizedBox(width: 4),
              ],
            )
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );
}
