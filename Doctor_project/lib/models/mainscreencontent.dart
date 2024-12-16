class mainScreencontent {
  String heading;
  String imagepath;
  String text;

  mainScreencontent({required this.heading,required this.imagepath, required this.text});
}
List<mainScreencontent> contents=
[
  mainScreencontent(heading: 'Video Consultation', imagepath: 'assets/images/doctor1.png', text: 'PMC Verified Doctors'),
  mainScreencontent(heading: 'In-Clinic Visit', imagepath: 'assets/images/doctor2.png', text: 'Book Appointment'),
  mainScreencontent(heading: ' Emergency/\nOnline doc', imagepath: 'assets/images/doctor3.png', text: 'Healthy Lifestyle'),
];