class doctordetailcontent
{
  String docname;
  String imagepath;

  doctordetailcontent({required this.imagepath,required this.docname });

}
List<doctordetailcontent> doctorcontent=
    [
      doctordetailcontent(imagepath: 'assets/images/smith.png', docname: 'DR Williem Smith'),
      doctordetailcontent(imagepath: 'assets/images/ravi.png', docname: 'DR Ravi Putra'),
      doctordetailcontent(imagepath: 'assets/images/makai.png', docname: 'DR Makai Jacks'),
      doctordetailcontent(imagepath: 'assets/images/makai.png', docname: 'DR Makai Jacks'),
      doctordetailcontent(imagepath: 'assets/images/makai.png', docname: 'DR Makai Jacks'),
    ];