class ProgrammingOptionsModel {
  final String btnName;
  bool isPicked;
  String iconUrl;

  ProgrammingOptionsModel({
    required this.btnName,
    required this.isPicked,
    this.iconUrl = 'https://cdn-icons-png.flaticon.com/512/6062/6062646.png',
  });
}
