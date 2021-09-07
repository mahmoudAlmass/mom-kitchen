import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:kitchen_ware_project/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  
  //create user object 
  User? _userFromFirebase(auth.User? user ){
      
    return user == null ? null :User(userID: user.uid, email: user.email);
    
  }

    Future<void> _createUser(auth.User? user ,String name, bool isCheif)async{
      if(user==null){
      return ;
    }else{
      User _newUser=User(
      userID: user.uid,  
      email: user.email,
      isChief: isCheif,
      userName: name,
      numberOfLoves: 0,
      imageUrl: "https://icon-library.com/images/no-user-image-icon/no-user-image-icon-3.jpg",
      backgroungProfileImage :"https://firebasestorage.googleapis.com/v0/b/kitchen-9213d.appspot.com/o/photo_2021-08-31_20-05-08.jpg?alt=media&token=1ba8faa3-4562-48cb-9f44-9a1812c8a73f", 
      );
      
      await addUser(_newUser);
    }
    }
    Future<void> addUser(User user)async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(user.userID)
    .set(user.toJson());

    // final doc =FirebaseFirestore.instance.collection('users').where('email',isEqualTo:user.email);
    // await doc.get().then((docSnapshot) {
    //   if(docSnapshot.size==0){
    //     final userDoc = usersCollection.doc();
    //     final newUser= user.copyWith(userID: userDoc.id);
    //     userDoc.set(User.toMap(newUser)).catchError((e)=>print(e));
    //   }
    // });
  }
  
  // auth change user stream 
  Stream<User?> get user{
    return _auth.authStateChanges().map(_userFromFirebase) ;   
  }
  // sign in anon

  Future signInAnonymously() async{
    try{
      auth.UserCredential result = await _auth.signInAnonymously();
      auth.User? _user=result.user;
      return _userFromFirebase(_user);
    }catch(e){
      print(e);
      return null;
    }
  }
  // sign in with email & password
    Future signInWithEmailAndPassword(String email,String password)async{
    try{
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      auth.User? _user = result.user;
      
      return _userFromFirebase(_user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // regestir with email & password 
  Future registerWithEmailAndPassword(String email,String password,String name,bool isCheif)async{
    try{
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      auth.User? _user = result.user;
      await _createUser(_user,name,isCheif);
      return _userFromFirebase(_user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // // sign out
  Future signOut () async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}