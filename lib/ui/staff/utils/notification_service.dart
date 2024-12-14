import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? timer;
  static HomeController homeController = Get.put(HomeController());
  static RemoteMessage remoteMessage = const RemoteMessage();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(AppAssets.notificationSound),
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  getFCMToken() async {
    String? token = await messaging.getToken();

    await preferences.setString(preferences.fcmNotificationToken, token ?? '');
    print("FCM_TOKEN :::::::::::: $token");
  }

  /// notification handler..
  static void showMsgHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      RemoteNotification? notification = message?.notification;
      debugPrint('message==========>>>>>$message');
      debugPrint('message.detail_typ==========>>>>>${message!.data['call_type']}');
      if (message.data.isNotEmpty) {
        showMsg(message);
        if (message.data['call_type'] == "reject") {
          log("call type == reject ");
          if (preferences.getString(preferences.roles).toString() == 'staff') {
            await FlutterCallkitIncoming.endAllCalls();
            if (Get.currentRoute == "/callingScreen1") {
              // showAppSnackBar("Connection lost...");
              Get.back();
            }
            // Get.toNamed(Routes.bottomBarScreen);
            // Get.offAllNamed(Routes.bottomBarScreen);
          } else {
            CallingScreenController callingScreenController = Get.put(CallingScreenController());
            callingScreenController.leaveChannel(isRejected: true);
            Get.back();
          }
        } else if (message.data['call_type'] == "calling") {
          log("call type == calling ");
          FlutterCallkitIncoming.endAllCalls();
          callHandle(message);
          showCallkitIncoming(const Uuid().v4(), message);
        } else if (message.data['type'] == "Message" || message.data['type'] == "Other" || message.data['type'] == "Offer") {}
      }
    });
  }

  // static callHandle(RemoteMessage message) {
  //   FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
  //     // print("EVENT__callHandle_______  ${event?.event.name}");
  //
  //     switch (event!.event) {
  //       case Event.ACTION_CALL_INCOMING:
  //         // log("actionCallIncoming----?}_callHandle");
  //         await homeController.updateCallStatus(AppString.busy);
  //         // TODO: received an incoming call
  //         break;
  //       case Event.ACTION_CALL_START:
  //         // print("actionCallStart----?}");
  //         // TODO: started an outgoing call
  //         // TODO: show screen calling in Flutter
  //         break;
  //       case Event.ACTION_CALL_ACCEPT:
  //         // print("actionCallAccept----?}");
  //         Get.toNamed(Routes.callingScreenStaff, arguments: {
  //           "remoteMessage": message.data,
  //         });
  //
  //         // TODO: accepted an incoming call
  //         // TODO: show screen calling in Flutter
  //         break;
  //       case Event.ACTION_CALL_DECLINE:
  //         await homeController.updateCallStatus(AppString.available);
  //
  //         await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');
  //         await homeController.rejectCall(preferences.getString(preferences.userId) ?? '', message.data['_id'], 'staff');
  //         await FlutterCallkitIncoming.endAllCalls();
  //         // print("actionCallDecline----?}");
  //         // TODO: declined an incoming call
  //         break;
  //       case Event.ACTION_CALL_ENDED:
  //         // print("actionCallEnded----?}");
  //         // TODO: ended an incoming/outgoing call
  //         break;
  //       case Event.ACTION_CALL_TIMEOUT:
  //         await homeController.updateCallStatus(AppString.available);
  //
  //         await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');
  //         await homeController.rejectCall(preferences.getString(preferences.userId) ?? ''.toString(), message.data['_id'], 'staff');
  //
  //         await FlutterCallkitIncoming.endAllCalls();
  //         // TODO: missed an incoming call
  //         break;
  //       case Event.ACTION_CALL_CALLBACK:
  //         // TODO: only Android - click action `Call back` from missed call notification
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_HOLD:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_MUTE:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_DMTF:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_GROUP:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
  //         // TODO: only iOS
  //         break;
  //     }
  //   });
  // }

  static callHandle(RemoteMessage message) {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      debugPrint("EVENT__callHandle_______  ${event?.event.name}");
      switch (event!.event) {
        case Event.actionCallIncoming:
          await homeController.updateCallStatus(AppString.busy);
          // TODO: received an incoming call
          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallAccept:
          Get.toNamed(Routes.callingScreenStaff, arguments: {
            "remoteMessage": message.data,
          });
          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallDecline:
          await homeController.updateCallStatus(AppString.available);

          await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');
          await homeController.rejectCall(preferences.getString(preferences.userId) ?? '', message.data['_id'], 'staff');
          await FlutterCallkitIncoming.endAllCalls();
          // TODO: declined an incoming call
          break;
        case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
          break;
        case Event.actionCallTimeout:
          await homeController.updateCallStatus(AppString.available);
          await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');
          await homeController.rejectCall(preferences.getString(preferences.userId) ?? ''.toString(), message.data['_id'], 'staff');

          await FlutterCallkitIncoming.endAllCalls();
          // TODO: missed an incoming call
          break;
        case Event.actionCallCallback:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.actionCallToggleHold:
          // TODO: only iOS
          break;
        case Event.actionCallToggleMute:
          // TODO: only iOS
          break;
        case Event.actionCallToggleDmtf:
          // TODO: only iOS

          break;
        case Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
          // TODO: only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: only iOS
          break;
        case Event.actionCallCustom:
          // TODO: for custom action
          break;
      }
    });
  }

  // static callHandle1(RemoteMessage message) {
  //   FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
  //     // print("EVENT__callHandle1_______  ${event?.event.name}");
  //     switch (event!.event) {
  //       case Event.ACTION_CALL_INCOMING:
  //         // log("actionCallIncoming----?}_callHandle1");
  //         Future.delayed(const Duration(seconds: 1), () async {
  //           if (homeController.getStaffDetailResModel.data == null) {
  //             await homeController.getStaffDetailApi().then((result) async {
  //               if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.online) {
  //                 await homeController.updateCallStatus(AppString.busy);
  //               } else {
  //                 await homeController.activeStatusApi(AppString.online).then((result1) async {
  //                   await homeController.updateCallStatus(AppString.busy);
  //                 });
  //               }
  //             });
  //           } else {
  //             if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.online) {
  //               await homeController.updateCallStatus(AppString.busy);
  //             } else {
  //               await homeController.activeStatusApi(AppString.online).then((result1) async {
  //                 await homeController.updateCallStatus(AppString.busy);
  //               });
  //             }
  //           }
  //         });
  //
  //         // TODO: received an incoming call
  //         break;
  //       case Event.ACTION_CALL_START:
  //         // print("actionCallStart----?}_callHandle1");
  //         // TODO: started an outgoing call
  //         // TODO: show screen calling in Flutter
  //         break;
  //       case Event.ACTION_CALL_ACCEPT:
  //         // print('callHandleNew 44  ::::::: ELSE : Action call Accept');
  //         var pref = await SharedPreferences.getInstance();
  //         await preferences.setString(preferences.callAccept, "true");
  //         await pref.reload();
  //
  //         // print('*********************  Call Accept SET TRUE ****** ${preferences.getString(preferences.callAccept)}');
  //
  //         // TODO: accepted an incoming call
  //         // TODO: show screen calling in Flutter
  //         break;
  //       case Event.ACTION_CALL_DECLINE:
  //         // print("actionCallDecline----?}_callHandle1");
  //         await FlutterCallkitIncoming.endAllCalls();
  //         await homeController.rejectCall(preferences.getString(preferences.userId) ?? '', message.data['_id'], 'staff');
  //         await homeController.updateCallStatus(AppString.available).then((result111) async {
  //           await homeController.activeStatusApi(AppString.offline);
  //         });
  //         await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');
  //         // TODO: declined an incoming call
  //         break;
  //       case Event.ACTION_CALL_ENDED:
  //         // print("actionCallEnded----?}_callHandle1");
  //         // TODO: ended an incoming/outgoing call
  //         break;
  //       case Event.ACTION_CALL_TIMEOUT:
  //         // print("actionCallTimeout----?}_callHandle1");
  //         await FlutterCallkitIncoming.endAllCalls();
  //         await homeController.rejectCall(preferences.getString(preferences.userId) ?? '', message.data['_id'], 'staff');
  //
  //         await homeController.updateCallStatus(AppString.available).then((result1) async {
  //           await homeController.activeStatusApi(AppString.offline);
  //         });
  //
  //         await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');
  //
  //         // TODO: missed an incoming call
  //         break;
  //       case Event.ACTION_CALL_CALLBACK:
  //         // TODO: only Android - click action `Call back` from missed call notification
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_HOLD:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_MUTE:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_DMTF:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_GROUP:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
  //         // TODO: only iOS
  //         break;
  //       case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
  //         // TODO: only iOS
  //         break;
  //     }
  //   });
  // }
  static callHandle1(RemoteMessage message) {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      switch (event!.event) {
        case Event.actionCallIncoming:
          Future.delayed(const Duration(seconds: 1), () async {
            if (homeController.getStaffDetailResModel.data == null) {
              await homeController.getStaffDetailApi().then((result) async {
                if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.online) {
                  await homeController.updateCallStatus(AppString.busy);
                } else {
                  await homeController.activeStatusApi(AppString.online).then((result1) async {
                    await homeController.updateCallStatus(AppString.busy);
                  });
                }
              });
            } else {
              if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.online) {
                await homeController.updateCallStatus(AppString.busy);
              } else {
                await homeController.activeStatusApi(AppString.online).then((result1) async {
                  await homeController.updateCallStatus(AppString.busy);
                });
              }
            }
          });
          // TODO: received an incoming call
          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallAccept:
          var pref = await SharedPreferences.getInstance();
          await preferences.setString(preferences.callAccept, "true");
          await pref.reload();

          // print('*********************  Call Accept SET TRUE ****** ${preferences.getString(preferences.callAccept)}');
          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallDecline:
          await FlutterCallkitIncoming.endAllCalls();
          await homeController.rejectCall(preferences.getString(preferences.userId) ?? '', message.data['_id'], 'staff');
          await homeController.updateCallStatus(AppString.available).then((result111) async {
            await homeController.activeStatusApi(AppString.offline);
          });
          await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');
          // TODO: declined an incoming call
          break;
        case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
          break;
        case Event.actionCallTimeout:
          await FlutterCallkitIncoming.endAllCalls();
          await homeController.rejectCall(preferences.getString(preferences.userId) ?? '', message.data['_id'], 'staff');

          await homeController.updateCallStatus(AppString.available).then((result1) async {
            await homeController.activeStatusApi(AppString.offline);
          });

          await homeController.addCallHistory(message.data['_id'], preferences.getString(preferences.userId) ?? '', 'reject', '0');

          // TODO: missed an incoming call
          break;
        case Event.actionCallCallback:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.actionCallToggleHold:
          // TODO: only iOS
          break;
        case Event.actionCallToggleMute:
          // TODO: only iOS
          break;
        case Event.actionCallToggleDmtf:
          // TODO: only iOS
          break;
        case Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
          // TODO: only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: only iOS
          break;
        case Event.actionCallCustom:
          // TODO: for custom action
          break;
      }
    });
  }

  static Future<void> showCallkitIncoming(String uuid, RemoteMessage message) async {
    var callData = message.data;

    final params = CallKitParams(
      id: uuid,
      nameCaller: callData['user_name'],
      appName: 'Angel',
      avatar: AppAssets.blankProfile,
      handle: 'Incoming Audio Call...',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: <String, dynamic>{'message': message.data},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isImportant: true,

        isShowFullLockedScreen: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#28274C',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        // isShowMissedCallNotification: false,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    // await FlutterCallkitIncoming.startCall(params);
  }

  /// handle notification when app in fore ground..///close app
  static getInitialMsg() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      checkAndNavigationCallingPage();
    });
  }

  static Future<void> checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall().then((value) async {
      if (value != null) {
        // log('currentCall===========>>>>${currentCall}');
        // print('DATA::n   ${currentCall['n']}');
        // print('DATA::extra   ${currentCall['extra']}');
        var data;
        if (value['n'] == null) {
          data = value['extra']['message'];
        } else {
          data = value['n']['message'];
        }

        Get.toNamed(Routes.callingScreenStaff, arguments: {
          "remoteMessage": Map<String, dynamic>.from(data as Map),
        });
      } else {
        // print("DATA::NULL");
      }
    });
  }

  static Future<dynamic> getCurrentCall() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        return calls[0];
      } else {
        return null;
      }
    }
  }

  ///show notification msg
  static void showMsg(RemoteMessage? message) {
    flutterLocalNotificationsPlugin.show(
      message!.notification.hashCode,
      '${message.notification?.title}',
      '${message.notification?.body}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
        ),
        // iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  ///call when click on notification back
  static void onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == "Message" || message.data['type'] == "Offer" || message.data['type'] == "Other") {
        var angleId = message.data['angel_id'] ?? "";
        if (angleId != "") {
          Get.toNamed(Routes.personDetailScreen, arguments: {
            "angel_id": angleId,
          });
        }
      }
    });
  }
}
