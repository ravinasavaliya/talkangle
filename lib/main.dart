import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/background_service.dart';
import 'package:talkangels/controller/call_staff_conroller.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
import 'package:talkangels/ui/staff/utils/notification_service.dart';
import 'package:uuid/uuid.dart';

///background notification handler..
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await preferences.init();
  debugPrint('message.data==========>>>>>${message.data}');
  debugPrint('message.datacall_type==========>>>>>${message.data['call_type']}');
  if (message.data['call_type'] == "reject") {
    if (preferences.getString(preferences.roles).toString() == 'staff') {
      FlutterCallkitIncoming.endAllCalls();
      if (Get.currentRoute == "/callingScreen1") {
        // showAppSnackBar("Connection lost...");
        Get.back();
      }
      // Get.toNamed(Routes.bottomBarScreen);
      // Get.offAllNamed(Routes.bottomBarScreen);
    } else {
      CallingScreenController callingScreenController = Get.put(CallingScreenController());
      // callingScreenController.rejectCall();
      callingScreenController.leaveChannel();
    }
  } else if (message.data['call_type'] == "calling") {
    // FlutterCallkitIncoming.endAllCalls();

    NotificationService.showCallkitIncoming(const Uuid().v4(), message);
    NotificationService.callHandle1(message);
  }
  RemoteNotification? notification = message.notification;
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: false,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

