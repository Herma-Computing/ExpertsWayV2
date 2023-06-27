import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/ui/pages/programming_language/controller.dart';
import 'package:expertsway/ui/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/shared_preference/shared_preference.dart';
import '../../../models/programming_options_model.dart';
import '../../../services/api_controller.dart';
import '../../../theme/theme.dart';

class ProgrammingOptions extends GetView<ProgrammingOptionsController> {
  const ProgrammingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
        body: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Text(
                  'What do you wish to master',
                  style: textTheme.displayMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text('Pick at least 3 languages', style: textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 9 / 3),
                    itemCount: controller.programmingOptionsModels.length,
                    itemBuilder: (_, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: GradientBtn(
                          defaultBtn: false,
                          onPressed: () {
                            controller.onSelectButton(index);
                          },
                          btnName: controller.programmingOptionsModels[index].btnName,
                          iconUrl: controller.programmingOptionsModels[index].iconUrl,
                          isPcked: controller.programmingOptionsModels[index].isPicked,
                        ),
                      );
                    }),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Opacity(
                    opacity: controller.pickedLanguages.length > 2 ? 1 : 0.3,
                    child: GradientBtn(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        List<ProgrammingOptionsModel> pickedLanguages = controller.pickedLanguages.cast<ProgrammingOptionsModel>().toList();
                        LanguageOptionPreferences.setLanguage(pickedLanguages.map((e) => e.btnName.toString()).toList());
                        List<String> languages = pickedLanguages.map((e) => e.btnName.toString()).toList();
                        String res = await ApiProvider().preferedLanguagesPatch(languages);
                        if (res == "OK") {
                          prefs.remove('languages');
                          LanguageOptionPreferences.setLanguage(pickedLanguages.map((e) => e.btnName.toString()).toList());
                          Get.offAllNamed(AppRoute.landingPage);
                        }
                      },
                      btnName: 'Get Started',
                      defaultBtn: true,
                      isPcked: false,
                      width: 200,
                      height: 52,
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }
}
