import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_button.dart';
import 'package:talkangels/common/app_textfield.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> with WidgetsBindingObserver {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeScreenController = Get.find();
  TextEditingController textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    textFieldController;
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        log("AppLifecycleState.resumed");
        if (handleNetworkConnection.isResult == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await homeScreenController.userDetailsApi();
          });
        }
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        titleText: AppString.myWallet,
        action: [
          const Icon(Icons.help_outline),
          (w * 0.045).addWSpace(),
        ],
        bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
      ),
      body: GetBuilder<HandleNetworkConnection>(
        builder: (networkController) {
          return GetBuilder<HomeScreenController>(
            builder: (controller) {
              return Container(
                height: h,
                width: w,
                decoration: const BoxDecoration(gradient: appGradient),
                child: controller.isUserLoading == true
                    ? const Center(child: CircularProgressIndicator(color: whiteColor))
                    : SafeArea(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                            child: Column(
                              children: [
                                (h * 0.02).addHSpace(),
                                Container(
                                  width: w,
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(w * 0.04),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppString.exploreTheFeaturesOfTALKANGELWallet.regularLeagueSpartan(
                                          fontColor: yellowColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                        (h * 0.01).addHSpace(),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: w * 0.3,
                                              width: w * 0.3,
                                              child: assetImage(
                                                AppAssets.walletAnimationAssets,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            (w * 0.04).addWSpace(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.verified,
                                                      color: whiteColor,
                                                      size: 18,
                                                    ),
                                                    (w * 0.02).addWSpace(),
                                                    AppString.safetyOfPaymentTransfer.regularLeagueSpartan(
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                                (h * 0.01).addHSpace(),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.verified,
                                                      color: whiteColor,
                                                      size: 18,
                                                    ),
                                                    (w * 0.02).addWSpace(),
                                                    AppString.payInJustOneClick.regularLeagueSpartan(
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                                (h * 0.01).addHSpace(),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.verified,
                                                      color: whiteColor,
                                                      size: 18,
                                                    ),
                                                    (w * 0.02).addWSpace(),
                                                    AppString.payInJustOneClick.regularLeagueSpartan(
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                                (h * 0.01).addHSpace(),
                                                AppButton(
                                                  height: 35,
                                                  width: 135,
                                                  onTap: () {},
                                                  color: redFontColor,
                                                  child: AppString.getStartedNow.regularLeagueSpartan(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                (h * 0.02).addHSpace(),
                                Container(
                                  width: w,
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(w * 0.04),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.account_balance_wallet_outlined, color: whiteColor, size: 20),
                                          (w * 0.02).addWSpace(),
                                          AppString.talkAngelWalletBallance.regularLeagueSpartan(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const Spacer(),
                                          (controller.userDetailsResModel.data?.talkAngelWallet?.totalBallance?.toStringAsFixed(1) ?? '0')
                                              .regularLeagueSpartan(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontColor: appColorGreen,
                                          ),
                                        ],
                                      )),
                                ),
                                (h * 0.02).addHSpace(),
                                Container(
                                  width: w,
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(w * 0.04),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.add_card, color: whiteColor, size: 20),
                                              (w * 0.02).addWSpace(),
                                              AppString.addMoneyTo.regularLeagueSpartan(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              AppString.talkAngelWallet.regularLeagueSpartan(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontColor: appColorGreen,
                                              ),
                                            ],
                                          ),
                                          (h * 0.01).addHSpace(),
                                          UnderLineTextFormField(
                                            controller: textFieldController,
                                            labelText: AppString.enterAmount,
                                            height: 55,
                                            keyboardType: TextInputType.number,
                                            validator: (text) {
                                              const pattern = r'^[0-9]+$';
                                              final regex = RegExp(pattern);

                                              if (text == null || text.isEmpty) {
                                                return AppString.pleaseEnterAmount;
                                              } else if (!regex.hasMatch(text)) {
                                                return AppString.pleaseEnterValidNumbers;
                                              } else if (int.parse(text) <= 0) {
                                                return AppString.pleaseEnterValidAmount;
                                              }
                                              return null;
                                            },
                                          ),
                                          (h * 0.04).addHSpace(),
                                          AppButton(
                                            // onTap: () async {
                                            //   if (networkController.isResult == false) {
                                            //     String token = preferences.getString(preferences.userToken) ?? '';
                                            //     if (_formKey.currentState!.validate()) {
                                            //       String urls =
                                            //           'https://www.talkangels.com/payment/66e51f505eab634e343fdfba/9510624635/maulikvekariya/10/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoibWF1bGlrdmVrYXJpeWEiLCJtb2JpbGVfbnVtYmVyIjo5NTEwNjI0NjM1LCJyb2xlIjoidXNlciIsInN0YXR1cyI6MSwiaWF0IjoxNzI1NDMwMTU1LCJleHAiOjE3MjYyOTQxNTV9.t7E9AJC8JiW4fUut7Wlne1vVazyFuY86vJg2gWR89rw';
                                            //
                                            //       // Get.toNamed(Routes.paymentScreen, arguments: {
                                            //       //   "angel_id": controller.userDetailsResModel.data?.id ?? '',
                                            //       //   "user_number": "${controller.userDetailsResModel.data?.mobileNumber ?? ''}",
                                            //       //   "user_name": controller.userDetailsResModel.data?.name ?? '',
                                            //       //   "amount": textFieldController.text.trim(),
                                            //       //   "token": token,
                                            //       // });
                                            //
                                            //       ///
                                            //       ///  url launcher payment link
                                            //       final Uri _url = Uri.parse(
                                            //           'https://www.talkangels.com/payment/${controller.userDetailsResModel.data?.id ?? ''}/${controller.userDetailsResModel.data?.mobileNumber ?? ''}/${controller.userDetailsResModel.data?.userName}/${textFieldController.text.trim()}/${token}');
                                            //
                                            //       log('_url============payment link==>>>${_url}');
                                            //       await Future.delayed(
                                            //         Duration.zero,
                                            //         () async {
                                            //           if (!await launchUrl(
                                            //             _url,
                                            //             mode: LaunchMode.platformDefault,
                                            //           )) {
                                            //             throw Exception('Could not launch $_url');
                                            //           }
                                            //         },
                                            //       );
                                            //     }
                                            //   } else {
                                            //     showAppSnackBar(AppString.noInternetConnection);
                                            //   }
                                            // },

                                            /// OLD CODE
                                            onTap: () async {
                                              if (networkController.isResult == false) {
                                                String token = preferences.getString(preferences.userToken) ?? '';
                                                if (_formKey.currentState!.validate()) {
                                                  // Get.toNamed(Routes.paymentScreen, arguments: {
                                                  //   "angel_id": controller.userDetailsResModel.data?.id ?? '',
                                                  //   "user_number": "${controller.userDetailsResModel.data?.mobileNumber ?? ''}",
                                                  //   "user_name": controller.userDetailsResModel.data?.name ?? '',
                                                  //   "amount": textFieldController.text.trim(),
                                                  //   "token": token,
                                                  // });

                                                  ///
                                                  ///  redirect web payment link
                                                  final Uri _url = Uri.parse(
                                                      // 'https://www.talkangels.com/payment/66e51f505eab634e343fdfba/9510624635/maulikvekariya/10/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoibWF1bGlrdmVrYXJpeWEiLCJtb2JpbGVfbnVtYmVyIjo5NTEwNjI0NjM1LCJyb2xlIjoidXNlciIsInN0YXR1cyI6MSwiaWF0IjoxNzI1NDMwMTU1LCJleHAiOjE3MjYyOTQxNTV9.t7E9AJC8JiW4fUut7Wlne1vVazyFuY86vJg2gWR89rw');
                                                      'https://www.talkangels.com/payment/${controller.userDetailsResModel.data?.id ?? ''}/${controller.userDetailsResModel.data?.mobileNumber ?? ''}/${controller.userDetailsResModel.data?.userName}/${textFieldController.text.trim()}/${token}');
                                                  // 'https://www.talkangels.com/payment/${controller.userDetailsResModel.data?.id ?? ''}/${controller.userDetailsResModel.data?.mobileNumber ?? ''}/${controller.userDetailsResModel.data?.name}😍/${textFieldController.text.trim()}/${token}');

                                                  // log('_url============payment link==>>>${_url}');
                                                  // debugPrint('_url============payment link==>>>${_url}');
                                                  if (!await launchUrl(
                                                    _url,
                                                    mode: LaunchMode.platformDefault,
                                                  )) {
                                                    throw Exception('Could not launch $_url');
                                                  }

                                                  /// payment Api
                                                  // homeScreenController.createPaymentApi(
                                                  //   userId: controller.userDetailsResModel.data?.id ?? '',
                                                  //   userName: controller.userDetailsResModel.data?.name ?? '',
                                                  //   phoneNumber: "${controller.userDetailsResModel.data?.mobileNumber ?? ''}",
                                                  //   amount: textFieldController.text.trim(),
                                                  //   token: preferences.getString(preferences.userToken) ?? '',
                                                  // );

                                                  /// cash free payment
                                                  // try {
                                                  //   /// Payment Method
                                                  //   paymentController.amount = textFieldController.text.trim();
                                                  //   await paymentController.pay(amount: textFieldController.text.trim());
                                                  //
                                                  //   textFieldController.clear();
                                                  //   paymentController.update();
                                                  // } catch (e) {
                                                  //   log("ERROR==PHONEPE_PAYMENT   $e");
                                                  // }
                                                }
                                              } else {
                                                showAppSnackBar(AppString.noInternetConnection);
                                              }
                                            },
                                            child: controller.isAmountLoading == true
                                                ? const Center(
                                                    child: CircularProgressIndicator(color: whiteColor),
                                                  )
                                                : AppString.proceed.regularLeagueSpartan(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                (h * 0.02).addHSpace(),
                              ],
                            ),
                          ),
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
