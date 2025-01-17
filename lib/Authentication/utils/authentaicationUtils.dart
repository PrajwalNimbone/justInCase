import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthack/Authentication/loginPage.dart';
// import 'package:GoogleSignIn/SignInScreen.dart'
import 'package:google_sign_in/google_sign_in.dart';
import '../../widgets/homeScreen.dart';
TextEditingController emailAddressController = new TextEditingController();
TextEditingController password = new TextEditingController();
TextEditingController phoneNumber = new TextEditingController();


Future<void>signout(BuildContext context)async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  // String u = auth.currentUser!.uid;
  auth.signOut();
  print("doneeeee");
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
}
Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential? userCredential = await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(userId: value.user!.uid),));
      print("done");
    });


    // final User? user = userCredential.user;
    // print(user);

    // Use the user object for further operations or navigate to a new screen.
  } catch (e) {
    print(e.toString());
  }
}

Future<void> createUSerUsingEmailAddress(BuildContext context,emailAddress,password)async{
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    ).then((value) {
      print("user created successfully");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}
Future<void> phoneNumberAuthentication(BuildContext context) async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '+91 1111111111',
    verificationCompleted: (PhoneAuthCredential credential) {
      print("Verification completed");
      print("credential is ${credential}");
    },
    verificationFailed: (FirebaseAuthException e) {
      print("Verification Failed ${e}");
    },
    codeSent: (String verificationId, int? resendToken) async {
      String smsCode = "777888";
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      );

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential).then((value) {
        String uid = value.user?.uid ?? ''; // Extract UID from UserCredential

        // Navigate to the next screen and pass the UID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: uid),
          ),
        );
      });
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}


// function to implement the google signin

// creating firebase instance
final FirebaseAuth auth = FirebaseAuth.instance;
// final FirebaseAuth auth = FirebaseAuth.instance;



// Future<void> phoneNumberAuthentication(BuildContext context)async{
//   final FirebaseAuth auth =FirebaseAuth.instance;
//   await FirebaseAuth.instance.verifyPhoneNumber(
//     phoneNumber: '+91 1111111111',
//     verificationCompleted: (PhoneAuthCredential credential) {
//       print("Verification completed");
//       print("credential is ${credential}");
//     },
//     verificationFailed: (FirebaseAuthException e) {
//       print("Verification Failed ${e}");
//     },
//     codeSent: (String verificationId, int? resendToken) async{
//       String smsCode = "777888";
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode.trim());
//           print("code sent ");
//       // Sign the user in (or link) with the credential
//       await auth.signInWithCredential(credential).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(userId:value.toString()),)));
//
//     },
//     codeAutoRetrievalTimeout: (String verificationId) {},
//   );
// }