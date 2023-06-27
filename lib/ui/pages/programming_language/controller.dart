import 'package:get/get.dart';
import 'package:expertsway/models/programming_options_model.dart';

class ProgrammingOptionsController extends GetxController {
  RxList pickedLanguages = <ProgrammingOptionsModel>[].obs;

  List<ProgrammingOptionsModel> programmingOptionsModels = [
    ProgrammingOptionsModel(
        btnName: 'JavaScript',
        isPicked: true,
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/5968/5968292.png'),
    ProgrammingOptionsModel(
        btnName: 'Python',
        isPicked: true,
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/5968/5968350.png'),
    ProgrammingOptionsModel(
        btnName: 'Java',
        isPicked: true,
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/5968/5968282.png'),
    ProgrammingOptionsModel(
        btnName: 'Go',
        isPicked: true,
        iconUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Go_Logo_Blue.svg/1200px-Go_Logo_Blue.svg.png'),
    ProgrammingOptionsModel(
        btnName: 'C++',
        isPicked: true,
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/6132/6132222.png'),
    ProgrammingOptionsModel(
        btnName: 'PHP',
        isPicked: true,
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/5968/5968332.png'),
    ProgrammingOptionsModel(
        btnName: 'SQL',
        isPicked: true,
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/919/919836.png'),
    ProgrammingOptionsModel(
        btnName: 'Ruby',
        isPicked: true,
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/919/919842.png'),
  ];
  Future onSelectButton(int index) async {
    programmingOptionsModels[index].isPicked =
        !programmingOptionsModels[index].isPicked;
    !programmingOptionsModels[index].isPicked
        ? pickedLanguages.add(programmingOptionsModels[index])
        : pickedLanguages.remove(programmingOptionsModels[index]);
  }
}
