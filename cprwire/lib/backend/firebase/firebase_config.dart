import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCAIA1wcZoQP8pNxYiymwe_kxPwNKt3ZJw",
            authDomain: "cprwire-igjnyu.firebaseapp.com",
            projectId: "cprwire-igjnyu",
            storageBucket: "cprwire-igjnyu.firebasestorage.app",
            messagingSenderId: "147360425243",
            appId: "1:147360425243:web:b81ef68b1b33720fec5fbe"));
  } else {
    await Firebase.initializeApp();
  }
}
