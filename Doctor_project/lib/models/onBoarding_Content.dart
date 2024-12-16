class onBoarding_Content {
   String heading;
   String image;
   String paragraph;

  onBoarding_Content({required this.heading,required this.image, required this.paragraph});
}
  List<onBoarding_Content> contents=
      [
        onBoarding_Content
          (
            heading: 'Find a Doctor',
            image: 'assets/images/pic1.png',
            paragraph: 'Discover and connect with trusted doctors online and in-clinic for convenient and presonalized care.'
        ),
        onBoarding_Content
          (
            heading: 'Lab Tests Discounts',
            image: 'assets/images/pic2.png',
            paragraph: 'Save on lab tests with exclusive discounts.compare prices across labs’ and enjoy the convenlence of home'
        ),
        onBoarding_Content
          (
            heading: 'Medicines Made Easy',
            image: 'assets/images/pic3.png',
            paragraph: 'Access medications hassle - free with discounts, home delivery, and convenient subscription plans.'
        ),
        onBoarding_Content
          (
            heading: 'Weight Loss Clinic',
            image: 'assets/images/pic4.png',
            paragraph: 'Achieve health goals with expert guidance, personalized programs, ongoing support, and a monthly quarterly'
        ),
      ];
