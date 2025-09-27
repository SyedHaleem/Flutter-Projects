import 'package:face_recognition_app/controller/RegistrationController.dart';
import 'package:face_recognition_app/view/widgets/FacePainter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RegistrationController>();
    final screenWidth = MediaQuery.of(context).size.width;

    Widget mainContent = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Face Registration",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: screenWidth / 1.15,
          height: screenWidth / 1.15,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFF0E6FD), // lighter purple, still visible
                Color(0xFFDDEBFB),],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(75),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: _buildPreview(controller),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _gradientButton(
              icon: Icons.image,
              label: "Gallery",
              onTap: () async {
                final regController = context.read<RegistrationController>();
                regController.setupDialogCallback(context, showSnackbar: (msg) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                });
                await regController.imgFromGallery();
              },
              width: screenWidth * 0.4,
            ),
            _gradientButton(
              icon: Icons.camera_alt,
              label: "Camera",
              onTap: () async {
                final regController = context.read<RegistrationController>();
                regController.setupDialogCallback(context, showSnackbar: (msg) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                });
                await regController.imgFromCamera();
              },
              width: screenWidth * 0.4,
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          // Changed background gradient to light linear purple
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
          ),
        ),
        child: SafeArea(child: mainContent),
      ),
    );
  }

  Widget _buildPreview(RegistrationController controller) {
    if (!controller.recognizerReady) {
      return  Center(child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Color(0xFFF0E6FD), Color(0xFFDDEBFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: const CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // This is ignored due to the ShaderMask
          backgroundColor: Colors.transparent,
        ),
      ));
    }
    if (controller.loadingState == RegistrationLoadingState.loadingImage) {
      return  Center(child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Color(0xFFF0E6FD), Color(0xFFDDEBFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: const CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // This is ignored due to the ShaderMask
          backgroundColor: Colors.transparent,
        ),
      ));
    }
    if (controller.uiImage != null && controller.imageFile != null) {
      return Stack(
        children: [
          CustomPaint(
            size: Size(controller.uiImage!.width.toDouble(),
                controller.uiImage!.height.toDouble()),
            painter: FacePainter(
              facesList: controller.faces,
              imageFile: controller.uiImage,
            ),
          ),
          if (controller.loadingState == RegistrationLoadingState.detectingFaces)
            Container(
              color: Colors.black38,
              child: Center(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFFF0E6FD), Color(0xFFDDEBFB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // This is ignored due to the ShaderMask
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      return Image.asset("assets/images/logo.png", fit: BoxFit.fill);
    }
  }

  Widget _gradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    double width = 150,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFF0E6FD), // lighter purple, still visible
              Color(0xFFDDEBFB),],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}