import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_button.dart';
import 'package:talkangels/common/app_show_profile_pic.dart';
import 'package:talkangels/common/app_textfield.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/socket/socket_service.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/person_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  HomeScreenController homeController = Get.put(HomeScreenController());
  TextEditingController talkTimeController = TextEditingController();
  CallingScreenController callingScreenController = Get.put(CallingScreenController());

  final _formKey = GlobalKey<FormState>();
  bool isPayment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // paymentController.cfPaymentGatewayService.setCallback(paymentController.verifyPayment, paymentController.onError);

    handleNetworkConnection.checkConnectivity();
    if (handleNetworkConnection.isResult == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await homeController.userDetailsApi();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await homeController.homeAngleApi();
        SocketConnection.connectSocket(() {
          homeController.angleListeners();
          print("socket connection--home_init--");
        });
      });
    }
    homeController.search();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // debugPrint('state=========debugPrint=angels/home_screen=>>>>${state}');
    // print('state=========print=angels/home_screen=>>>>${state}');
    // log('state=========log=angels/home_screen=>>>>${state}');

    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        if (handleNetworkConnection.isResult == false) {
          if (homeController.resModel.data == []) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await homeController.homeAngleApi();
              SocketConnection.connectSocket(() {
                homeController.angleListeners();
                print("socket connection---RESUME-");
              });
            });
          }
          log("socket connection---RESUME-");
          if (homeController.userDetailsResModel.data == null || isPayment) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              log("socket connection---RESUME-");
              await homeController.userDetailsApi();
            });
          }
        }
        break;
      case AppLifecycleState.paused:
        SocketConnection.socketDisconnect();
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.detached:
        debugPrint("::::::::::AppLifecycleState.detached:::::");
        SocketConnection.socketDisconnect();
        if (handleNetworkConnection.isResult == false) {
          if (callingScreenController.isLeaveChannel == true) {
            callingScreenController.leaveChannel();
          }
        }
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('PreferenceManager().getId()===========>>>>${preferences.getString(preferences.userId).toString()}');
    // log("${PreferenceManager().getId()}", name: "USERID");
    // log("${PreferenceManager().getString(PreferenceManager().userToken)}", name: "TOKEN");
    // log("${PreferenceManager().getLogin()}", name: "LOGIN");
    // log("${PreferenceManager().getName()}", name: "NAME");
    // log("${PreferenceManager().getNumber()}", name: "NUMBER");
    // log("${PreferenceManager().getString(PreferenceManager().fcmNotificationToken)}", name: "FCMNOTIFICATIONTOKEN");
    // log("${jsonDecode("${PreferenceManager().getUserDetails()}")}", name: "DECODE====GETUSERDETAILS");

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return GetBuilder<HomeScreenController>(
          builder: (controller) {
            return Stack(
              children: [
                Scaffold(
                  drawer: homeDrawer(),
                  appBar: AppAppBar(
                    appBarHeight: 120,
                    backGroundColor: appBarColor,
                    titleText: "Hey, ${preferences.getString(preferences.userName).toString()}",
                    titleSpacing: w * 0.03,
                    action: [
                      // GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //         height: h * 0.14,
                      //         width: w * 0.14,
                      //         decoration: BoxDecoration(
                      //             border:
                      //                 Border.all(color: whiteColor, width: 0.5),
                      //             shape: BoxShape.circle),
                      //         child: Padding(
                      //             padding: EdgeInsets.all(w * 0.008),
                      //             child: CircleAvatar(
                      //                 radius: 1,
                      //                 child: ClipRRect(
                      //                     borderRadius:
                      //                         BorderRadius.circular(200),
                      //                     child: assetImage(
                      //                         AppAssets.blankProfile)))))),
                      // (w * 0.045).addWSpace(),
                      AppShowProfilePic(
                        image: '',
                        onTap: () {
                          Get.toNamed(Routes.profileScreen);
                        },
                      ),
                      (w * 0.045).addWSpace(),
                    ],
                    bottom: bottom(),
                  ),
                  body: RefreshIndicator(
                    onRefresh: () {
                      if (handleNetworkConnection.isResult == false) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await homeController.userDetailsApi();
                        });

                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await homeController.homeAngleApi();
                          SocketConnection.connectSocket(() {
                            homeController.angleListeners();
                            print("socket connection----home_refresh");
                          });
                        });
                      }
                      return Future<void>.delayed(const Duration(seconds: 3));
                    },
                    child: controller.isLoading == true && controller.resModel.data == null
                        ? Container(
                            height: h,
                            width: w,
                            decoration: const BoxDecoration(gradient: appGradient),
                            child: const Center(child: CircularProgressIndicator(color: whiteColor)),
                          )
                        : Container(
                            height: h,
                            width: w,
                            decoration: const BoxDecoration(gradient: appGradient),
                            child: controller.resModel.status == 200
                                ? controller.isSearch == true
                                    ? controller.searchAngelsList == [] || controller.searchAngelsList.isEmpty
                                        ? Center(
                                            child: AppString.angelsNotFound
                                                .leagueSpartanfs20w600(fontColor: greyFontColor, fontWeight: FontWeight.w700))
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller.searchAngelsList.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    top: index == 0 ? h * 0.02 : 0, left: w * 0.04, right: w * 0.04, bottom: h * 0.02),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (networkController.isResult == false) {
                                                      controller.setAngle(controller.searchAngelsList[index]);
                                                      Get.toNamed(Routes.personDetailScreen,
                                                          arguments: {"angel_id": controller.searchAngelsList[index].id});
                                                    } else {
                                                      showAppSnackBar(AppString.noInternetConnection);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: h * 0.13,
                                                    width: w,
                                                    decoration:
                                                        BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        (w * 0.04).addWSpace(),
                                                        Stack(
                                                          children: [
                                                            AppShowProfilePic(
                                                                image: controller.searchAngelsList[index].image ?? '',
                                                                onTap: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (_) => ProfileDialog(
                                                                        angelId: controller.searchAngelsList[index].id.toString()),
                                                                  );
                                                                },
                                                                borderShow: false,
                                                                radius: 62),
                                                            Positioned(
                                                              right: 6,
                                                              bottom: 6,
                                                              child: CircleAvatar(
                                                                backgroundColor: containerColor,
                                                                radius: 7,
                                                                child: CircleAvatar(
                                                                    backgroundColor:
                                                                        controller.searchAngelsList[index].callAvailableStatus == "0"
                                                                            ? redColor
                                                                            : controller.searchAngelsList[index].callStatus ==
                                                                                    AppString.available
                                                                                ? greenColor
                                                                                : controller.searchAngelsList[index].callStatus ==
                                                                                        AppString.busy
                                                                                    ? yellowColor
                                                                                    : redFontColor,
                                                                    radius: 4.5),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        (w * 0.03).addWSpace(),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            "${(controller.searchAngelsList[index].name ?? '')}".regularLeagueSpartan(
                                                                fontColor: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
                                                            (h * 0.005).addHSpace(),
                                                            "${controller.searchAngelsList[index].gender?[0] ?? ''}-${controller.searchAngelsList[index].age ?? ''} Yrs • 0 yrs of Experience"
                                                                .regularLeagueSpartan(fontColor: whiteColor, fontSize: 10),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                const Icon(Icons.star, size: 11, color: yellowColor),
                                                                (w * 0.01).addWSpace(),
                                                                ("${controller.searchAngelsList[index].totalRating?.toStringAsFixed(1)}  (${controller.searchAngelsList[index].reviews?.length} Rating)")
                                                                    .regularLeagueSpartan(fontColor: yellowColor, fontSize: 10),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        InkWell(
                                                          onTap: () {

                                                            if (networkController.isResult == false) {
                                                              controller.setAngle(controller.searchAngelsList[index]);
                                                              controller.angleCallingApi(controller.searchAngelsList[index].id!,
                                                                  preferences.getString(preferences.userId) ?? '');
                                                            } else {
                                                              showAppSnackBar(AppString.noInternetConnection);
                                                            }
                                                          },
                                                          child: Container(
                                                            height: h * 0.045,
                                                            width: w * 0.25,
                                                            decoration: BoxDecoration(
                                                                color: controller.searchAngelsList[index].callAvailableStatus == "0"
                                                                    ? redColor
                                                                    : controller.searchAngelsList[index].callStatus == AppString.available
                                                                        ? greenColor
                                                                        : controller.searchAngelsList[index].callStatus == AppString.busy
                                                                            ? yellowColor
                                                                            : redFontColor,
                                                                borderRadius: BorderRadius.circular(5),
                                                                border: Border.all(color: textFieldBorderColor)),
                                                            child: Center(
                                                                child: (controller.searchAngelsList[index].callAvailableStatus == "0"
                                                                        ? AppString.notAvailable
                                                                        : controller.searchAngelsList[index].callStatus ==
                                                                                AppString.available
                                                                            ? AppString.talkNow
                                                                            : controller.searchAngelsList[index].callStatus ==
                                                                                    AppString.busy
                                                                                ? AppString.busy
                                                                                : AppString.notAvailable)
                                                                    .regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w900)),
                                                          ),
                                                        ),
                                                        (w * 0.04).addWSpace(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                    : controller.angleAllData == [] ||
                                            controller.angleAllData.isEmpty ||
                                            controller.allAngelsListData.isEmpty
                                        ? Center(
                                            child: AppString.angelsNotFound
                                                .leagueSpartanfs20w600(fontColor: greyFontColor, fontWeight: FontWeight.w700))
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: controller.allAngelsListData.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    top: index == 0 ? h * 0.02 : 0, left: w * 0.04, right: w * 0.04, bottom: h * 0.02),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (networkController.isResult == false) {
                                                      controller.setAngle(controller.allAngelsListData[index]);
                                                      Get.toNamed(Routes.personDetailScreen,
                                                          arguments: {"angel_id": controller.allAngelsListData[index].id});
                                                    } else {
                                                      showAppSnackBar(AppString.noInternetConnection);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: h * 0.13,
                                                    width: w,
                                                    decoration:
                                                        BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        (w * 0.04).addWSpace(),
                                                        Stack(
                                                          children: [
                                                            AppShowProfilePic(
                                                                image: controller.allAngelsListData[index].image ?? '',
                                                                onTap: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (_) => ProfileDialog(
                                                                        angelId: controller.allAngelsListData[index].id.toString()),
                                                                  );
                                                                },
                                                                borderShow: false,
                                                                radius: 62),
                                                            Positioned(
                                                              right: 6,
                                                              bottom: 6,
                                                              child: CircleAvatar(
                                                                backgroundColor: containerColor,
                                                                radius: 7,
                                                                child: CircleAvatar(
                                                                  backgroundColor: controller
                                                                              .allAngelsListData[index].callAvailableStatus ==
                                                                          "0"
                                                                      ? redColor
                                                                      : controller.allAngelsListData[index].callStatus ==
                                                                              AppString.available
                                                                          ? greenColor
                                                                          : controller.allAngelsListData[index].callStatus == AppString.busy
                                                                              ? yellowColor
                                                                              : redFontColor,
                                                                  radius: 4.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        (w * 0.03).addWSpace(),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            (controller.allAngelsListData[index].name ?? '').regularLeagueSpartan(
                                                                fontColor: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
                                                            (h * 0.005).addHSpace(),
                                                            "${controller.allAngelsListData[index].gender?[0] ?? ''}-${controller.allAngelsListData[index].age ?? ''} Yrs • 0 yrs of Experience"
                                                                .regularLeagueSpartan(fontColor: whiteColor, fontSize: 10),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                const Icon(Icons.star, size: 11, color: yellowColor),
                                                                (w * 0.01).addWSpace(),
                                                                ("${controller.allAngelsListData[index].totalRating?.toStringAsFixed(1)}  (${controller.allAngelsListData[index].reviews?.length} Rating)")
                                                                    .regularLeagueSpartan(fontColor: yellowColor, fontSize: 10),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        InkWell(
                                                          onTap: () {


                                                            if (networkController.isResult == false) {
                                                              controller.setAngle(controller.allAngelsListData[index]);
                                                              controller.angleCallingApi(controller.allAngelsListData[index].id!,
                                                                  preferences.getString(preferences.userId) ?? '');
                                                            } else {
                                                              showAppSnackBar(AppString.noInternetConnection);
                                                            }
                                                          },
                                                          child: Container(
                                                              height: h * 0.045,
                                                              width: w * 0.25,
                                                              decoration: BoxDecoration(
                                                                  color: controller.allAngelsListData[index].callAvailableStatus == "0"
                                                                      ? redColor
                                                                      : controller.allAngelsListData[index].callStatus ==
                                                                              AppString.available
                                                                          ? greenColor
                                                                          : controller.allAngelsListData[index].callStatus == AppString.busy
                                                                              ? yellowColor
                                                                              : redFontColor,
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  border: Border.all(color: textFieldBorderColor)),
                                                              child: Center(
                                                                  child: (controller.allAngelsListData[index].callAvailableStatus == "0"
                                                                          ? AppString.notAvailable
                                                                          : controller.allAngelsListData[index].callStatus ==
                                                                                  AppString.available
                                                                              ? AppString.talkNow
                                                                              : controller.allAngelsListData[index].callStatus ==
                                                                                      AppString.busy
                                                                                  ? AppString.busy
                                                                                  : AppString.notAvailable)
                                                                      .regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w800))),
                                                        ),
                                                        (w * 0.04).addWSpace(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                : ErrorScreen(
                                    isLoading: controller.isLoading,
                                    onTap: () {
                                      if (networkController.isResult == false) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                                          await homeController.userDetailsApi();
                                        });

                                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                                          await homeController.homeAngleApi();
                                          SocketConnection.connectSocket(() {
                                            homeController.angleListeners();
                                            print("socket connection----home_error");
                                          });
                                        });
                                      }
                                    },
                                  ),
                          ),
                  ),
                ),
                controller.isCallLoading == true || controller.logOutLoading == true || controller.isDelete == true
                    ? Container(
                        height: h,
                        width: w,
                        color: Colors.black26,
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                      )
                    : const SizedBox()
              ],
            );
          },
        );
      },
    );
  }

  PreferredSize bottom() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size(double.infinity, h * 0.20),
      child: GetBuilder<HandleNetworkConnection>(
        builder: (networkController) {
          return GetBuilder<HomeScreenController>(
            builder: (controller) {
              return SearchTextFormField(
                readOnly: false,
                controller: controller.searchController,
                labelText: AppString.searchTalkAngelHere,
                prefixIcon: Icon(Icons.search, color: whiteColor.withOpacity(0.5)),
                onChanged: (p0) {
                  if (p0.isEmpty || p0 == '') {
                    controller.isSearch = false;
                    controller.update();
                  } else {
                    controller.isSearch = true;
                    controller.update();
                    homeController.searchData(p0);
                  }
                },
                suffixIcon: InkWell(
                  onTap: () {
                    if (networkController.isResult == false) {
                      showModalBottomSheet<void>(
                        constraints: BoxConstraints(maxHeight: h * 0.55),
                        isDismissible: true,
                        backgroundColor: containerColor,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        context: context,
                        builder: (BuildContext context) {
                          return Form(
                            key: _formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.025),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      Container(
                                        width: w * 1,
                                        height: h * 0.15,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(image: assetsImage2(AppAssets.girl), fit: BoxFit.cover)),
                                      ),
                                      Positioned(
                                        right: w * 0.05,
                                        top: h * 0.01,
                                        child: Row(
                                          children: [
                                            AppString.insufficientBalance.regularLeagueSpartan(fontWeight: FontWeight.w600),
                                            (w * 0.01).addWSpace(),
                                            svgAssetImage(AppAssets.emoji),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  (h * 0.03).addHSpace(),
                                  AppString.addTalkTime.regularLeagueSpartan(),
                                  (h * 0.01).addHSpace(),
                                  Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: whiteColor),
                                    child: TextFormField(
                                      cursorColor: blackColor,
                                      keyboardType: TextInputType.number,
                                      controller: talkTimeController,
                                      style: const TextStyle(
                                          color: blackColor, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'League Spartan'),
                                      decoration: InputDecoration(
                                        suffixIcon: TextButton(
                                            onPressed: () {
                                              if (networkController.isResult == false) {
                                                Get.back();
                                                Get.toNamed(Routes.allChargesScreen);
                                              } else {
                                                Get.back();
                                                showAppSnackBar(AppString.noInternetConnection);
                                              }
                                            },
                                            child: AppString.seeOffer
                                                .regularLeagueSpartan(fontColor: appColorGreen, fontSize: 14, fontWeight: FontWeight.w700)),
                                        hintText: "₹",
                                        hintStyle: TextStyle(
                                            color: blackColor.withOpacity(0.7),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'League Spartan'),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide.none),
                                        constraints: const BoxConstraints(maxHeight: 50),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  AppButton(
                                    onTap: () async {
                                      if (networkController.isResult == false) {
                                        const pattern = r'^[0-9]+$';
                                        final regex = RegExp(pattern);
                                        String token = preferences.getString(preferences.userToken) ?? '';

                                        if (talkTimeController.text.isEmpty ||
                                            talkTimeController.text == '' ||
                                            !regex.hasMatch(talkTimeController.text) ||
                                            int.parse(talkTimeController.text) <= 0) {
                                          showAppSnackBar(AppString.pleaseEnterValidAmount);
                                        } else {
                                          try {
                                            Get.back();
                                            // log('isPayment===========111===>>>${isPayment}');
                                            isPayment = true;
                                            // log('isPayment============222==>>>${isPayment}');

                                            ///  url launcher payment link
                                            final Uri url = Uri.parse(
                                                'https://www.talkangels.com/payment/${controller.userDetailsResModel.data?.id ?? ''}/${controller.userDetailsResModel.data?.mobileNumber ?? ''}/${controller.userDetailsResModel.data?.userName}/${talkTimeController.text.trim()}/${token}');

                                            // log('_url============payment link==homescreen>>>${url}');
                                            // debugPrint('_url============payment link==homescreen>>>${url}');
                                            await Future.delayed(
                                              Duration.zero,
                                              () async {
                                                if (!await launchUrl(
                                                  url,
                                                  mode: LaunchMode.platformDefault,
                                                )) {
                                                  throw Exception('Could not launch $url');
                                                }
                                              },
                                            );
                                            talkTimeController.clear();
                                            // Get.toNamed(Routes.paymentScreen, arguments: {
                                            //   "angel_id": controller.userDetailsResModel.data?.id ?? '',
                                            //   "user_number": "${controller.userDetailsResModel.data?.mobileNumber ?? ''}",
                                            //   "user_name": controller.userDetailsResModel.data?.name ?? '',
                                            //   "amount": talkTimeController.text.trim(),
                                            //   "token": token,
                                            // });

                                            /// Payment Method
                                            // paymentController.amount = talkTimeController.text.trim();
                                            // await paymentController.pay(amount: talkTimeController.text.trim());
                                            //
                                            // talkTimeController.clear();
                                            //
                                            // paymentController.update();
                                          } catch (e) {
                                            debugPrint("ERROR==CASH_FREE_PAYMENT   $e");
                                          }
                                        }
                                      } else {
                                        Get.back();
                                        showAppSnackBar(AppString.noInternetConnection);
                                      }
                                    },
                                    child: AppString.add.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      showAppSnackBar(AppString.noInternetConnection);
                    }
                  },
                  child: Container(
                    height: h * 0.01,
                    width: w * 0.22,
                    decoration: BoxDecoration(
                      color: redFontColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: svgAssetImage(AppAssets.myWalletIcon, color: redFontColor).paddingAll(2),
                        ),
                        (controller.userDetailsResModel.data?.talkAngelWallet?.totalBallance?.toStringAsFixed(1) ?? '0')
                            .regularLeagueSpartan(fontSize: 12),
                      ],
                    ),
                  ),
                ).paddingOnly(top: 8, bottom: 8, right: 10),
              ).paddingOnly(left: w * 0.04, right: w * 0.04, bottom: h * 0.01);
            },
          );
        },
      ),
    );
  }

  Widget homeDrawer() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return GestureDetector(
          onTap: () {
            closeDrawer();
          },
          child: Drawer(
            elevation: 0,
            width: w * 0.75,
            backgroundColor: appBarColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Container(
              height: h,
              width: w,
              decoration: const BoxDecoration(gradient: appGradient),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          AppShowProfilePic(
                            image: '',
                            onTap: () {},
                            radius: w * 0.18,
                          ),
                          (w * 0.04).addWSpace(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (preferences.getString(preferences.userName) ?? '')
                                  .regularLeagueSpartan(fontSize: 18, fontWeight: FontWeight.w500),
                              "+91 ${preferences.getString(preferences.userNumber) ?? ''}".regularLeagueSpartan(fontSize: 12),
                            ],
                          ),
                        ],
                      ).paddingOnly(left: w * 0.06, top: h * 0.05, bottom: h * 0.035),
                    ),
                    1.0.appDivider(),
                    drawerListTile(
                      title: AppString.myProfile,
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.profileScreen);
                      },
                      image: AppAssets.myProfileIcon,
                    ),
                    1.0.appDivider(),
                    Column(
                      children: [
                        drawerListTile(
                          title: AppString.myWallet,
                          onTap: () {
                            if (networkController.isResult == false) {
                              closeDrawer();
                              Get.toNamed(Routes.myWalletScreen);
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          image: AppAssets.myWalletIcon,
                        ),
                        1.0.appDivider(),
                        drawerListTile(
                          title: AppString.referEarn,
                          onTap: () {
                            if (networkController.isResult == false && homeController.userDetailsResModel.data?.referCode != null) {
                              closeDrawer();
                              Get.toNamed(Routes.referEarnScreen,
                                  arguments: {"referCode": homeController.userDetailsResModel.data?.referCode ?? ''});
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          image: AppAssets.referEarnIcon,
                        ),
                        1.0.appDivider(),
                        drawerListTile(
                          title: AppString.reportAProblem,
                          onTap: () {
                            if (networkController.isResult == false) {
                              closeDrawer();
                              Get.toNamed(Routes.reportAProblemScreen);
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          image: AppAssets.reportProblemIcon,
                        ),
                        1.0.appDivider(),
                        drawerListTile(
                          title: AppString.paymentHistory,
                          onTap: () {
                            if (networkController.isResult == false) {
                              closeDrawer();

                              /// payment history
                              Get.toNamed(Routes.paymentHistoryScreen);
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          image: AppAssets.reportProblemIcon,
                        ),
                        1.0.appDivider(),
                        drawerListTile(
                          title: AppString.deleteAccount,
                          onTap: () {
                            if (networkController.isResult == false) {
                              closeDrawer();

                              /// Delete Account
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) => AlertDialog(
                                  insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
                                  contentPadding: EdgeInsets.all(w * 0.05),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  content: Container(
                                    padding: EdgeInsets.zero,
                                    height: h * 0.4,
                                    width: w * 0.9,
                                    child: Column(
                                      children: [
                                        const Spacer(),
                                        SizedBox(
                                            height: h * 0.13,
                                            width: w * 0.26,
                                            child: assetImage(AppAssets.sureAnimationAssets, fit: BoxFit.cover)),
                                        const Spacer(),
                                        AppString.areYouSure
                                            .regularLeagueSpartan(fontColor: blackColor, fontSize: 24, fontWeight: FontWeight.w800),
                                        AppString.deleteAccountDescription
                                            .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15, textAlign: TextAlign.center),
                                        (h * 0.04).addHSpace(),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: AppButton(
                                                height: h * 0.06,
                                                color: Colors.transparent,
                                                onTap: () async {
                                                  if (networkController.isResult == false) {
                                                    await homeController.deleteAccountApi().then((result) async {
                                                      await PreferenceManager().logOut();
                                                      Get.offAllNamed(Routes.loginScreen);
                                                    });
                                                  } else {
                                                    showAppSnackBar(AppString.noInternetConnection);
                                                  }
                                                },
                                                child: AppString.yesImSure
                                                    .regularLeagueSpartan(fontColor: blackColor, fontSize: 14, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            (w * 0.02).addWSpace(),
                                            Expanded(
                                              flex: 1,
                                              child: AppButton(
                                                height: h * 0.06,
                                                border: Border.all(color: redFontColor),
                                                color: redFontColor,
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: AppString.noGoBack.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w700),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          image: AppAssets.deleteAccountIcon,
                        ),
                        1.0.appDivider(),
                      ],
                    ),
                    drawerListTile(
                        title: AppString.logOut,
                        fontColor: redFontColor,
                        onTap: () {
                          closeDrawer();
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: h * 0.4,
                                width: w * 1,
                                decoration: const BoxDecoration(
                                    gradient: appGradient, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Spacer(),
                                        SizedBox(
                                            height: h * 0.12,
                                            width: w * 0.3,
                                            child: assetImage(AppAssets.exitAnimationAssets, fit: BoxFit.cover)),
                                        const Spacer(),
                                        Center(
                                          child: AppString.doYouWantToExit.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
                                        ),
                                        (h * 0.01).addHSpace(),
                                        AppString.areYouSureYouReallyWantToLogOutFromyourTalkAngelAccount
                                            .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 12, textAlign: TextAlign.center),
                                        (h * 0.03).addHSpace(),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: AppButton(
                                                height: h * 0.06,
                                                color: Colors.transparent,
                                                onTap: () {
                                                  Get.back();
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
                                                      contentPadding: EdgeInsets.all(w * 0.05),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      content: Builder(
                                                        builder: (context) {
                                                          return SizedBox(
                                                            height: h * 0.4,
                                                            width: w * 0.9,
                                                            child: Column(
                                                              children: [
                                                                const Spacer(),
                                                                SizedBox(
                                                                    height: h * 0.13,
                                                                    width: w * 0.26,
                                                                    child: assetImage(
                                                                      AppAssets.sureAnimationAssets,
                                                                      fit: BoxFit.cover,
                                                                    )),
                                                                const Spacer(),
                                                                AppString.doYouWantToExit.regularLeagueSpartan(
                                                                    fontColor: blackColor, fontSize: 24, fontWeight: FontWeight.w800),
                                                                AppString.areYouSureYouReallyWantToLogOutFromYourTalkAngelAccount
                                                                    .regularLeagueSpartan(
                                                                        fontColor: greyFontColor,
                                                                        fontSize: 15,
                                                                        textAlign: TextAlign.center),
                                                                (h * 0.04).addHSpace(),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: AppButton(
                                                                        height: h * 0.06,
                                                                        color: Colors.transparent,
                                                                        onTap: () {
                                                                          Get.back();
                                                                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                                            await homeController
                                                                                .logOut(preferences.getString(preferences.userNumber) ?? '')
                                                                                .then((result1) async {
                                                                              await PreferenceManager().logOut();
                                                                              Get.offAllNamed(Routes.loginScreen);
                                                                            });
                                                                          });
                                                                        },
                                                                        child: AppString.logOut.regularLeagueSpartan(
                                                                            fontColor: blackColor,
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                    (w * 0.02).addWSpace(),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: AppButton(
                                                                        height: MediaQuery.of(context).size.height * 0.06,
                                                                        border: Border.all(color: redFontColor),
                                                                        color: redFontColor,
                                                                        onTap: () {
                                                                          Get.back();
                                                                        },
                                                                        child: AppString.cancel.regularLeagueSpartan(
                                                                            fontSize: 14, fontWeight: FontWeight.w700),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: AppString.logOut.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            (w * 0.02).addWSpace(),
                                            Expanded(
                                              flex: 1,
                                              child: AppButton(
                                                height: h * 0.06,
                                                border: Border.all(color: redFontColor),
                                                color: redFontColor,
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: AppString.cancel.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                        (h * 0.02).addHSpace(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        image: AppAssets.logOutIcon,
                        action: false),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  closeDrawer() {
    Get.back();
  }

  drawerListTile({required String title, required String image, required VoidCallback onTap, Color? fontColor, bool action = true}) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.06),
        child: Row(
          children: [
            image == ""
                ? const SizedBox(
                    width: 20,
                    height: 20,
                  )
                : svgAssetImage(image, height: 15, width: 15, color: fontColor ?? whiteColor),
            15.0.addWSpace(),
            Expanded(
              child: title.regularLeagueSpartan(
                fontColor: fontColor ?? whiteColor,
                fontSize: 14,
              ),
            ),
            action == true ? Icon(Icons.arrow_forward_ios, color: whiteColor.withOpacity(0.5), size: 17) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
