import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../api/shared_preference/shared_preference.dart';
import '../main.dart';
import '../routes/routing_constants.dart';
import '../services/api_controller.dart';
import '../theme/theme.dart';
import '../ui/pages/profile_edit.dart';
import '../ui/widgets/gradient_button.dart';
import '../utils/color.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedLogIn;
  const LoginPage({Key? key, required this.onClickedLogIn}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError, passwordError;
  late FocusNode emailFocusNode, passwordFocusNode;

  @override
  void initState() {
    super.initState();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode = FocusNode();

    super.dispose();
  }

  bool isSaved = false;
  bool isPressed = true;
  bool isLoading = false;

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context), borderRadius: BorderRadius.circular(10));
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;

    Color secondbackgroundColor = Theme.of(context).cardColor;
    return CupertinoPageScaffold(
      backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
      child: isLoading
          ? const CircularProgressIndicator(color: maincolor)
          : Material(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          Image.asset('assets/images/splash.png'),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Hey there,",
                            style: textTheme.displayMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Welcome Back",
                            style: textTheme.displayMedium?.copyWith(fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Form(
                          key: formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: secondbackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      offset: const Offset(1, 1),
                                      color: themeProvider.currentTheme == ThemeData.dark()
                                          ? Colors.transparent
                                          : const Color.fromARGB(54, 188, 187, 187),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                    controller: emailController,
                                    focusNode: emailFocusNode,
                                    cursorColor: Colors.blue,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: emailFocusNode.hasFocus ? Colors.blue : Colors.grey,
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                      fillColor: secondbackgroundColor,
                                      filled: true,
                                      border: inputBorder,
                                      enabledBorder: inputBorder,
                                      errorStyle: const TextStyle(fontSize: 0.01),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value != null && !value.contains('@') || !value!.contains('.')) {
                                        emailError = "Enter a valid Email";
                                        return emailError;
                                      } else {
                                        emailError = null;
                                        return null;
                                      }
                                    }),
                              ),
                              emailError != null && isSaved ? errorMessage(emailError.toString()) : Container(),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: secondbackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      offset: const Offset(1, 1),
                                      color: themeProvider.currentTheme == ThemeData.dark()
                                          ? Colors.transparent
                                          : const Color.fromARGB(54, 188, 187, 187),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  focusNode: passwordFocusNode,
                                  cursorColor: Colors.blue,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: passwordFocusNode.hasFocus ? Colors.blue : Colors.grey,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPressed = !isPressed;
                                        });
                                      },
                                      icon: isPressed
                                          ? Icon(Icons.visibility_off_outlined, color: passwordFocusNode.hasFocus ? Colors.blue : Colors.grey)
                                          : Icon(Icons.visibility_outlined, color: passwordFocusNode.hasFocus ? Colors.blue : Colors.grey),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                    fillColor: secondbackgroundColor,
                                    filled: true,
                                    border: inputBorder,
                                    enabledBorder: inputBorder,
                                    errorStyle: const TextStyle(fontSize: 0.01),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                                  keyboardType: TextInputType.text,
                                  obscureText: isPressed,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      passwordError = 'Enter a password';
                                      return passwordError;
                                    } else if (value!.length < 8) {
                                      passwordError = 'password length can\'t be lessthan 8';
                                      return passwordError;
                                    } else {
                                      passwordError = null;
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              passwordError != null && isSaved ? errorMessage(passwordError.toString()) : Container(),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () => Get.toNamed(AppRoute.forgotpasswordPage),
                                  child: Text(
                                    "Forgot your password?",
                                    style: textTheme.titleLarge
                                        ?.copyWith(fontSize: 17, decoration: TextDecoration.underline, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GradientBtn(
                        onPressed: login,
                        btnName: 'Login',
                        defaultBtn: true,
                        isPcked: false,
                        width: 280,
                        height: 52,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.grey,
                                height: 1,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Or",
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.grey,
                                height: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: signin,
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 2, color: const Color.fromARGB(208, 178, 178, 178))),
                                  child: Image.asset("assets/images/google.png")),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Don't have an account?", style: textTheme.displayMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w400)),
                          TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = widget.onClickedLogIn,
                              text: " Register",
                              style: const TextStyle(color: maincolor, fontSize: 17, fontWeight: FontWeight.w700))
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future signin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final user = await googleSignIn.signIn();
      String? name = "";
      if (user!.displayName != null) {
        name = user.displayName;
      }
      if (user.photoUrl != null) {
        image = user.photoUrl;
      }

      String res = await ApiProvider().registerUser(user.email, name!, name, user.id, "google");
      if (res == "success") {
        // List<String>? languages = await ApiProvider().preferedLanguagesGet();
        // if (languages!.isNotEmpty) {
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   await prefs.remove('languages');
        //   await LanguageOptionPreferences.setLanguage(languages);
          Get.toNamed(AppRoute.landingPage);
        // } else {
        //   Get.toNamed(AppRoute.programmingOptions);
        // }
      } else {
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
      // UserPreferences.setuser(image!, name!);
      // Get.toNamed(AppRoute.programmingOptions);
    } catch (error) {
      await googleSignIn.disconnect();
      // UserPreferences.setuser("https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50", "testDisplayName");
      // Get.toNamed(AppRoute.programmingOptions);
    }
  }

  Future login() async {
    isSaved = false;
    final form = formkey.currentState!;
    setState(() {
      isSaved = true;
    });
    if (form.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(color: maincolor),
              ));

      String res = await ApiProvider().loginUser(emailController.text, passwordController.text, 'email_password');
      navigatorKey.currentState!.popUntil((rout) => rout.isFirst);

      if (res == "success") {
        // List<String>? languages = await ApiProvider().preferedLanguagesGet();
        // if (languages!.isNotEmpty) {
        //   SharedPreferences pref = await SharedPreferences.getInstance();
        //   await pref.remove('languages');
        //   await LanguageOptionPreferences.setLanguage(languages);
          Get.offAllNamed(AppRoute.landingPage);
        // } else {
        //   Get.offAllNamed(AppRoute.programmingOptions);
        // }
      } else {
        if (res == 'Your account is Not activated') {
          setState(() {
            isLoading = true;
          });
          String res = await ApiProvider().resendActivation(emailController.text);
          setState(() {
            isLoading = false;
          });
          if (res == 'success') {
            Get.toNamed(AppRoute.verificationPage, arguments: {'email': emailController.text});
          }
        } else {
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
}
