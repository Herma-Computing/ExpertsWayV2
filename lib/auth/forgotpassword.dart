import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../routes/routing_constants.dart';
import '../services/api_controller.dart';
import '../ui/widgets/gradient_button.dart';
import '../utils/color.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    TextButton(
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 330),
                      child: const Text(
                        'Change Password',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Reset Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      "Enter the email accociated with your acccount and we will send email with one time password (OTP) to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildEmailinput(),
              ),
              const SizedBox(height: 30),
              GradientBtn(
                onPressed: sendInstraction,
                btnName: 'Send',
                defaultBtn: true,
                isPcked: false,
                width: 280,
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailinput() {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context), borderRadius: BorderRadius.circular(10));

    return Form(
      key: formkey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              shadowColor: Colors.black,
              child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.lock_outline),
                    hintText: "email",
                    hintStyle: const TextStyle(fontSize: 14),
                    filled: true,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.none,
                  validator: (value) => value != null && !value.contains('@') || !value!.contains('.') ? 'Enter a valid Email' : null),
            ),
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Future sendInstraction() async {
    final form = formkey.currentState!;
    if (form.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(color: maincolor),
              ));

      String res = await ApiProvider().sendInstraction(
        emailController.text,
      );
      navigatorKey.currentState!.popUntil((rout) => rout.isFirst);
      if (res == "success") {
        Get.toNamed(AppRoute.changepasswordPage, arguments: {'email': emailController.text});
      } else {
        Get.toNamed(AppRoute.forgotpasswordPage);

        if (mounted) {
          Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            titleSize: 20,
            messageSize: 17,
            backgroundColor: maincolor,
            borderRadius: BorderRadius.circular(8),
            message: res,
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      }
    }
  }
}
