// import 'package:flutter/material.dart';
// import 'package:kitchen_ware_project/models/category.dart';
// import 'package:kitchen_ware_project/models/meal.dart';
// import 'package:kitchen_ware_project/modules/image_picker.dart';
// import 'package:kitchen_ware_project/providers/meal_provider.dart';
// import 'package:kitchen_ware_project/providers/user_provider.dart';
// import 'package:provider/provider.dart';
// class CreateItemScreen extends StatefulWidget {
//   @override
//   _CreateItemScreenState createState() => _CreateItemScreenState();
// }

// class _CreateItemScreenState extends State<CreateItemScreen> {

// final _descriptionFocusNode = FocusNode();
// final _imageFocusNode= FocusNode();
// final _imageURLController = TextEditingController();
// final _form = GlobalKey<FormState>();

// late Meal _meal;
// Category _category=Category();

// @override
//   void initState() {
    
//     super.initState();
//     _meal=Meal();
//     List<Category>cats=[];
// cats.add(Category(title: "one"));
// cats.add(Category(title: "two"));
// cats.add(Category(title: "three"));

// _meal=_meal.copyWith(categories: cats);
//   }
// var _initValue={
//   'description':'',
//   'imageURL':'',
//   'cat1': '',
//   'cat2':'',
// };
// var _isLoading=false;


// Future<void> _saveForm() async{
  
//   final isValid = _form.currentState!.validate();

//   if(!isValid)
//   return ;

//   _form.currentState!.save();
//   setState(() {
//     _isLoading=true;
//   });

//     try{
 
//       await Provider.of<MealProvider>(context, listen: false).addMeal(_meal);
//     }catch(error){
//       print(error);
//   await showDialog(context: context, builder:(ctx)=> AlertDialog(
//       title: Text('An error occurred!'),
//       content: Text('Something went wrong.'),
//       actions: <Widget>[
//         TextButton(
//           child: Text('Okay'),
//           onPressed: (){
//           Navigator.of(ctx).pop();
//         },
//         ) 
//       ],
//     ),
//     );
//     }
    
  
//     setState(() {
//           _isLoading=false;
//         });
//     Navigator.of(context).pop();
// }

//   @override
//   Widget build(BuildContext context) {
// final imagePicker= Provider.of<ImagePickingHandler>(context,listen: false);
// final userProv = Provider.of<UserProvider>(context,listen: false);

// _meal=_meal.copyWith(chefId:userProv.logedUser!.userID);

//     return Scaffold(
//           body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _form,
//             child: ListView(
//               children: [

//                   TextFormField(
//                   initialValue: _initValue['description'],
//                   decoration: InputDecoration(
//                   labelText:'Description' ),
//                   maxLines: 3,
//                   keyboardType: TextInputType.multiline,
//                   focusNode: _descriptionFocusNode,
//                   validator: (value){
//                     if(value!.isEmpty){
//                       return 'this field can\'t be empty!';
//                     }
//                     return null;
//                   },
//                   onSaved: (value){
//                     _meal = _meal.copyWith(description: value);
//                   }, 
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         child:Text("Pick image") ,
//                         onPressed: ()async{
//                           await imagePicker.pickImage().then((url) {
                            
//                             if(url.isNotEmpty){
//                               print(url.toString());
//                               _meal=_meal.copyWith(imageUrl: url.toString());
//                             }
//                           });
//                         },
//                         ),
//                     // Container(
//                     //   width: 100,
//                     //   height: 100,
//                     //   margin: EdgeInsets.only(top: 8.0,right: 10.0),
//                     //   decoration: BoxDecoration(
//                     //     border: Border.all(width: 1, color: Colors.grey),
//                     //   ),
//                     //   child: _imageURLController.text.isEmpty? Text('Enter a URL') :FittedBox(
//                     //   child: Image.network(_imageURLController.text , fit: BoxFit.cover,),
//                     //   ),
//                     // ),
      
//                   ],
//                   ),
//                   TextButton(child: Text("send"),
//                   onPressed: ()async{
//                     await _saveForm();
//                   },
//                   ),
//               ],
//               ),
//           )
//           ),
//     );
//   }
// }