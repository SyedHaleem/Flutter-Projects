import 'package:cofee_shop/components/CustomBottomNavigatorButton.dart';
import 'package:cofee_shop/config/Colors.dart';
import 'package:cofee_shop/pages/OrderPlacedPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
class PaymentMethod extends StatelessWidget {
  final double totalPrice;

  const PaymentMethod({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final RxBool isCardSelected = false.obs; // Tracks whether card is selected

    // Text Editing Controllers
    final cardNumberController = TextEditingController();
    final expController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

    // Screen dimensions for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const baseWidth = 411.0; // Pixel 5 XL base width
    const baseHeight = 823.0;

    final widthScale = screenWidth / baseWidth;
    final heightScale = screenHeight / baseHeight;
    double scale(double value) => value * widthScale;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: scale(20), color: Colors.brown),
          onPressed: () => Get.back(),
        ),
        titleSpacing: scale(40),
        title: Text(
          "Payment Method",
          style: TextStyle(
            fontSize: scale(24),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: scale(35.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: scale(74)),
            // Custom Radio Button
            Obx(
                  () => GestureDetector(
                onTap: () {
                  isCardSelected.value = !isCardSelected.value;
                },
                child: Row(
                  children: [
                    Icon(
                      isCardSelected.value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: scale(24),
                      color: Colors.brown,
                    ),
                    SizedBox(width: scale(15)),
                    Text(
                      "Pay with Debit/Credit Card",
                      style: TextStyle(
                        fontSize: scale(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: scale(38)),
            // Conditional Visibility for Card Details
            Obx(
                  () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isCardSelected.value
                    ? Column(
                  key: const Key("CardDetails"), // Unique key for rebuilds
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Number',
                      style: TextStyle(
                        fontSize: scale(18),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7C7B7B),
                      ),
                    ),
                    TextFormField(onTap: (){isCardSelected.value=true;},
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "XXXX XXXX XXXX XXXX",
                        hintStyle: TextStyle(fontSize: scale(16)),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7C7B7B)),
                        ),
                      ),
                    ),
                    SizedBox(height: scale(20)),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exp',
                                style: TextStyle(
                                  fontSize: scale(18),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF7C7B7B),
                                ),
                              ),
                              TextFormField(
                                controller: expController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: "MM/YY",
                                  hintStyle: TextStyle(fontSize: scale(16)),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF7C7B7B)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: scale(21)),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CVV',
                                style: TextStyle(
                                  fontSize: scale(18),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF7C7B7B),
                                ),
                              ),
                              TextFormField(
                                controller: cvvController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "XXX",
                                  hintStyle: TextStyle(fontSize: scale(16)),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF7C7B7B)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: scale(20)),
                    Text(
                      'Name on the Card',
                      style: TextStyle(
                        fontSize: scale(18),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7C7B7B),
                      ),
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        hintStyle: TextStyle(fontSize: scale(16)),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7C7B7B)),
                        ),
                      ),
                    ),
                  ],
                )
                    : const SizedBox.shrink(), // Empty widget when hidden
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigatorButton(
        isPrice: true,
        totalAmount: totalPrice,
        onPressed: () => Get.to(const OrderPlacedPage()),
        btn_text: 'Pay Now',
      ),
    );
  }
}
