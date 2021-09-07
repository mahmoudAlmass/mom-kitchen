import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirestoreUploadImages {

    
    Future<String> getImage(bool camera)async{
    final ImagePicker _picker = ImagePicker();
    String url="";
    
    final XFile? image = await _picker.pickImage(source: camera? ImageSource.camera: ImageSource.gallery);
        if(image!=null)
        {
          url=image.path.toString();
          File file =  File(url);
          String downloadUrl=await uploadImage(file);
          return downloadUrl;
        }else{
          return"https://i2.wp.com/ultravires.ca/wp/wp-content/uploads/2018/03/Then-and-Now_-no-image-found.jpg?w=275";
        }
    }



Future<String> uploadImage(imageFile) async {
  String postId = Uuid().v4();
    firebase_storage.UploadTask uploadTask = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("post_$postId.jpg")
        .putFile(imageFile);
    firebase_storage.TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

//   createPostFirestore({String mediaUrl, String location, String description}) {
//     Firestore.instance
//         .collection("posts")
//         .document("IRANmXu9VoXE1HT9STfWbpemQ1Q2")
//         .collection("usersPosts")
//         .document(postId)
//         .setData({
//       "postId": postId,
//       "ownerId": "IRANmXu9VoXE1HT9STfWbpemQ1Q2",
//       "username": "aya",
//       "mediaUrl": mediaUrl,
//       "description": description,
//       "location": "hamesh",
//       "timestamp": timestamp,
//       "likes": {}
//     });


  
// }

}
