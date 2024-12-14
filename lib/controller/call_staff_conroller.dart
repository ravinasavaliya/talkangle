import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';

class CallingScreenControllerStaff extends GetxController {
  RtcEngine? engine;
  String channelId = "";
  String appId = "";
  String token = "";
  String angleId = "";
  Timer? secondCountTimer;
  int secondCount = 0;
  bool isLeaveChannel = true;

  setAgoraDetails(String channellId, String apppId, String tokenn, String angleIdd) async {
    isLeaveChannel = true;
    channelId = channellId;
    appId = apppId;
    token = tokenn;
    angleId = angleIdd;
    update();
    var pref = await SharedPreferences.getInstance();
    await preferences.setString(preferences.callerUserId, angleIdd);
    await pref.reload();
    initEngine();
  }

  bool isJoined = false, isConnect = false, openMicrophone = true, enableSpeakerphone = false, playEffect = false;
  bool enableInEarMonitoring = false;
  double recordingVolume = 100, playbackVolume = 100, inEarMonitoringVolume = 100;
  ChannelProfileType channelProfileType = ChannelProfileType.channelProfileLiveBroadcasting;
  RtcEngineEventHandler? rtcEngineEventHandler;
  HomeController homeController = Get.put(HomeController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  Future<void> initEngine() async {
    await preferences.init();
    var pref = await SharedPreferences.getInstance();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    // FlutterBackgroundService().startService();
    engine = createAgoraRtcEngine();
    await engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await engine!.enableAudio();
    await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster,);
    await engine!.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    debugPrint('token==========>>>>>${token}');
    debugPrint('channelId==========>>>>>${channelId}');
    await engine!.joinChannel(
        token: token,
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
    rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        log("err---yyyyyyyyyyyyyyyyyy-->${err}  $msg");
      },

      onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
        debugPrint('connection==========>>>>>${connection.localUid}');
        if (isConnect == false) {
          secondCountTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
            secondCount = secondCount + 1;
            update();

            await preferences.setString(preferences.callSecondCount, secondCount.toString());
            await pref.reload();
            debugPrint(
                "***************************onJoinChannelSuccess***callSecondCount=${preferences.getString(preferences.callSecondCount)}");
            debugPrint("secondCount----------STAFF----> $secondCount");
          });
          isConnect = true;
          isJoined = true;
          update();
          await preferences.setBool(preferences.callStart, true);
          await pref.reload();
          debugPrint("***************************onJoinChannelSuccess***callStart=${preferences.getBool(preferences.callStart)}");

          /// Join Channel
        }
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint("***************************onUserJoined$remoteUid");
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) async {
        isJoined = false;
        secondCountTimer?.cancel();
        await leaveChannel();
        update();
        await preferences.setBool(preferences.callStart, false);
        await pref.reload();
        debugPrint("***************************onLeaveChannel***callStart=${preferences.getBool(preferences.callStart)}");
        Get.back();
      },
      onUserOffline: (connection, remoteUid, reason) async {
        await leaveChannel();
        update();
        await preferences.setBool(preferences.callStart, false);
        await pref.reload();
        debugPrint("***************************onUserOffline***callStart=${preferences.getBool(preferences.callStart)}");
        Get.back();
      },
      // onAudioDeviceVolumeChanged: (deviceType, volume, muted) {

      // },
    );

    engine!.registerEventHandler(rtcEngineEventHandler!);
  }

  @override
  void onClose() {
    debugPrint("***************************onClose");
    leaveChannel();
    super.onClose();
  }

  leaveChannel() async {
    // await engine!.release();
    debugPrint('leaveChannel===========>>>$isLeaveChannel}');
    if (isLeaveChannel == true) {
      isLeaveChannel = false;

      FlutterCallkitIncoming.endAllCalls();
      await engine?.leaveChannel();

      await homeController.updateCallStatus(AppString.available);
      // debugPrint('leaveChannel==========updateCallStatus=>>>}');
      await homeController
          .addCallHistory(angleId, preferences.getString(preferences.userId).toString(), "incoming", secondCount.toString())
          .then((result) async {
        // debugPrint('leaveChannel==========addCallHistory=>>>}');
        if (preferences.getString(preferences.roles).toString() == AppString.staff) {
          await homeController.getStaffDetailApi();
          // debugPrint('leaveChannel==========getStaffDetailApi=>>>}');
        }
      });

      // await homeController.updateCallStatus(AppString.available);
      //  await homeController
      //     .addCallHistory(angleId, preferences.getString(preferences.userId).toString(), "incoming", secondCount.toString())
      //     .then((result) async {
      //   if (preferences.getString(preferences.roles).toString() == AppString.staff) {
      //     await homeController.getStaffDetailApi();
      //   }
      // });
      isJoined = false;
      isConnect = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
      enableInEarMonitoring = false;
      recordingVolume = 100;
      playbackVolume = 100;
      inEarMonitoringVolume = 100;
      secondCountTimer?.cancel();
      secondCount = 0;
      update();
      final isRunning = await FlutterBackgroundService().isRunning();
      if (isRunning) {
        // debugPrint('stop listen -leaveChannel');
        FlutterBackgroundService().invoke("stop");
      }

      var pref = await SharedPreferences.getInstance();
      await preferences.setString(preferences.callerUserId, '0');
      await preferences.setString(preferences.callSecondCount, '0');
      await preferences.setBool(preferences.callStart, false);
      // await preferences.setBool(preferences.callStartAppDetached, false);
      pref.reload();
    }
  }

  switchMicrophone() async {
    await engine!.enableLocalAudio(!openMicrophone);
    openMicrophone = !openMicrophone;
    update();
  }

  switchSpeakerphone() async {
    await engine!.setEnableSpeakerphone(!enableSpeakerphone);
    enableSpeakerphone = !enableSpeakerphone;
    update();
  }
}
