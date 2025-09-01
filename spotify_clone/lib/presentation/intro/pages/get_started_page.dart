import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_Button.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/presentation/choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.introbg),
                  fit: BoxFit.fill
              ),
            ),
          ),

          // Black Overlay (Keep it at the Bottom of Stack)
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                const Spacer(),
                const Text(
                  'Enjoy Listening To Music',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17
                  ),
                ),
                const SizedBox(height: 21),
                const Text(
                  textAlign: TextAlign.center,
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Sagittis enim purus sed phasellus. '
                      'Cursus ornare id scelerisque aliquam.',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                      fontSize: 12
                  ),
                ),
                const SizedBox(height: 37),

                // Get Started Button
                AppButton(
                    onPressed: () {
                      Get.to(() => const ChooseMode());
                    },
                    title: 'Get Started'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
