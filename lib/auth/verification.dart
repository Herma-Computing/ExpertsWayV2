import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expertsway/routes/page.dart';
import 'package:expertsway/utils/color.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../routes/routing_constants.dart';
import '../services/api_controller.dart';
import '../ui/widgets/gradient_button.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController pin1 = TextEditingController();
  final TextEditingController pin2 = TextEditingController();
  final TextEditingController pin3 = TextEditingController();
  final TextEditingController pin4 = TextEditingController();
  final TextEditingController pin5 = TextEditingController();
  bool issent = false;
  final List<int> otp = [];

  bool timeEnded = false;
  @override
  void dispose() {
    super.dispose();
    pin1.dispose();
    pin2.dispose();
    pin3.dispose();
    pin4.dispose();
    pin5.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Material(
          child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(children: const [
                  Text("We've sent you an email with \n your verification code",
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  SizedBox(height: 40),
                  Text("Check Your Email", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                ]),
              ),
              const SizedBox(height: 30),
              buildInput(),
              Center(
                  child: timeEnded
                      ? Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          const Text("Didn't receive anything,", style: TextStyle(color: Colors.black)),
                          InkWell(onTap: resendActivation, child: const Text("  send again", style: TextStyle(color: maincolor))),
                        ])
                      : buildTimer()),
              const SizedBox(height: 30),
              GradientBtn(
                onPressed: verify,
                btnName: 'Verify',
                defaultBtn: true,
                isPcked: false,
                width: 280,
                height: 52,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Column buildTimer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("We sent your code to ${widget.email}"),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("The code will expire in"),
            TweenAnimationBuilder(
              tween: Tween(begin: 60.0, end: 0),
              duration: const Duration(seconds: 60),
              builder: (context, value, child) => Text(
                " 00:${(value as double).toInt()}",
                style: const TextStyle(color: maincolor),
              ),
              onEnd: () {
                setState(() {
                  timeEnded = true;
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Widget buildInput() {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context, color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(10));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 57,
            width: 54,
            child: TextFormField(
              controller: pin1,
              cursorColor: maincolor,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: InputDecoration(
                  enabledBorder: inputBorder,
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: maincolor, width: 2))),
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.length == 1) {
                  otp.insert(0, int.parse(pin1.text));
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
          SizedBox(
            height: 57,
            width: 54,
            child: TextFormField(
              controller: pin2,
              cursorColor: maincolor,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  enabledBorder: inputBorder,
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: maincolor, width: 2))),
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.length == 1) {
                  otp.insert(1, int.parse(pin2.text));
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
          SizedBox(
            height: 57,
            width: 54,
            child: TextFormField(
              controller: pin3,
              cursorColor: maincolor,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  enabledBorder: inputBorder,
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: maincolor, width: 2))),
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.length == 1) {
                  otp.insert(2, int.parse(pin3.text));
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
          SizedBox(
            height: 57,
            width: 54,
            child: TextFormField(
              controller: pin4,
              cursorColor: maincolor,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  enabledBorder: inputBorder,
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: maincolor, width: 2))),
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.length == 1) {
                  otp.insert(3, int.parse(pin4.text));
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          ),
          SizedBox(
            height: 57,
            width: 54,
            child: TextFormField(
              controller: pin5,
              cursorColor: maincolor,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                  enabledBorder: inputBorder,
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: maincolor, width: 2))),
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.length == 1) {
                  otp.insert(4, int.parse(pin5.text));
                  FocusScope.of(context).nextFocus();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future verify() async {
    if (otp.length > 4) {
      int code = int.parse(otp.join(''));
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(color: maincolor),
              ));

      String res = await ApiProvider().verification(email, code);
      navigatorKey.currentState!.popUntil((rout) => rout.isFirst);

      if (res == "success") {
        // Get.offAllNamed(AppRoute.programmingOptions);
        Get.offAllNamed('/auth');
      } else {
        Get.toNamed(AppRoute.verificationPage, arguments: {'email': widget.email});
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
    } else {
      return null;
    }
  }

  Future resendActivation() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(color: maincolor),
            ));
    String res = await ApiProvider().resendActivation(widget.email);
    navigatorKey.currentState!.popUntil((rout) => rout.isFirst);

    if (res == "success") {
      Get.toNamed(AppRoute.verificationPage, arguments: {'email': widget.email});
      if (mounted) {
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
          titleSize: 20,
          messageSize: 17,
          backgroundColor: maincolor,
          borderRadius: BorderRadius.circular(8),
          message: 'sent, check your email !!',
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } else {
      Get.toNamed(AppRoute.verificationPage, arguments: {'email': widget.email});
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
