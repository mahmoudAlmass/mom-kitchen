// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http; 
// import 'dart:io';


// class ImagePickingHandler extends ChangeNotifier{
//     String url="";
//     String imageUrlOnServer="";
//     final ImagePicker _picker = ImagePicker();

//     Future<String> pickImage()async{
//       await getImage();
//       await sendFileToServer();
//       return imageUrlOnServer;
//     }
//     Future getImage()async{
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//         if(image!=null)
//         {
//           url=image.path.toString();
//           notifyListeners();
//         }
//     }

//     Future<void>sendFileToServer()async{
//     var postUri = Uri.parse("https://api.imgur.com/3/image.json");
//     var request = new http.MultipartRequest("POST", postUri);
//     request.headers['Authorization']='Client-ID d296c3e0aaf43b5';
//     request.files.add(new http.MultipartFile.fromBytes('image',
//     await File.fromUri(Uri.parse(url)).readAsBytes()
//     ));
  
//     request.send().then((response) {
//       if (response.statusCode == 200) 
//       {
//         response.stream.transform(utf8.decoder).listen((value) {
//           var index = value.indexOf("https:");
//           var str = value.substring(index);
//           var i = str.indexOf("\"}");
//           str = str.substring(0,i);
//           str=str.replaceAll("\\", "");

//           imageUrlOnServer=str;
//           notifyListeners();
//         });
//       }
//     });
//     }

//     String get imageUrl => imageUrlOnServer;
// }



