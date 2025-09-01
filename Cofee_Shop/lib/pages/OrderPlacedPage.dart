import 'package:cofee_shop/config/Colors.dart';
import 'package:cofee_shop/pages/Home.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPlacedPage extends StatefulWidget {
  const OrderPlacedPage({super.key});

  @override
  State<OrderPlacedPage> createState() => _OrderPlacedPageState();
}

class _OrderPlacedPageState extends State<OrderPlacedPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsiveness variables
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleFactor = screenWidth / 392.0; // Reference width for scaling

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(top: 169 * scaleFactor),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/orderplacedBg.png'),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Thank you!',
                  style: TextStyle(
                    fontSize: 26 * scaleFactor,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30 * scaleFactor),
                Text(
                  'You have placed your order Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26 * scaleFactor,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 59 * scaleFactor),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30 * scaleFactor,
                      vertical: 15 * scaleFactor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10 * scaleFactor),
                    ),
                  ),
                  onPressed: () {
                    Get.to(const Home());
                  },
                  child: Text(
                    'View More Options',
                    style: TextStyle(
                      color: CofeeBox,
                      fontSize: 16 * scaleFactor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Confetti animation
          Align(
            alignment: const Alignment(0, -0.5),
            child: ConfettiWidget(
              numberOfParticles: 20,
              displayTarget: true,
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // Random directions
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
              ], // Custom colors
              gravity: 0.2, // Slows down the confetti
            ),
          ),
        ],
      ),
    );
  }
}