import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/socket/socket_service.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/share_profile_details_service.dart';
import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_button.dart';
import 'package:talkangels/common/app_show_profile_pic.dart';

class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({Key? key}) : super(key: key);

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeController = Get.put(HomeScreenController());
  String angelId = Get.arguments["angel_id"];
  AngleData? angelData;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return Scaffold(
          appBar: AppAppBar(
            leadingIcon: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back)),
            titleText: AppString.personDetails,
            bottom: PreferredSize(
              preferredSize: const Size(300, 50),
              child: 1.0.appDivider(),
            ),
          ),
          body: GetBuilder<HomeScreenController>(
            builder: (controller) {
              homeController.angleAllData.forEach((element) {
                if (element.id == angelId) {
                  angelData = element;
                }
              });
              return RefreshIndicator(
                onRefresh: () {
                  if (handleNetworkConnection.isResult == false) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await homeController.homeAngleApi();
                      SocketConnection.connectSocket(() {
                        homeController.angleListeners();
                        print("socket connection---:::-");
                      });
                    });
                  }
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: Stack(
                        children: [
                          Container(
                              height: h,
                              width: w,
                              decoration: const BoxDecoration(gradient: appGradient),
                              child: controller.isLoading == true
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : angelData == null
                                      ? Center(
                                          child: AppString.noDataFound
                                              .leagueSpartanfs20w600(fontColor: greyFontColor, fontWeight: FontWeight.w700))
                                      : SafeArea(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        AppShowProfilePic(
                                                            image: angelData!.image ?? '',
                                                            onTap: () {
                                                              showDialog(
                                                                context: context,
                                                                builder: (_) => ProfileDialog(angelId: angelId),
                                                              );
                                                            },
                                                            borderShow: false,
                                                            radius: 70),
                                                        Positioned(
                                                          right: 6,
                                                          bottom: 6,
                                                          child: CircleAvatar(
                                                            backgroundColor: containerColor,
                                                            radius: 7,
                                                            child: CircleAvatar(
                                                                backgroundColor: angelData?.callAvailableStatus == "0"
                                                                    ? redColor
                                                                    : angelData?.callStatus == AppString.available
                                                                        ? greenColor
                                                                        : angelData?.callStatus == AppString.busy
                                                                            ? yellowColor
                                                                            : redFontColor,
                                                                radius: 4.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    (w * 0.03).addWSpace(),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          (angelData?.name ?? "").regularLeagueSpartan(
                                                            fontColor: whiteColor,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w500,
                                                            textOverflow: TextOverflow.ellipsis,
                                                          ),
                                                          (angelData?.userName ?? "").regularLeagueSpartan(
                                                            fontColor: whiteColor.withOpacity(0.4),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            textOverflow: TextOverflow.ellipsis,
                                                          ),
                                                          (angelData?.callAvailableStatus == "0"
                                                                  ? AppString.offline
                                                                  : angelData?.activeStatus ?? "")
                                                              .regularLeagueSpartan(
                                                                  fontColor: angelData?.callAvailableStatus == "0"
                                                                      ? yellowColor
                                                                      : angelData?.activeStatus == AppString.online
                                                                          ? greenColor
                                                                          : yellowColor,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500),
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (networkController.isResult == false) {
                                                          String url =
                                                              await DynamicLinkService().createShareProfileLink(angelId: angelData?.id);
                                                          Share.share(url);
                                                        } else {
                                                          showAppSnackBar(AppString.noInternetConnection);
                                                        }
                                                      },
                                                      child: const CircleAvatar(
                                                        backgroundColor: redFontColor,
                                                        radius: 20,
                                                        child: Icon(Icons.share, color: whiteColor, size: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ).paddingSymmetric(horizontal: w * 0.04, vertical: h * 0.02),
                                                1.0.appDivider(),

                                                ///About Me
                                                detailListTile(
                                                  image: const Icon(Icons.person, color: whiteColor),
                                                  title: AppString.aboutMe,
                                                ),
                                                (angelData?.bio ?? "")
                                                    .regularLeagueSpartan(
                                                      fontColor: greyFontColor,
                                                      fontSize: 15,
                                                    )
                                                    .paddingOnly(
                                                      left: w * 0.04,
                                                      right: w * 0.04,
                                                      bottom: h * 0.015,
                                                    ),
                                                1.0.appDivider(),

                                                /// Language
                                                detailListTile(
                                                  image: const Icon(Icons.translate_sharp, color: whiteColor),
                                                  title: AppString.language,
                                                ),
                                                (angelData?.language ?? "")
                                                    .regularLeagueSpartan(
                                                      fontColor: greyFontColor,
                                                      fontSize: 15,
                                                    )
                                                    .paddingOnly(
                                                      left: w * 0.04,
                                                      right: w * 0.04,
                                                      bottom: h * 0.015,
                                                    ),
                                                1.0.appDivider(),

                                                /// Personal Detail
                                                detailListTile(
                                                  image: const Icon(Icons.link, color: whiteColor),
                                                  title: AppString.personalDetails,
                                                ),
                                                ("${AppString.gender} : ${angelData?.gender ?? ""}")
                                                    .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                                    .paddingOnly(left: w * 0.04),
                                                ("${AppString.age}       : ${angelData?.age ?? ""} ${AppString.yrsOld}")
                                                    .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                                    .paddingOnly(left: w * 0.04, bottom: h * 0.015),
                                                1.0.appDivider(),

                                                /// Customer Rating
                                                InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet<void>(
                                                      constraints: BoxConstraints(maxHeight: h * 0.9, minHeight: h * 0.8),
                                                      isDismissible: true,
                                                      backgroundColor: containerColor,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.05),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                      height: 30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          color: textFieldColor, borderRadius: BorderRadius.circular(4)),
                                                                      child: const Icon(Icons.star, color: whiteColor)),
                                                                  (w * 0.03).addWSpace(),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          ("${AppString.customerRating} :  ").regularLeagueSpartan(),
                                                                          (angelData?.totalRating?.toStringAsFixed(1) ?? "0")
                                                                              .regularLeagueSpartan(fontWeight: FontWeight.w800)
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          ("${AppString.totalReviews} :   ").regularLeagueSpartan(),
                                                                          ("${(angelData?.reviews?.length ?? 0)} ${AppString.reviews}")
                                                                              .regularLeagueSpartan(fontWeight: FontWeight.w800)
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            2.0.appDivider(),
                                                            (h * 0.01).addHSpace(),
                                                            angelData?.reviews == null || angelData?.reviews?.length == 0
                                                                ? Expanded(
                                                                    child: Center(
                                                                        child: AppString.noReviewsYet
                                                                            .leagueSpartanfs20w600(fontColor: greyFontColor)))
                                                                : Expanded(
                                                                    child: ListView.builder(
                                                                      physics: const AlwaysScrollableScrollPhysics(),
                                                                      shrinkWrap: true,
                                                                      itemCount: angelData?.reviews?.length,
                                                                      itemBuilder: (context, index) {
                                                                        return Padding(
                                                                          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                                                                          child: SizedBox(
                                                                            width: w,
                                                                            child: Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: h * 0.015),
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: w * 0.8,
                                                                                        child: (angelData?.reviews?[index].comment ??
                                                                                                AppString.noComment)
                                                                                            .regularLeagueSpartan(fontColor: greyFontColor),
                                                                                      ),
                                                                                      1.0.appDivider(),
                                                                                      const Spacer(),
                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.star,
                                                                                            size: 18,
                                                                                            color: greyFontColor.withOpacity(0.3),
                                                                                          ),
                                                                                          ("${angelData?.reviews?[index].rating}")
                                                                                              .regularLeagueSpartan(
                                                                                                  fontWeight: FontWeight.w800,
                                                                                                  fontColor: greyFontColor),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                1.0.appDivider(),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          detailListTile(
                                                            image: const Icon(Icons.star, color: whiteColor),
                                                            title: AppString.customerRating,
                                                          ),
                                                          const Spacer(),
                                                          (angelData?.totalRating?.toStringAsFixed(1) ?? "")
                                                              .regularLeagueSpartan(
                                                                  fontColor: appColorGreen, fontSize: 16, fontWeight: FontWeight.w500)
                                                              .paddingOnly(right: w * 0.04),
                                                        ],
                                                      ),
                                                      ("${angelData?.totalListing ?? "0"} ${AppString.listing}")
                                                          .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                                          .paddingOnly(left: w * 0.04),
                                                      ("${angelData?.reviews?.length ?? "0"} ${AppString.reviews}")
                                                          .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15)
                                                          .paddingOnly(left: w * 0.04, bottom: h * 0.015),
                                                    ],
                                                  ),
                                                ),
                                                1.0.appDivider(),

                                                /// Charges
                                                detailListTile(
                                                  image: const Icon(Icons.currency_rupee, color: whiteColor),
                                                  title: AppString.charges,
                                                ),
                                                "₹ ${angelData?.userCharges ?? ""} ${AppString.perMin}"
                                                    .regularLeagueSpartan(
                                                      fontColor: greyFontColor,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w800,
                                                    )
                                                    .paddingOnly(
                                                      left: w * 0.04,
                                                      right: w * 0.04,
                                                      bottom: h * 0.015,
                                                    ),
                                                (h * 0.08).addHSpace(),
                                                AppButton(
                                                  onTap: () {
                                                    if (networkController.isResult == false) {
                                                      controller.setAngle(angelData!);
                                                      homeController.angleCallingApi(
                                                          angelData!.id!, preferences.getString(preferences.userId) ?? '');
                                                    } else {
                                                      showAppSnackBar(AppString.noInternetConnection);
                                                    }
                                                  },
                                                  color: angelData?.callAvailableStatus == "0"
                                                      ? redColor
                                                      : angelData?.callStatus == AppString.available
                                                          ? greenColor
                                                          : angelData?.callStatus == AppString.busy
                                                              ? yellowColor
                                                              : redFontColor,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(Icons.call, color: whiteColor),
                                                      (w * 0.03).addWSpace(),
                                                      (angelData?.callAvailableStatus == "0"
                                                              ? AppString.notAvailable
                                                              : angelData?.callStatus == AppString.available
                                                                  ? AppString.talkNow
                                                                  : angelData?.callStatus == AppString.busy
                                                                      ? AppString.busy
                                                                      : AppString.notAvailable)
                                                          .regularLeagueSpartan(fontWeight: FontWeight.w900, fontSize: 22),
                                                    ],
                                                  ),
                                                ).paddingSymmetric(horizontal: w * 0.04),
                                                (h * 0.03).addHSpace(),
                                              ],
                                            ),
                                          ),
                                        )),
                          controller.isCallLoading == true
                              ? Container(
                                  height: h,
                                  width: w,
                                  color: Colors.black26,
                                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  detailListTile({
    required Icon image,
    required String title,
    Color? fontColor,
  }) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(color: textFieldColor, borderRadius: BorderRadius.circular(4)),
                child: image)
            .paddingOnly(right: w * 0.03),
        title.regularLeagueSpartan(fontColor: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
      ],
    ).paddingOnly(left: w * 0.04, right: w * 0.04, top: h * 0.015, bottom: h * 0.005);
  }
}

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({Key? key, required this.angelId}) : super(key: key);
  final String angelId;

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  AngleData? angelData;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        controller.angleAllData.forEach((element) {
          if (element.id == widget.angelId) {
            angelData = element;
          }
        });
        return AlertDialog(
          insetPadding: EdgeInsets.only(left: Get.width * 0.06, right: Get.width * 0.3),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            padding: EdgeInsets.zero,
            height: Get.height * 0.35,
            width: Get.width * 0.9,
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.29,
                  width: Get.width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: angelData?.image == "" || angelData?.image == "0"
                      ? assetImage(AppAssets.blankProfile, fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: "${angelData?.image}",
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) => assetImage(AppAssets.blankProfile, fit: BoxFit.cover),
                          errorWidget: (context, url, error) => assetImage(AppAssets.blankProfile, fit: BoxFit.cover),
                        ),
                ),
                Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.9,
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (handleNetworkConnection.isResult == false) {
                              controller.setAngle(angelData!);
                              Get.back();
                              controller.angleCallingApi(angelData!.id.toString(), preferences.getString(preferences.userId) ?? '');
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: angelData?.callAvailableStatus == "0"
                                    ? redColor
                                    : angelData?.callStatus == AppString.available
                                        ? greenColor
                                        : angelData?.callStatus == AppString.busy
                                            ? yellowColor
                                            : redFontColor,
                                radius: 15,
                                child: const Icon(Icons.phone, color: whiteColor, size: 18),
                              ),
                              (Get.width * 0.02).addWSpace(),
                              (angelData?.callAvailableStatus == "0"
                                      ? AppString.notAvailable
                                      : angelData?.callStatus == AppString.available
                                          ? AppString.talkNow
                                          : angelData?.callStatus == AppString.busy
                                              ? AppString.busy
                                              : AppString.notAvailable)
                                  .regularLeagueSpartan(
                                      fontColor: angelData?.callAvailableStatus == "0"
                                          ? redColor
                                          : angelData?.callStatus == AppString.available
                                              ? greenColor
                                              : angelData?.callStatus == AppString.busy
                                                  ? yellowColor
                                                  : redFontColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            if (handleNetworkConnection.isResult == false) {
                              Get.back();
                              String url = await DynamicLinkService().createShareProfileLink(angelId: angelData?.id);
                              Share.share(url);
                            } else {
                              showAppSnackBar(AppString.noInternetConnection);
                            }
                          },
                          child: Container(
                            height: Get.width * 0.08,
                            width: Get.width * 0.08,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: greyFontColor),
                            ),
                            child: const Icon(Icons.share, color: greyFontColor, size: 18),
                          ),
                        ),
                        (Get.width * 0.01).addWSpace(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
