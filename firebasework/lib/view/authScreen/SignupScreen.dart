import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/controller/GoogleAuthController.dart';
import 'package:firebasework/controller/signup_controller.dart';
import 'package:firebasework/view/authScreen/LoginScreen.dart';
import 'package:firebasework/view/widgets/appbar.dart';
import 'package:firebasework/view/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final SignupController ctrl = Get.put(SignupController());
  final GoogleAuthController googleCtrl = Get.put(GoogleAuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    var isPasswordHidden = true.obs;
    return Scaffold(
      appBar: BasicAppbar(
        title: Image.asset('assets/vectors/Blog_logo.png', width: 200, height: 200,),
        onBack: () {
          ctrl.fullNameController.clear();
          ctrl.emailController.clear();
          ctrl.passwordController.clear();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Form(
            key: ctrl.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _registerText(),
                const SizedBox(height: 47),
                _fullnameField(context),
                const SizedBox(height: 16),
                _emailField(context),
                const SizedBox(height: 16),
                _passwordField(context, isPasswordHidden),
                const SizedBox(height: 33),
                Obx(() => AppButton(
                  onPressed: ctrl.isLoading.value ? null : () {
                    ctrl.registerUser(context);
                  },
                  title: ctrl.isLoading.value ? 'Creating Account...' : 'Create Account',
                )),
                const SizedBox(height: 17),
                _divider(context),
                const SizedBox(height: 10),
                _logos(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _signinText(context),
    );
  }

  Widget _registerText() {
    return const Text(
      textAlign: TextAlign.center,
      'Register',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget _fullnameField(BuildContext context) {
    return TextFormField(
      controller: ctrl.fullNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: 'Full Name',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        if (value.trim().length < 3) {
          return 'Full name must be at least 3 characters';
        }
        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
          return 'Name can only contain letters and spaces';
        }
        return null;
      },
    );
  }

  Widget _emailField(BuildContext context) {
    return TextFormField(
      controller: ctrl.emailController,
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
      controller: ctrl.passwordController,
      obscureText: isPasswordHidden.value,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(isPasswordHidden.value
              ? Icons.visibility_off
              : Icons.visibility),
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

  Widget _signinText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have account?',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          TextButton(
              onPressed: () {
                ctrl.fullNameController.clear();
                ctrl.emailController.clear();
                ctrl.passwordController.clear();
                Get.off(() => LoginScreen());
              },
              child: const Text(
                'Sign in',
                style: TextStyle(color: Color(0xff288CE9)),
              )),
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