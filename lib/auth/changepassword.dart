import 'package:another_flushbar/flushbar.dart';
import 'package:expertsway/routes/routing_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../services/api_controller.dart';
import '../ui/widgets/gradient_button.dart';
import '../utils/color.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({super.key, required this.email});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirumController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    confirumController.dispose();
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
                    "Create new Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      "We have sent a recovery code, one time password (OTP) to your email.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: buildInputs(),
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

  Widget buildInputs() {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context), borderRadius: BorderRadius.circular(10));

    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("OTP code", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              shadowColor: Colors.black,
              child: TextFormField(
                  controller: codeController,
                  maxLength: 5,
                  decoration: InputDecoration(
                    filled: true,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value != null && value.length < 5 ? 'Enter OTP code' : null),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Password", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              shadowColor: Colors.black,
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true,
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Entre a password';
                  } else if (value!.length < 8) {
                    return 'password length can\'t be lessthan 8';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Confirm password", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              shadowColor: Colors.black,
              child: TextFormField(
                controller: confirumController,
                decoration: InputDecoration(
                  filled: true,
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Entre a password';
                  } else if (passwordController.text != confirumController.text) {
                    return 'Password not match';
                  } else {
                    return null;
                  }
                },
              ),
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

      String res = await ApiProvider().setnewpassword(
        widget.email,
        passwordController.text,
        int.parse(codeController.text),
      );
      navigatorKey.currentState!.popUntil((rout) => rout.isFirst);
      if (res == "success") {
        Get.offAllNamed(AppRoute.authPage);
      } else {
        Get.toNamed(AppRoute.changepasswordPage);
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
    } else {}
  }
}
