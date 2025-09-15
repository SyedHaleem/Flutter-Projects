import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/controller/GoogleAuthController.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebasework/view/authScreen/ForgotPassword.dart';
import 'package:firebasework/view/authScreen/SignupScreen.dart';
import 'package:firebasework/view/authScreen/VerifyEmailScreen.dart';
import 'package:firebasework/view/homeScreen/HomeScreen.dart';
import 'package:firebasework/view/mainScreen/MainScreen.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:firebasework/view/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GoogleAuthController googleCtrl = Get.put(GoogleAuthController(), permanent: true);
  final RxBool isLoggingIn = false.obs;

  @override
  Widget build(BuildContext context) {
    var isPasswordHidden = true.obs;
    return Scaffold(
      appBar: BasicAppbar(
        hideBackBtn: true,
        title: Image.asset('assets/vectors/Blog_logo.png', width: 200, height: 200),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _signinText(),
                const SizedBox(height: 76),
                _emailField(context),
                const SizedBox(height: 16),
                _passwordField(context, isPasswordHidden),
                const SizedBox(height: 20),
                _recoveryPassword(context),
                const SizedBox(height: 22),
                Obx(() => AppButton(
                  onPressed: isLoggingIn.value
                      ? null // Disable button while logging in
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      isLoggingIn.value = true; // Start loading
                      try {
                        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _email.text.trim(),
                          password: _password.text,
                        );
                        await userCredential.user?.reload();
                        if (userCredential.user != null && userCredential.user!.emailVerified) {
                          Get.find<HomeController>().setCurrentUserId(userCredential.user!.uid);
                          await Get.find<UserProfileController>().saveDeviceToken(userCredential.user!.uid);
                          Get.offAll(() => MainScreen());
                        } else {
                          Get.to(() => const VerifyEmailScreen());
                          Get.snackbar(
                            'Not Verified',
                            'Please verify your email before continuing.',
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        Get.snackbar('Error', e.message ?? 'Login failed', backgroundColor: Colors.red, colorText: Colors.white);
                      } finally {
                        isLoggingIn.value = false; // Stop loading
                      }
                    }
                  },
                  title: isLoggingIn.value ? 'Logging in...' : 'Sign In',
                )),
                const SizedBox(height: 33),
                _divider(context),
                const SizedBox(height: 15),
                _logos(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _registerText(context),
    );
  }

  Widget _signinText() {
    return const Text(
      textAlign: TextAlign.center,
      'Sign in',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _passwordField(BuildContext context, RxBool isPasswordHidden) {
    return Obx(() => TextFormField(
      controller: _password,
      obscureText: isPasswordHidden.value,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(isPasswordHidden.value ? Icons.visibility_off : Icons.visibility),
          onPressed: () => isPasswordHidden.value = !isPasswordHidden.value,
        ),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    ));
  }

  Widget _recoveryPassword(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ForgotPasswordScreen());
          },
          child: const Text(
            'Recovery Password',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _registerText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Not A Member?', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          TextButton(
            onPressed: () {
              Get.to(() => SignupScreen());
            },
            child: const Text('Register Now', style: TextStyle(color: Color(0xff288CE9))),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade500,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Or",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade500,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _logos(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() =>
        googleCtrl.isGoogleSigningIn.value
            ? const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(color: AppColors.primary,),
        )
            : GestureDetector(
          onTap: () => googleCtrl.signInWithGoogle(),
          child: SvgPicture.asset('assets/vectors/googleicon.svg'),
        )
        ),
        SvgPicture.asset('assets/vectors/apple.svg'),
      ],
    );
  }
}