import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:spotify_clone/common/widgets/appbar/appbar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_Button.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/data/models/auth/signin_user_request.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/presentation/auth/pages/signup_page.dart';
import 'package:spotify_clone/presentation/home/pages/home.dart';
import 'package:spotify_clone/service_locator.dart';

class SigninPage extends StatelessWidget {
   SigninPage({super.key});
  final TextEditingController _email = TextEditingController();
   final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 50,horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _signinText(),
              SizedBox(height: 76,),
              _emailField(context),
              SizedBox(height: 16,),
              _passwordField(context),
              SizedBox(height: 20,),
              _recoveryPassword(context),
              SizedBox(height: 22,),
              AppButton(onPressed: () async {
                var result = await sl<SigninUseCase>().call(
                    params: SigninUserRequest(
                        _email.text.toString(), _password.text.toString()));
                result.fold((l) {
                  var snackbar = SnackBar(content: Text(l));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                        (r) {
                      Get.to(HomePage());
                    });
              }, title: 'Sign In'),
              SizedBox(height: 33,),
              _divider(context),
              SizedBox(height: 15,),
              _logos(context),
            ],
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

  Widget _emailField(BuildContext context){
    return TextField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Enter Username or Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

   Widget _passwordField(BuildContext context) {
     var isPasswordHidden = true.obs;
     return Obx(() => TextField(
       controller: _password,
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
     ));
   }


   Widget _recoveryPassword(context){
    return Row(
      children: [
      Text('Recovery Password',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
      ],

    );
  }

  Widget _registerText(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Not A Member?',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
          TextButton(onPressed: (){Get.to(SignupPage());}, child: Text('Register Now',style: TextStyle(color: Color(0xff288CE9)),)),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context)
  {
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

  Widget _logos(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(AppVectors.google,),
        SvgPicture.asset(AppVectors.apple,color: context.isDarkMode?Colors.white:Colors.black,),
      ],);
  }
}
