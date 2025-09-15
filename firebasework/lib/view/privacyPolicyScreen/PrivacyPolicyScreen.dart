import 'package:firebasework/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebasework/config/theme/app_Color.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(title: Text('Privacy Policy',style: TextStyle(color: AppColors.primary),),),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Our App!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app. Please read this policy carefully.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),
            _policySection(
              title: "Information We Collect",
              content: [
                "• Personal Information: When you sign up, we collect your name, email address, and profile image.",
                "• Usage Information: We collect information about how you use the app, such as blogs you create or interact with.",
                "• Device Information: We may collect information about your device, such as device type and operating system, to improve user experience."
              ],
            ),
            const SizedBox(height: 20),
            _policySection(
              title: "How We Use Your Information",
              content: [
                "• To provide, operate, and maintain the app.",
                "• To personalize your experience, such as displaying your profile information and content.",
                "• To improve our products and services.",
                "• To communicate with you about important updates or features.",
              ],
            ),
            const SizedBox(height: 20),
            _policySection(
              title: "Disclosure of Your Information",
              content: [
                "• We do not sell your personal information.",
                "• Your information may be shared with service providers who help us operate the app (e.g., Firebase, image hosting).",
                "• We may disclose information if required by law or to protect app integrity.",
              ],
            ),
            const SizedBox(height: 20),
            _policySection(
              title: "Security",
              content: [
                "• We implement reasonable security measures to protect your information.",
                "• Please remember that no method of transmission over the internet or electronic storage is 100% secure.",
              ],
            ),
            const SizedBox(height: 20),
            _policySection(
              title: "Your Choices",
              content: [
                "• You can update your profile information at any time within the app.",
                "• You may request deletion of your account by contacting support.",
              ],
            ),
            const SizedBox(height: 20),
            _policySection(
              title: "Children's Privacy",
              content: [
                "• Our app is not intended for children under 13. We do not knowingly collect personal information from children under 13.",
              ],
            ),
            const SizedBox(height: 20),
            _policySection(
              title: "Changes to This Policy",
              content: [
                "• We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app.",
              ],
            ),
            const SizedBox(height: 20),
            _policySection(
              title: "Contact Us",
              content: [
                "• If you have questions or concerns about this Privacy Policy, please contact us at support@yourapp.com.",
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "Last updated: August 2025",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _policySection({required String title, required List<String> content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6),
        ...content.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(e, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        )),
      ],
    );
  }
}