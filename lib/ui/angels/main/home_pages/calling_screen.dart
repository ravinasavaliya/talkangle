import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/models/angle_call_res_model.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({Key? key}) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  AngleData selectedAngle = Get.arguments["selectedAngle"];
  AngleCallResModel angleCallResModel = Get.arguments["angleCallResModel"];
  HomeScreenController angelsHomeController = Get.find();
  HomeController homeController1 = Get.put(HomeController());
  CallingScreenController callingScreenController = Get.put(CallingScreenController());
  bool isBluetooth = false;

  final MethodChannel _channel =
  const MethodChannel('agora_rtc_ng_example/foreground_service');
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _channel.invokeMethod('start_foreground_service');

      await setupAudioSession();
      callingScreenController.setAngle(selectedAngle);
      callingScreenController.setAgoraDetails(
        angleCallResModel.data?.agoraInfo!.channelName ?? '',
        angleCallResModel.data?.agoraInfo!.token!.appId ?? '',
        angleCallResModel.data?.agoraInfo!.token!.agoraToken ?? '',
      );
      callingScreenController.initEngine();

      callingScreenController.callerTuneState();
    });

    // TODO: implement initState
    super.initState();
  }

  Future<void> setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    await session.setActive(true);
  }

  @override
  void dispose() {
    _channel.invokeMethod('stop_foreground_service');

  if (callingScreenController.isLeaveChannel == true) {
      callingScreenController.leaveChannel();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          callingScreenController.timers!.cancel();
        });
      }
      callingScreenController.player;
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<CallingScreenController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(gradient: appGradient),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  children: [
                    const Spacer(),
                    (h * 0.04).addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.call, color: whiteColor, size: 14),
                        (w * 0.015).addWSpace(),
                        formatDurationInHhMmSs(
                          Duration(seconds: controller.secondCount),
                        ).regularLeagueSpartan(),
                      ],
                    ),
                    (h * 0.05).addHSpace(),
                    (angelsHomeController.selectedAngle?.name ?? '').regularLeagueSpartan(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                    controller.secondCount > 0
                        ? AppString.callConnected.regularLeagueSpartan(fontSize: 14)
                        : AppString.calling.regularLeagueSpartan(fontSize: 14),
                    const Spacer(),
                    RippleAnimation(
                      color: callingAnimationColor.withOpacity(0.04),
                      delay: const Duration(milliseconds: 30),
                      repeat: true,
                      minRadius: 56,
                      ripplesCount: 6,
                      duration: const Duration(milliseconds: 6 * 300),
                      child: angelsHomeController.selectedAngle?.image == ""
                          ? const CircleAvatar(
                              minRadius: 75,
                              maxRadius: 75,
                              backgroundImage: AssetImage(AppAssets.blankProfile),
                            )
                          : CircleAvatar(
                              minRadius: 75,
                              maxRadius: 75,
                              backgroundImage: NetworkImage(angelsHomeController.selectedAngle?.image ?? ''),
                            ),
                    ),
                    const Spacer(),
                    (h * 0.06).addHSpace(),
                    Container(
                      height: h * 0.17,
                      width: w,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// MUTE
                          GestureDetector(
                            onTap: () {
                              controller.switchMicrophone();
                            },
                            child: Container(
                              height: h,
                              width: w * 0.29,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  svgAssetImage(
                                    AppAssets.muteIcon,
                                    color: controller.openMicrophone ? whiteColor.withOpacity(0.5) : whiteColor,
                                    height: h * 0.045,
                                  ),
                                  (h * 0.01).addHSpace(),
                                  AppString.mute.regularLeagueSpartan(
                                      fontColor: controller.openMicrophone ? whiteColor.withOpacity(0.5) : whiteColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ),
                          ),

                          /// SPEAKER
                          GestureDetector(
                            onTap: () {
                              controller.switchSpeakerphone();
                            },
                            child: Container(
                              height: h * 0.1,
                              width: w * 0.25,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: svgAssetImage(
                                      AppAssets.volumeIcon,
                                      color: controller.enableSpeakerphone ? whiteColor : whiteColor.withOpacity(0.5),
                                    ),
                                  ),
                                  (h * 0.01).addHSpace(),
                                  AppString.speaker.regularLeagueSpartan(
                                      fontColor: controller.enableSpeakerphone ? whiteColor : whiteColor.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (h * 0.06).addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (callingScreenController.isLeaveChannel == true) {
                              log('HomecallingScreenController.isLeaveChannel======>${callingScreenController.isLeaveChannel}');
                              controller.leaveChannel();
                            }
                            if (callingScreenController.isUserJoined == false) {
                              log('HomecallingScreenController.isUserJoined======>${callingScreenController.isUserJoined}');
                              callingScreenController.rejectCall();
                            }
                            log('else======>');
                            Get.back();
                          },
                          child: const CircleAvatar(
                            radius: 33,
                            backgroundColor: redFontColor,
                            child: Icon(Icons.call_end, color: whiteColor, size: 28),
                          ),
                        ),
                      ],
                    ),
                    (h * 0.07).addHSpace(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String formatDurationInHhMmSs(Duration duration) {
    final hh = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (hh == "00") {
      return '$mm:$ss';
    } else {
      return '$hh:$mm:$ss';
    }
  }
}
