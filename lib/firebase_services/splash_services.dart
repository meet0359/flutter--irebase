import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/ui/upload_screen.dart';


import '../ui/auth/login_screen.dart';



class SplahshServices {
  void isLogic(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user!=null){
      
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => UploadImageScreen())));
            // post screen
            // FireStoreScreen()
    }
    else{
      
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }

  }
}
