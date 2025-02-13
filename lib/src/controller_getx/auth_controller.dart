import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:managerfoodandcoffee/src/common_widget/snack_bar_getx.dart';
import 'package:managerfoodandcoffee/src/firebase_helper/firebase_auth.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/admin_panel/admin_panel.dart';
import 'package:managerfoodandcoffee/src/screen/desktop/login_screen/login_screen.dart';
import 'package:managerfoodandcoffee/src/shared_preferences/shared_preference.dart';

class AuthController extends GetxController {
  var userName = "".obs;
  var email = "".obs;
  var urlAvatar = "".obs;

  final auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Completer<void>? completer; // Declare a Completer as nullable

  Future loginGoogleInWeb() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      completer ??= Completer<void>();

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
        User? user = userCredential.user;
        if (user != null) {
          userName.value = user.displayName!;
          email.value = user.email!;
          urlAvatar.value = user.photoURL!;

          Get.offAll(() => const AdminPanelScreen());
        }
      } on FirebaseAuthException catch (e) {
        showCustomSnackBar(
            title: "Lỗi", message: e.toString(), type: Type.error);
      } finally {
        completer!.complete(); // Complete the Future
      }
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    await GoogleSignIn().disconnect();
    await GoogleSignIn().isSignedIn();

    Get.offAll(() => const LoginScreen());
  }

  void register(
      {required String email,
      required String password,
      required String fullname}) async {
    final response = await FireBaseAuth().registerWithEmailAndPassword(
      email: email,
      password: password,
      fullname: fullname,
    );
    if (response != null) {
      // print(response);
      showCustomSnackBar(
          title: "Thành công",
          message:
              'Đăng ký thành công, hãy kiểm tra email và xác thực tài khoản',
          type: Type.success);
      MySharedPreferences.saveEmail(email);
      logout();
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await FireBaseAuth().loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response != null) {
        userName.value = response.user?.displayName ?? '';
        urlAvatar.value = response.user?.photoURL ?? '';
        Get.offAll(() => const AdminPanelScreen());
        MySharedPreferences.saveEmail(email);
      }
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(
          title: "Lỗi", message: e.toString(), type: Type.error);
    }
  }

  void forgotPassword({required String email}) async {
    try {
      await FireBaseAuth().forgotPassword(email: email);
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(
          title: "Lỗi", message: e.toString(), type: Type.error);
    }
  }
}
