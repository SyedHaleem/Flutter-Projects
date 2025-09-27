import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'HomeScreen.dart';

class SplashTextProvider extends ChangeNotifier {
  final String appName;
  final Duration typingDelay;
  String _displayedText = "";
  int _charIndex = 0;
  Timer? _timer;
  bool isTypingFinished = false;

  SplashTextProvider({required this.appName, required this.typingDelay}) {
    _startTyping();
  }

  String get displayedText => _displayedText;

  void _startTyping() {
    _timer = Timer.periodic(typingDelay, (timer) {
      if (_charIndex < appName.length) {
        _displayedText += appName[_charIndex];
        _charIndex++;
        notifyListeners();
      } else {
        isTypingFinished = true;
        notifyListeners();
        _timer?.cancel();
      }
    });
  }

  void finish() {
    _timer?.cancel();
    _displayedText = appName;
    _charIndex = appName.length;
    isTypingFinished = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String appName = "IdentiFy";
  static const Duration animationDuration = Duration(seconds: 6);
  static const Duration typingDelay = Duration(milliseconds: 400);
  bool _navigated = false;

  void _goToHome() {
    if (!_navigated) {
      _navigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeGradient = const LinearGradient(
      colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return ChangeNotifierProvider(
      create: (_) => SplashTextProvider(
        appName: appName,
        typingDelay: typingDelay,
      ),
      builder: (context, child) {
        // Get provider here, so it's available
        final provider = Provider.of<SplashTextProvider>(context, listen: false);
        // Start the timer after the provider is available in the tree
        Future.delayed(animationDuration, () {
          if (!provider.isTypingFinished) {
            provider.finish();
            Future.delayed(const Duration(milliseconds: 400), _goToHome);
          } else {
            _goToHome();
          }
        });

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: themeGradient),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Consumer<SplashTextProvider>(
                builder: (context, provider, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              Color(0xFF7B2CBF), // Medium-dark purple
                              Color(0xFF4361EE),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          provider.displayedText,
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: Colors.white, // Must be white for gradient to show
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Lottie.asset(
                        'assets/animations/Progress Bar - Gradient.json',
                        width: 220,
                        repeat: false,
                        animate: true,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}