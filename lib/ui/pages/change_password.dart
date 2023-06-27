import 'package:expertsway/ui/pages/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../widgets/gradient_button.dart';

class ChangePasswordClass extends StatefulWidget {
  const ChangePasswordClass({super.key});

  @override
  State<ChangePasswordClass> createState() => ChangePasswordState();
}

String? passwordError, confirmPasswordError;
bool _passwordVisible = false;
bool _confrimPasswordVisible = false;

class ChangePasswordState extends State<ChangePasswordClass> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  late FocusNode passwordFocusNode, confirmPasswordFocusNode;

  @override
  void initState() {
    _passwordVisible = false;
    _confrimPasswordVisible = false;
    super.initState();

    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    passwordFocusNode.addListener(() => setState(() {}));
    confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  bool isSaved = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    IconThemeData icon = Theme.of(context).iconTheme;
    return Scaffold(
        backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
        body: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 5, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Icon(
                        Icons.chevron_left,
                        color: icon.color,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text('Change Password',
                        textAlign: TextAlign.end, style: textTheme.displayLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 35)
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25, bottom: 15),
                child: Text("Create new password", style: textTheme.displayLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Text("Your new password must be different from the old password",
                    textAlign: TextAlign.center,
                    style: textTheme.displayMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 20),
                child: Text("Password", style: textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _container(context, passwordController, "Password", "password", passwordFocusNode, confirmPasswordFocusNode, null, () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    }),
                    passwordError != null && isSaved ? errorMessage(passwordError.toString()) : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 20),
                      child: Text("Confirm Password", style: textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    _container(
                        context, confirmPasswordController, "Confirm Password", "confirm", confirmPasswordFocusNode, null, passwordController.text,
                        () {
                      setState(() {
                        _confrimPasswordVisible = !_confrimPasswordVisible;
                      });
                    }),
                    confirmPasswordError != null && isSaved ? errorMessage(confirmPasswordError.toString()) : Container(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              GradientBtn(
                onPressed: (() {
                  final isValidForm = _formKey.currentState!.validate();
                  setState(() {
                    isSaved = true;
                  });
                  if (isValidForm) {}
                }),
                btnName: 'Reset Password',
                defaultBtn: true,
                isPcked: false,
                width: 280,
                height: 52,
              ),
            ],
          ),
        ));
  }
}

Widget _container(BuildContext context, TextEditingController controller, String? hint, String? type, FocusNode focus, FocusNode? focusNext,
    String? confirmPassword, VoidCallback onTap) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  TextTheme textTheme = Theme.of(context).textTheme;
  Color secondbackgroundColor = Theme.of(context).cardColor;
  return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: secondbackgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(1, 1),
            color: themeProvider.currentTheme == ThemeData.dark() ? Colors.transparent : const Color.fromARGB(54, 188, 187, 187),
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: TextFormField(
          focusNode: focus,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText: type == "password" ? !_passwordVisible : !_confrimPasswordVisible,
          style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            filled: true,
            fillColor: secondbackgroundColor,
            hintStyle: TextStyle(color: Colors.grey[400]),
            hintText: hint,
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorStyle: const TextStyle(fontSize: 0.01),
            contentPadding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: Icon(
                type == "password"
                    ? _passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off
                    : _confrimPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                color: focus.hasFocus ? Colors.blue : const Color.fromARGB(255, 172, 172, 171),
              ), //
            ),
          ),
          onFieldSubmitted: ((value) {
            if (type == "password") {
              FocusScope.of(context).requestFocus(focusNext);
            } else {
              FocusScope.of(context).unfocus();
            }
          }),
          validator: ((value) {
            if (type == "password") {
              if (value != null && value.length < 8) {
                passwordError = "Must be at least 8 characters";
                return passwordError;
              } else {
                passwordError = null;
                return null;
              }
            } else if (type == "confirm") {
              if (value != confirmPassword) {
                confirmPasswordError = "Both passwords must match";
                return confirmPasswordError;
              } else {
                confirmPasswordError = null;
                return null;
              }
            } else {
              return null;
            }
          }),
        ),
      ));
}
