import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/angels/models/user_details_res_model.dart';
import 'package:talkangels/ui/staff/main/call_history_pages/call_history_controller.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> with WidgetsBindingObserver {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeController = Get.put(HomeScreenController());

  CallHistoryController callHistoryController = Get.put(CallHistoryController());

  @override
  void initState() {
    super.initState();
    if (handleNetworkConnection.isResult == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await homeController.userDetailsApi();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return Scaffold(
          appBar: AppAppBar(
            titleText: AppString.paymentHistory,
            titleSpacing: w * 0.06,
            bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
          ),
          body: GetBuilder<HomeScreenController>(
            builder: (controller) {
              return RefreshIndicator(
                onRefresh: () {
                  if (handleNetworkConnection.isResult == false) {
                    /// GET USE DETAIL API
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await homeController.userDetailsApi();
                    });
                  }
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: Container(
                  height: h,
                  width: w,
                  decoration: const BoxDecoration(gradient: appGradient),
                  child: SafeArea(
                    child: controller.isUserLoading == true
                        ? const Center(child: CircularProgressIndicator(color: whiteColor))
                        : controller.userDetailsResModel.status == 200
                            ? controller.userDetailsResModel.data?.talkAngelWallet?.transections?.isEmpty ?? true
                                ? Center(
                                    child: AppString.noDataFound
                                        .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 20, fontWeight: FontWeight.w700))
                                : ListView.builder(
                                    //reverse: true,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: controller.userDetailsResModel.data?.talkAngelWallet?.transections?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      List<Transection> data = List<Transection>.from(
                                          controller.userDetailsResModel.data!.talkAngelWallet!.transections!.reversed);
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "ID : ",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily: 'League Spartan',
                                                        ),
                                                      ),
                                                      Text(
                                                        "${data[index].id}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily: 'League Spartan',
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        data[index].status == '0' ? "Fail" : data[index].status ?? '',
                                                        style: TextStyle(
                                                          color: data[index].status == '0'
                                                              ? Colors.red
                                                              : data[index].status == 'SUCCESS'
                                                                  ? Colors.green
                                                                  : Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text("Amount : ",
                                                          style:
                                                              TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'League Spartan')),
                                                      Text("${data[index].amount ?? 0}  •",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'League Spartan')),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("${DateFormat('MMM dd').format(data[index].date ?? DateTime.now())}  •",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const Text("CREDIT",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          )),
                                                      const Spacer(),
                                                      Text("Balance : ${data[index].curentBellance ?? 0}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          1.0.appDivider()
                                        ],
                                      );
                                    },
                                  )
                            : StaffErrorScreen(
                                isLoading: controller.isLoading,
                                onTap: () {
                                  if (networkController.isResult == false) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                                      await callHistoryController.getCallHistoryApi();
                                    });
                                  }
                                },
                              ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
