// ignore_for_file: use_build_context_synchronously, unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expertsway/api/shared_preference/shared_preference.dart';
import 'package:expertsway/services/api_controller.dart';
import 'package:expertsway/ui/pages/landing_page/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expertsway/main.dart';
import 'package:expertsway/ui/pages/profile_edit.dart';
import 'package:expertsway/utils/color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/routing_constants.dart';
import '../../theme/box_icons_icons.dart';
import '../../theme/theme.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String name = "";
  late String email = "";
  late String image = "";
  String? title;
  bool lightmode = true;
  @override
  void initState() {
    getValue();
    super.initState();
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      email = prefs.getString('email')!;
      image = prefs.getString('image')!;
    });
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("image");
    prefs.remove("username");
    prefs.remove("name");
    prefs.remove("last_name");
    prefs.remove("email");
    prefs.remove("token");
    prefs.remove("birthdate");
    prefs.remove("occupation");
    prefs.remove("country");
    prefs.remove("languages");
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
    } catch (_) {}

    Get.offNamedUntil(AppRoute.authPage, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    IconThemeData icon = Theme.of(context).iconTheme;
    return Scaffold(
      backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, left: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.chevron_left,
                    color: icon.color,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Settings',
                  textAlign: TextAlign.end,
                  style: textTheme.headline1?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(color: Colors.lightBlue[100], borderRadius: BorderRadius.circular(100)),
                  child: CupertinoButton(
                    padding: const EdgeInsets.only(left: 3),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.blue,
                      size: 16,
                    ),
                    onPressed: () {
                      logout();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              buildImage(),
              Positioned(
                bottom: 0,
                right: 4,
                child: buildAddPhoto(Colors.blue),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  name,
                  style: textTheme.bodyText2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(email, style: textTheme.bodyText2),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            height: 2,
            color: Colors.grey[200],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    ContainerClass(
                        context: context,
                        leading: BoxIcons.bx_user,
                        title: 'Edit Profile',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfile()),
                          );
                        }),
                    ContainerClass(
                        context: context,
                        leading: BoxIcons.bx_lock,
                        title: 'Change Password',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoute.changepassword);
                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.language,
                        title: 'Language',
                        info: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Text(
                              "English(US)",
                              style: textTheme.bodyText2,
                            )),
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          lightmode = !lightmode;
                        }),
                    ContainerClass(
                      context: this.context,
                      leading: Icons.cleaning_services,
                      title: themeProvider.currentTheme == ThemeData.light() ? 'Dark Mode' : 'Light Mode',
                      info: Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          trackColor: const Color.fromARGB(255, 217, 238, 247),
                          activeColor: const Color.fromARGB(0, 78, 78, 78),
                          thumbColor: themeProvider.currentTheme == ThemeData.light() ? Colors.blue : Colors.grey[900],
                          value: themeProvider.currentTheme == ThemeData.dark(),
                          onChanged: (bool value) {
                            setState(() {
                              final provider = Provider.of<ThemeProvider>(context, listen: false);
                              provider.toggleTheme();
                            });
                            setState(() {});
                          },
                        ),
                      ),
                      trailing: null,
                      splash: false,
                      tapped: () {},
                    ),
                    ContainerClass(
                        context: context,
                        leading: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {}),
                    ContainerClass(
                        context: context,
                        leading: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoute.privacyPolicy);
                        }),
                    ContainerClass(
                        context: context,
                        leading: BoxIcons.bx_help_circle,
                        title: 'Help',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoute.help);
                        }),
                    ContainerClass(
                        context: context,
                        leading: BoxIcons.bx_share_alt,
                        title: 'Invite Friends',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {}),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildImage() {
    ImageProvider<Object> alternativeImage = const AssetImage('assets/images/video.jpg');
    return CircleAvatar(
      radius: 45,
      foregroundImage: image.isEmpty ? alternativeImage : CachedNetworkImageProvider(image.toString()),
      child: const Material(
        color: Color.fromARGB(0, 231, 6, 6), //
      ),
    );
  }

  Widget buildAddPhoto(Color color) {
    IconThemeData icon = Theme.of(context).iconTheme;
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(5),
        color: color,
        child: InkWell(
            onTap: () async {
              String? filePath = await pickImage();
              // let's show a loading dialog with a loading message
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              );
              // let's upload the image to the api
              if (filePath != null) {
                // let's try to upload the image
                try {
                  String imageUrl = await ApiProvider().changeProfilePicture(filePath);
                  setState(() {
                    image = imageUrl;
                  });
                  UserPreferences.setProfilePicture(imageUrl);
                  var landingPageController = Get.find<LandingPageController>();
                  landingPageController.profileImage = imageUrl;
                } catch (error) {
                  // let's show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to upload image. Try again later."),
                    ),
                  );
                }
              } else {
                // display a snackbar with error message (to the user)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid file selected."),
                  ),
                );
              }
              // pop the dialog
              Navigator.pop(context);
            },
            child: Icon(
              Icons.mode_edit_outline_outlined,
              color: icon.color,
              size: 17,
            )),
      ),
    );
  }

  Future<String?> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    String filepath = '';
    if (pickedImage != null) {
      filepath = pickedImage.path;
      return filepath;
    }
    return null;
  }
}

class ContainerClass extends StatelessWidget {
  const ContainerClass({
    Key? key,
    required this.context,
    required this.leading,
    required this.title,
    required this.info,
    required this.trailing,
    required this.splash,
    required this.tapped,
  }) : super(key: key);

  final BuildContext context;
  final IconData leading;
  final String title;
  final Widget? info;
  final IconData? trailing;
  final bool splash;
  final VoidCallback tapped;

  @override
  Widget build(context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    Color secondbackgroundColor = Theme.of(context).cardColor;
    IconThemeData icon = Theme.of(context).iconTheme;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: themeProvider.currentTheme == ThemeData.light() ? Colors.white : secondbackgroundColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(1, 1),
                color: themeProvider.currentTheme == ThemeData.light() ? const Color.fromARGB(54, 188, 187, 187) : Colors.transparent,
              )
            ],
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: tapped,
              highlightColor: splash ? const Color.fromARGB(132, 135, 208, 245) : Colors.transparent,
              splashColor: splash ? const Color.fromARGB(61, 231, 231, 231) : Colors.transparent,
              borderRadius: BorderRadius.circular(radius),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: Colors.lightBlue[100], borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          leading,
                          color: maincolor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(title, style: textTheme.bodyText2), //15
                    ],
                  ),
                  Row(
                    children: [
                      info ?? Container(),
                      const SizedBox(
                        width: 10,
                      ),
                      trailing == null
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Icon(
                                trailing,
                                color: icon.color,
                                size: 20,
                              ),
                            )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buildImage() {
    NetworkImage imagebuild = NetworkImage(image.toString());
    ImageProvider<Object> alternativeImage = const AssetImage('assets/images/video.jpg');
    return CircleAvatar(
      radius: 45,
      foregroundImage: image != null ? imagebuild : alternativeImage,
      child: const Material(
        color: Color.fromARGB(0, 231, 6, 6), //
      ),
    );
  }

  Widget buildAddPhoto(Color color) {
    IconThemeData icon = Theme.of(context).iconTheme;
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(5),
        color: color,
        child: InkWell(
            onTap: () {},
            child: Icon(
              Icons.mode_edit_outline_outlined,
              color: icon.color,
              size: 17,
            )),
      ),
    );
  }
}
