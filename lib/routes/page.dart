import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/ui/pages/change_password.dart';
import 'package:get/get.dart';
import '../auth/auth.dart';
import '../auth/changepassword.dart';
import '../auth/forgotpassword.dart';
import '../auth/verification.dart';
import '../ui/pages/contributions/content_submitted.dart';
import '../ui/pages/contributions/my_contributions.dart';
import '../ui/pages/contributions/terms_and_conditions.dart';
import '../ui/pages/edit_lesson2.dart';
import '../ui/pages/landing_page/controller.dart';
import '../ui/pages/landing_page/landing_page.dart';
import '../ui/pages/other_profiles.dart';
import '../ui/pages/profile.dart';
import '../ui/pages/programming_language/controller.dart';
import '../ui/pages/programming_language/programing_options.dart';
import '../ui/pages/video.dart';

final String email = Get.arguments['email'];
final pages = [
  GetPage(name: AppRoute.videoPage, page: () => const VideoPage()),
  GetPage(
      name: AppRoute.landingPage,
      page: () => const LandingPage(),
      binding: BindingsBuilder(() {
        Get.put(LandingPageController());
      })),
  GetPage(
      name: AppRoute.programmingOptions,
      page: () => const ProgrammingOptions(),
      binding: BindingsBuilder(() {
        Get.put(ProgrammingOptionsController());
      })),
  GetPage(name: AppRoute.authPage, page: () => const AuthPage()),
  GetPage(name: AppRoute.verificationPage, page: () => VerificationPage(email: email)),
  GetPage(name: AppRoute.forgotpasswordPage, page: () => const ForgotPassword()),
  GetPage(name: AppRoute.changepasswordPage, page: () => ChangePassword(email: email)),
  GetPage(name: AppRoute.editLesson, page: () => EditLesson2()),
  GetPage(name: AppRoute.termsAndConditions, page: () => const TermsAndConditions()),
  GetPage(name: AppRoute.contentSubmitted, page: () => const ContentSubmitted()),
  GetPage(name: AppRoute.changepassword, page: () => const ChangePasswordClass()),
  GetPage(name: AppRoute.profile, page: () => const Profile()),

  GetPage(name: AppRoute.myContributions, page: () => const MyContributions()),
  
  GetPage(name: AppRoute.otherProfilePage, page: () => const OtherProfile()),

];
