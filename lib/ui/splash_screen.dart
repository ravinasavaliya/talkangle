import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:talkangels/controller/share_profile_details_service.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  onInit() async {
     // print("PREFERNCES_______________get_callAccept__ 11 ${preferences.getString(preferences.callAccept)}");

    Future.delayed(const Duration(seconds: 1)).then((value) async {
       // print("PREFERNCES_______________get_callAccept__ 22 ${preferences.getString(preferences.callAccept)}");
      if (preferences.getString(preferences.callAccept) == "true") {
         // print('::::::::::::::::::::: On INIT TRUE PART ::::::::::::::::::::');

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await DynamicLinkService().handleDynamicLinks();
        });

        if (preferences.getBool(preferences.login) == true) {
          if (preferences.getString(preferences.roles) == "user") {
            Get.offAllNamed(Routes.homeScreen);
          } else {
            Get.offAllNamed(Routes.bottomBarScreen);

            // NotificationService.getInitialMsg();
            // await preferences.setBool(preferences.callAccept, false);

            // print('preferences.getBool(preferences.callAccept)=========SPLASH_INIT_TRUE==>>>>${preferences.getBool(preferences.callAccept)}');
            // if (preferences.getBool(preferences.callAccept) == true) {
            //   NotificationService.getInitialMsg();
            //   await preferences.setBool(preferences.callAccept, false);
            //   log("TRUE__BODY____SPLASH_SCREEN");
            // } else {
            //   log("FALSE__BODY____SPLASH_SCREEN");
            // }
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.loginScreen);
          });
        }
      } else {
        // print('::::::::::::::::::::: On INIT FALSE PART ::::::::::::::::::::');

        await preferences.setString(preferences.callAccept, "false");
          // print('preferences.getBool(preferences.callAccept)=========SPLASH_INIT_FALSE==>>>>${preferences.getString(preferences.callAccept)}');

        await Future.delayed(const Duration(seconds: 5), () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await DynamicLinkService().handleDynamicLinks();
          });

          if (preferences.getBool(preferences.login) == true) {
            if (preferences.getString(preferences.roles).toString() == "user") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.homeScreen);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.bottomBarScreen);
              });
            }
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAllNamed(Routes.loginScreen);
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: appGradient),
        child: preferences.getString(preferences.roles).toString() == AppString.staff
            ? SafeArea(
                child: Column(
                  children: [
                    (h * 0.09).addHSpace(),
                    svgAssetImage(AppAssets.appLogo, height: w * 0.20, width: w * 0.20),
                    AppString.talkAngels.regularAllertaStencil(
                      fontSize: 32,
                    ),
                    AppString.anonymousChatCall.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w300),
                    (h * 0.13).addHSpace(),
                    RippleAnimation(
                      color: appColorBlue.withOpacity(0.04),
                      delay: const Duration(milliseconds: 30),
                      repeat: true,
                      minRadius: 50,
                      ripplesCount: 6,
                      duration: const Duration(milliseconds: 6 * 300),
                      child: SizedBox(
                        height: h * 0.4,
                        width: w * 0.8,
                        child: assetImage(AppAssets.splashScreenAnimationAssets, fit: BoxFit.cover),
                      ),
                    ),
                    AppString.bringingYouToaZonOfOpenMindedness.regularLeagueSpartan(
                        fontSize: 15, fontWeight: FontWeight.w300, textAlign: TextAlign.center, fontColor: appColorBlue),
                  ],
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    (h * 0.09).addHSpace(),
                    svgAssetImage(AppAssets.appLogo, height: w * 0.25, width: w * 0.25),
                    AppString.talkAngels.regularAllertaStencil(fontSize: 32),
                    AppString.anonymousChatCall.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w300),
                    (h * 0.17).addHSpace(),
                    RippleAnimation(
                        color: appColorGreen.withOpacity(0.04),
                        delay: const Duration(milliseconds: 30),
                        repeat: true,
                        minRadius: 54,
                        ripplesCount: 6,
                        duration: const Duration(milliseconds: 6 * 300),
                        child: SizedBox(
                            height: h * 0.3, width: w * 0.6, child: Lottie.asset(AppAssets.animationIncomingCall, fit: BoxFit.fill))),
                    AppString.bringingYouToaZonOfOpenMindedness.regularLeagueSpartan(
                        fontSize: 15, fontWeight: FontWeight.w300, textAlign: TextAlign.center, fontColor: appColorGreen),
                  ],
                ),
              ),
      ),
    );
  }
}
