import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/call_staff_conroller.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
import 'package:talkangels/ui/staff/utils/notification_service.dart';

import 'bottom_bar_controller.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> with WidgetsBindingObserver {
  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  BottomBarController bottomBarController = Get.put(BottomBarController());
  HomeController homeController = Get.put(HomeController());
  CallingScreenControllerStaff callingScreenControllerStaff = Get.put(CallingScreenControllerStaff());

  setPref() async {
    var pref = await SharedPreferences.getInstance();
    // await preferences.setBool(preferences.callStartAppDetached, false);
    await preferences.setBool(preferences.callStart, false);
    await preferences.setString(preferences.callerUserId, '0');
    await preferences.setString(preferences.callSecondCount, '0');
    await pref.reload();
    final isRunning = await FlutterBackgroundService().isRunning();
    if (isRunning) {
      debugPrint('stop listen -bottom_initState');
      FlutterBackgroundService().invoke("stop");
    }
  }

  @override
  void initState() {
    super.initState();
    handleNetworkConnection.checkConnectivity();

    ///
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await NotificationService.checkAndNavigationCallingPage();
    // });

    // print('PreferenceManager().getCallAccept()==========INIT_BOTTOM=>>>>${preferences.getString(preferences.callAccept)}');
    if (preferences.getString(preferences.callAccept) == "true") {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await NotificationService.checkAndNavigationCallingPage();
        await preferences.setString(preferences.callAccept, "false");
      });
    }

    if (handleNetworkConnection.isResult == false) {
      /// ACTIVE STATUS API
      homeController.activeStatusApi(AppString.online).then((result) async {
        await homeController.getStaffDetailApi();
      });
    }
    setPref();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // debugPrint('state=========debugPrint=bottom_navigation_bar=>>>>${state}');
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.resumed:
        final isRunning = await FlutterBackgroundService().isRunning();
        if (isRunning) {
          // debugPrint('stop listen -resumed');
          FlutterBackgroundService().invoke("stop");
        }

        ///

        var pref = await SharedPreferences.getInstance();
        await pref.reload();
        // print('PreferenceManager().getScreen()==========RESUME_BOTTOM=>>>>${preferences.getString(preferences.callAccept)}');
        if (preferences.getString(preferences.callAccept) == "true") {
          NotificationService.getInitialMsg();
          await preferences.setString(preferences.callAccept, "false");
        }

        ///
        if (handleNetworkConnection.isResult == false) {
          await homeController.getStaffDetailApi().then((result) {
            if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.offline) {
              homeController.activeStatusApi(AppString.online).then((result) async {
                await homeController.getStaffDetailApi();
              });
            }
          });
        }
        break;

      case AppLifecycleState.paused:
        if (preferences.getBool(preferences.callStart) == true) {
          // debugPrint('start listen -paused = true');
          FlutterBackgroundService().startService();
        } else {
          // debugPrint('start listen -paused = false');
        }
        break;

      case AppLifecycleState.hidden:
        break;

      case AppLifecycleState.detached:
        // debugPrint("::::::::::AppLifecycleState.detached:::::");
        // await preferences.setBool(preferences.callStartAppDetached, true);
        // await pref.reload();
        // print("***************************detached***callStartAppDetached=${preferences.getBool(preferences.callStartAppDetached)}");

        ///
        ///
        // if (handleNetworkConnection.isResult == false) {
        //   if (callingScreenControllerStaff.isLeaveChannel == true) {
        //     callingScreenControllerStaff.leaveChannel();
        //   }
        //   WidgetsBinding.instance.addPostFrameCallback((_) async {
        //     await homeController.activeStatusApi(AppString.offline);
        //   });
        // }
        break;
    }
  }

  /// OLD CODE
  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //       log('appLifeCycleState inactive');
  //       break;
  //
  //     case AppLifecycleState.resumed:
  //       if (handleNetworkConnection.isResult == false) {
  //         await homeController.getStaffDetailApi().then((result) {
  //           if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.offline) {
  //             homeController.activeStatusApi(AppString.online).then((result) async {
  //               await homeController.getStaffDetailApi();
  //             });
  //           }
  //         });
  //       }
  //
  //       log('appLifeCycleState resumed');
  //       break;
  //
  //     case AppLifecycleState.paused:
  //       print('AppLifecycleState.paused==========BOTTOMBAR=>>>>${AppLifecycleState.paused}');
  //       if (handleNetworkConnection.isResult == false) {
  //         if (callingScreenControllerStaff.isLeaveChannel == true) {
  //           callingScreenControllerStaff.leaveChannel();
  //         }
  //         homeController.activeStatusApi(AppString.offline);
  //       }
  //       log('appLifeCycleState paused');
  //       break;
  //
  //     case AppLifecycleState.hidden:
  //       log('appLifeCycleState suspending');
  //       break;
  //
  //     case AppLifecycleState.detached:
  //       log('appLifeCycleState detached');
  //       break;
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('PreferenceManager().getId()===========>>>>${preferences.getString(preferences.userId) ?? ''}');
    // log("${preferences.getString(preferences.userId)}", name: "USERID");
    // log("${preferences.getString(preferences.userToken)}", name: "TOKEN");
    // log("${preferences.getBool(preferences.login)}", name: "LOGIN");
    // log("${preferences.getString(preferences.userName)}", name: "NAME");
    // log("${preferences.getString(preferences.userNumber)}", name: "NUMBER");
    // log("${preferences.getString(preferences.fcmNotificationToken)}", name: "FCMNOTIFICATIONTOKEN");
    // log("${jsonDecode(preferences.getString(preferences.userDetails) ?? '')}", name: "DECODE====GETUSERDETAILS");

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return PopScope(
          canPop: controller.selectedPage != 0 ? false : true,
          onPopInvoked: (didPop) {
            if (controller.selectedPage == 0) {
              debugPrint(":::::app kill - PopScope::::::");
            }
            if (controller.selectedPage != 0) {
              controller.selectedPage = 0;
              Get.toNamed(Routes.bottomBarScreen);
              controller.update();
            }
          },
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: bottomBarbColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedPage,
              onTap: (value) {
                controller.setSelectedPage(value);
              },
              unselectedItemColor: bottomBarIconsColor,
              selectedItemColor: appColorBlue,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: "Call History"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
              ],
            ),
            body: Container(
              height: h,
              width: w,
              decoration: const BoxDecoration(gradient: appGradient),
              child: SafeArea(
                child: controller.screens[controller.selectedPage],
              ),
            ),
          ),
        );
      },
    );
  }
}
