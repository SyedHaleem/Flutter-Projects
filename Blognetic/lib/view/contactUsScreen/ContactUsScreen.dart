import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/view/widgets/AppButton.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ContactUsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  var isSubmitting = false.obs;

  // TODO: Replace these with your own SMTP credentials!
  final String smtpUsername = dotenv.env["GMAIL_MAIL"]!;
  final String smtpPassword = dotenv.env["GMAIL_PASSWORD"]!;

  Future<void> submitContact(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      Get.snackbar('Incomplete', 'Please fill all the fields.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isSubmitting.value = true;
    try {
      final smtpServer = gmail(smtpUsername, smtpPassword);
      final message = Message()
        ..from = Address(smtpUsername, 'Blognetic')
        ..recipients.add('syedhaleem899@gmail.com')
        ..subject = 'Contact Us Form Submission'
        ..text = '''
Name: ${nameController.text}
Email: ${emailController.text}
Phone: ${phoneController.text}
Message:
${messageController.text}
''';

      // Try sending. If no exception, treat as sent.
      await send(message, smtpServer);

      Get.snackbar('Thank you!', 'Your message has been sent. We appreciate your feedback!',
          backgroundColor: AppColors.primary, colorText: Colors.white);
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      messageController.clear();

    } catch (e) {
      Get.snackbar('Error', 'Failed to send: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }
}

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});
  final ctrl = Get.put(ContactUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppbar(
      title: Text('Contact Us' ,style: TextStyle(color: AppColors.primary),),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            const Text(
              'Assalam o Alaikum,',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const SizedBox(height: 7),
            const Text(
              'We love to hear your problems and kind words. talk to Us:)',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 28),
            _ContactField(
              hint: 'Name',
              controller: ctrl.nameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _ContactField(
              hint: 'Email',
              controller: ctrl.emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _ContactField(
              hint: 'Phone Number',
              controller: ctrl.phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _ContactField(
              hint: 'Enter Message',
              controller: ctrl.messageController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 30),
            Obx(() => AppButton(
              onPressed: ctrl.isSubmitting.value
                  ? null
                  : () => ctrl.submitContact(context),
              title: ctrl.isSubmitting.value ? 'Submitting...' : 'Submit',
            )),
          ],
        ),
      ),
    );
  }
}

class _ContactField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;

  const _ContactField({
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 17, horizontal: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
      ),
    );
  }
}