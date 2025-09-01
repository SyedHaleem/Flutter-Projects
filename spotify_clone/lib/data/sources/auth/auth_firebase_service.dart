import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/data/models/auth/signin_user_request.dart';

abstract class AuthFirebaseService{
  Future<Either> signup(CreateUserRequest createUserRequest);
  Future<Either> signin(SigninUserRequest signinUserRequest);
}

class AuthFirebaseImpl extends AuthFirebaseService{
  @override
  Future<Either> signin(SigninUserRequest signinUserRequest) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: signinUserRequest.email, password: signinUserRequest.password);
      return Right("Signin was Successfull");
    } on FirebaseException catch (e){
      String message= '';
      if(e.code=='invalid-email'){
        message = "Not User Found for that Email";
      }
      else if(e.code=='invalid-credential')
      {
        message= "Wrong password provided for that user";
      }
      return Left(message);
    }}


  @override
  Future<Either> signup(CreateUserRequest createUserRequest) async{
    try{

      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: createUserRequest.email, password: createUserRequest.password);
      FirebaseFirestore.instance.collection('Users').add({
        'name': createUserRequest.fullName,
        'email': data.user?.email
      });
      return Right("Signup was Successfull");
    } on FirebaseException catch (e){
      String message= '';
      if(e.code=='weak-password'){
        message = "the password provided is too weak";
      }
      else if(e.code=='email-already-in-use')
        {
          message= "An account already exists with that email.";
        }
      return Left(message);
    }
  }

}