Timer? timer;
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  HomeController homeController = Get.put(HomeController());

  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  handleNetworkConnection.checkConnectivity();

  await preferences.init();
  var pref = await SharedPreferences.getInstance();
  pref.reload();
  int number = 0;

  DartPluginRegistrant.ensureInitialized();
  service.on("start").listen((event) {

    debugPrint("background process is now start*****************");
  });

  timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
    // print("::::::::::::::::::: callerUserId::${preferences.getString(preferences.callerUserId)} :: callSecondCount::${preferences.getString(preferences.callSecondCount)}");
    if (preferences.getBool(preferences.callStart) == true) {
      // debugPrint(":::::::::::::is callStart = true");

      if (preferences.getString(preferences.roles).toString() == AppString.staff) {
        /// STAFF
        // debugPrint(":::::::::::::is staff = true :: $number :: ${int.parse(preferences.getString(preferences.callSecondCount) ?? "0")} :: ${number < int.parse(preferences.getString(preferences.callSecondCount) ?? "0")}");

        if (number < int.parse(preferences.getString(preferences.callSecondCount) ?? "0")) {
          // debugPrint("CALL IS CONNECTED");
        } else {
          // debugPrint("CALL IS NOT CONNECTED");
          await preferences.setBool(preferences.callStart, false);
          await pref.reload();

          if (handleNetworkConnection.isResult == false) {
            /// ACTIVE STATUS API
            debugPrint("NETWORK CONNECTED");
            await homeController.updateCallStatus(AppString.available).then((value) async {
              // debugPrint('value==========updateCallStatus=>>>>$value');

              await homeController
                  .addCallHistory(
                      preferences.getString(preferences.callerUserId) ?? '',
                      preferences.getString(preferences.userId).toString(),
                      "incoming",
                      preferences.getString(preferences.callSecondCount).toString())
                  .then((result) async {
                // debugPrint('value==========addCallHistory=>>>>$result');
                if (preferences.getString(preferences.roles).toString() == AppString.staff) {
                  // debugPrint('==========background service stopped=>>>}');
                  await homeController.activeStatusApi(AppString.offline);
                  var pref = await SharedPreferences.getInstance();
                  await preferences.setString(preferences.callerUserId, '0');
                  await preferences.setString(preferences.callSecondCount, '0');
                  // await preferences.setBool(preferences.callStartAppDetached, false);
                  pref.reload();
                  timer.cancel();
                  service.stopSelf();
                }
              });
            });
          } else {
            debugPrint("NETWORK DISCONNECTED ######################## API NOT CALLED");
            timer.cancel();
            service.stopSelf();
          }
        }
      } else {
        /// USER
        // debugPrint(":::::::::::::is staff = false");
      }
    } else {
      // debugPrint(":::::::::::::is callStart = false");
    }

    number = int.parse(preferences.getString(preferences.callSecondCount) ?? '') == 0
        ? number
        : int.parse(preferences.getString(preferences.callSecondCount) ?? '');
    // debugPrint('number===========>>>>$number');
  });

  service.on("stop").listen((event) {
    service.stopSelf();
    debugPrint("background process is now stopped");
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  await Firebase.initializeApp();
  await initializeService();

  //await FlutterCallkitIncoming.requestFullIntentPermission();

  // await FlutterCallkitIncoming.requestNotificationPermission({
  //   "rationaleMessagePermission": "Notification permission is required to show notifications.",
  //   "postNotificationMessageRequired": "Notification permission is required. Please allow notification permission from settings."
  // });
  // try {
  //   await FlutterCallkitIncoming.requestNotificationPermission({
  //     "rationaleMessagePermission": "Notification permission is required to show notifications.",
  //     "postNotificationMessageRequired": "Notification permission is required. Please allow notification permission from settings."
  //   });
  // } catch (e) {
  // print("Error requesting notification permission: $e");
  // }

  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  handleNetworkConnection.initConnectivity();
  handleNetworkConnection.checkConnectivity();

  NotificationService().requestPermissions();
  if (defaultTargetPlatform == TargetPlatform.android) {
    Permission.microphone.request();
  }

  NotificationService().getFCMToken();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(NotificationService().channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationService.showMsgHandler();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  try {
    NotificationService.onMsgOpen();
  } catch (e) {
    debugPrint("error====>> $e");
  }
  NotificationService.flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
    var d = jsonDecode(notificationResponse.payload!);
    if (notificationResponse.payload!.isNotEmpty) {
      if (preferences.getBool(preferences.callStart) == true) {
        /// Call is connected that not navigate other screen
      } else {
        if (d["call_type"] == "calling") {
          Get.toNamed(Routes.bottomBarScreen);
        } else if (d["call_type"] == "reject") {
          if (preferences.getString(preferences.roles).toString() == AppString.staff) {
            Get.toNamed(Routes.callHistoryScreen);
          } else {
            Get.toNamed(Routes.personDetailScreen, arguments: {
              "angel_id": "${d["_id"]}",
            });
          }
        } else if (d['type'] == "Message" || d['type'] == "Offer" || d['type'] == "Other") {
          var angleId = d['angel_id'] ?? "";
          if (angleId != "") {
            Get.toNamed(Routes.personDetailScreen, arguments: {"angel_id": angleId});
          }
        } else {
          if (preferences.getString(preferences.roles).toString() == AppString.staff) {
            Get.toNamed(Routes.bottomBarScreen);
          } else {
            Get.toNamed(Routes.homeScreen);
          }
        }
      }
    } else {
      if (preferences.getString(preferences.roles).toString() == AppString.staff) {
        Get.toNamed(Routes.bottomBarScreen);
      } else {
        Get.toNamed(Routes.homeScreen);
      }
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      smartManagement: SmartManagement.full,
      debugShowCheckedModeBanner: false,
      title: 'Talk Angels',
      initialBinding: ControllerBindings(),
      initialRoute: Routes.splashScreen,
      getPages: Routes.routes,
    );
  }
}

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
    Get.lazyPut(() => HandleNetworkConnection());
    Get.lazyPut(() => CallingScreenControllerStaff());
  }
}

/// sdk   3.19.0
///
///
/// cHIadavLRp2TQFp6fR7q5g:APA91bGKIAc8qg72ZNSsiGaVuPPfE8JuE1byxkS_yNrJPnITENQfTVVwAjGwIcWQqX7gAVwapBP09cb8U9Wngvg7vN_rbfsHaE3eEe40_dMu7aDA8Wzw6ey9wQyupUVh6GTHtTp5BMKu
/// cHIadavLRp2TQFp6fR7q5g:APA91bGKIAc8qg72ZNSsiGaVuPPfE8JuE1byxkS_yNrJPnITENQfTVVwAjGwIcWQqX7gAVwapBP09cb8U9Wngvg7vN_rbfsHaE3eEe40_dMu7aDA8Wzw6ey9wQyupUVh6GTHtTp5BMKu
/// cHIadavLRp2TQFp6fR7q5g:APA91bGKIAc8qg72ZNSsiGaVuPPfE8JuE1byxkS_yNrJPnITENQfTVVwAjGwIcWQqX7gAVwapBP09cb8U9Wngvg7vN_rbfsHaE3eEe40_dMu7aDA8Wzw6ey9wQyupUVh6GTHtTp5BMKu
