import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/common/app_button.dart';
import 'package:talkangels/common/app_textfield.dart';
import 'package:talkangels/ui/startup/login_screen_controller.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  LoginScreenController loginScreenController = Get.put(LoginScreenController());

  String referCode = '';
  TextEditingController nameController = TextEditingController();
  final Uri _url = Uri.parse('https://talkangels.com');

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    loginScreenController.isWhatsappInstalled();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<LoginScreenController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(gradient: appGradient),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: Column(
                    children: [
                      (h * 0.09).addHSpace(),
                      svgAssetImage(AppAssets.appLogo, height: w * 0.25, width: w * 0.25),
                      AppString.talkToPeopleWithSimilar
                          .regularLeagueSpartan(fontWeight: FontWeight.w300, fontSize: 18)
                          .paddingOnly(top: h * 0.01),
                      AppString.experiences.regularLeagueSpartan(fontSize: 22, fontWeight: FontWeight.w600),
                      // AppButton(
                      //   onTap: () async {
                      //     /// API signIn
                      //     await loginScreenController.signIn(
                      //       name: "code",
                      //       mNo: "9712023220",
                      //       cCode: "+91",
                      //       fcm: preferences.getString(preferences.fcmNotificationToken) ?? '',
                      //       referCode: '',
                      //     );
                      //   },
                      //   child: controller.isLoading == true
                      //       ? const Center(child: CircularProgressIndicator(color: whiteColor))
                      //       : "Static STAFF LOGIN".regularLeagueSpartan(fontSize: 18),
                      // ),(h * 0.09).addHSpace(),
                      // AppButton(
                      //   onTap: () async {
                      //     /// API signIn
                      //     await loginScreenController.signIn(
                      //       name: "Demo",
                      //       mNo: "7623977514",
                      //       cCode: "+91",
                      //       fcm: preferences.getString(preferences.fcmNotificationToken) ?? '',
                      //       referCode: '',
                      //     );
                      //   },
                      //   child: controller.isLoading == true
                      //       ? const Center(child: CircularProgressIndicator(color: whiteColor))
                      //       : "Static USER LOGIN".regularLeagueSpartan(fontSize: 18),
                      // ),
                      controller.fillName == true ? (h * 0.1).addHSpace() : (h * 0.15).addHSpace(),
                      controller.fillName == true
                          ? Column(
                              children: [
                                AppTextFormField(
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {}
                                    return null;
                                  },
                                  controller: nameController,
                                  labelText: "Please Enter Your Name",
                                  constraints: const BoxConstraints(maxHeight: 55),
                                ),
                                (h * 0.05).addHSpace(),
                                AppButton(
                                  onTap: () async {
                                    if (Get.arguments != null) {
                                      referCode = Get.arguments["refer_code"] ?? '';
                                    }

                                    if (nameController.text.isNotEmpty) {
                                      /// API signIn
                                      await controller.signIn(
                                        name: nameController.text.trim().toString(),
                                        mNo: controller.number ?? '',
                                        cCode: controller.code ?? '',
                                        fcm: preferences.getString(preferences.fcmNotificationToken) ?? '',
                                        referCode: referCode,
                                      );
                                    } else {
                                      showAppSnackBar("Please Enter Your Name");
                                    }
                                  },
                                  child: controller.isLoading == true
                                      ? const Center(child: CircularProgressIndicator(color: whiteColor))
                                      : AppString.login.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                              ],
                            )
                          : AppButton(
                              onTap: () async {
                                loginScreenController.isWhatsappInstalled().then((value) async {
                                  if (controller.isWhatsAppIsInstall == true) {
                                    if (Get.arguments != null) {
                                      referCode = Get.arguments["refer_code"] ?? '';
                                    }

                                    /// whatsapp login

                                    await controller.startOtpless(referCode);
                                  }
                                });
                              },
                              child: controller.isLoading == true
                                  ? const Center(child: CircularProgressIndicator(color: whiteColor))
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        svgAssetImage(AppAssets.whatsAppLogo),
                                        (w * 0.05).addWSpace(),
                                        AppString.whatsappInstantLogin.regularLeagueSpartan(fontSize: 18),
                                      ],
                                    ),
                            ),
                      (h * 0.02).addHSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppString.haveA.regularLeagueSpartan(fontWeight: FontWeight.w200),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.referralCodeScreen);
                            },
                            child: AppString.referralCode_.regularLeagueSpartan(fontColor: appColorGreen),
                          ),
                        ],
                      ),
                      controller.fillName == true ? (h * 0.12).addHSpace() : (h * 0.2).addHSpace(),
                      GestureDetector(
                        onTap: () {
                          _launchInBrowser(_url);
                        },
                        onLongPress: () async {
                          await Clipboard.setData(ClipboardData(text: _url.toString()));
                        },
                        child: Container(
                          height: h * 0.1,
                          width: w,
                          padding: EdgeInsets.all(w * 0.03),
                          decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppString.moreInformation.regularLeagueSpartan(fontColor: greyFontColor, fontWeight: FontWeight.w200),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.web, color: greyFontColor),
                                  (w * 0.03).addWSpace(),
                                  "$_url".regularLeagueSpartan(fontColor: appColorGreen, textDecoration: TextDecoration.underline),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      (h * 0.04).addHSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppString.byClickingIAcceptThe.regularLeagueSpartan(fontWeight: FontWeight.w200),
                          InkWell(
                            onTap: () {},
                            child: AppString.tAndC.regularLeagueSpartan(fontColor: appColorGreen, textDecoration: TextDecoration.underline),
                          ),
                          AppString.and.regularLeagueSpartan(fontWeight: FontWeight.w200),
                          InkWell(
                            onTap: () {},
                            child: AppString.privacyPolicy
                                .regularLeagueSpartan(fontColor: appColorGreen, textDecoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      (h * 0.02).addHSpace(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
