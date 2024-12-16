class hospitalcardcontent
{
  String heading;
  String imagepath;
  String address;

  hospitalcardcontent({required this.heading,required this.imagepath, required this.address});

}
List<hospitalcardcontent> hospitalcontents=
[
      hospitalcardcontent(heading: 'Pak Young Psychologisty', imagepath: 'assets/images/hospital1.png', address: 'Flat No 2,Aries'),
      hospitalcardcontent(heading: 'Evercare Hospital', imagepath: 'assets/images/hospital2.png', address: 'Nespak Society'),
      hospitalcardcontent(heading: 'Hameed Latif Hospital', imagepath: 'assets/images/hospital2.png', address: '14 New Abu Bakar Block,'),

      hospitalcardcontent(heading: 'Pak Young Psychologisty', imagepath: 'assets/images/hospital3.png', address: 'Flat No 2,Aries'),
      hospitalcardcontent(heading: 'Evercare Hospital', imagepath: 'assets/images/hospital4.png', address: 'Nespak Society'),
      hospitalcardcontent(heading: 'Rehman Medical Center', imagepath: 'assets/images/smith.png', address: '5/B-2 Phase-5'),
      hospitalcardcontent(heading: 'Doctor Hospital', imagepath: 'assets/images/smith.png', address: '152-G/1, Canal Bank'),
      hospitalcardcontent(heading: 'Hameed Latif Hospital', imagepath: 'assets/images/smith.png', address: '14 New Abu Bakar Block,'),
];