class FavoriteDoctorContent
{
  final String specialistof;
  final String imgpath;
  final String name;
  FavoriteDoctorContent({required this.name,required this.imgpath, required this.specialistof});
}
List<FavoriteDoctorContent> favdoctorcontents=
[
  FavoriteDoctorContent(name: 'Dr. Rodger Struck', imgpath: 'assets/images/drrodger.png', specialistof: 'Cardiologist'),
  FavoriteDoctorContent(name: 'Dr. Kathy Pacheco', imgpath: 'assets/images/drrodger.png', specialistof: 'Dermatologist'),
  FavoriteDoctorContent(name: 'Dr. Chris Glasser', imgpath: 'assets/images/drrodger.png', specialistof: 'Gastroenterology'),
  FavoriteDoctorContent(name: 'Dr. Lorri Warf', imgpath: 'assets/images/drrodger.png', specialistof: 'Homeopath'),
];