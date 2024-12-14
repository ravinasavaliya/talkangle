import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talkangels/api/repo/auth_repo.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/common/app_dialogbox.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/controller/log_out_res_model.dart';
import 'package:talkangels/models/angle_call_res_model.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/socket/socket_service.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/angels/models/add_rating_res_model.dart';
import 'package:talkangels/ui/angels/models/add_wallet_ballence_res_model.dart';
import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';
import 'package:talkangels/ui/angels/models/create_payment_res_model.dart';
import 'package:talkangels/ui/angels/models/delete_user_res_model.dart';
import 'package:talkangels/ui/angels/models/user_details_res_model.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HomeScreenController extends GetxController {
  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  CallingScreenController callingScreenController = Get.put(CallingScreenController());

  GetAngleListResModel resModel = GetAngleListResModel();
  bool isLoading = false;

  UserDetailsResponseModel userDetailsResModel = UserDetailsResponseModel();
  bool isUserLoading = true;

  AngleCallResModel angleCallResModel = AngleCallResModel();
  bool isCallLoading = false;

  DeleteAngelsResModel deleteAngelsResModel = DeleteAngelsResModel();
  bool isDelete = false;

  AddRatingResModel addRatingResModel = AddRatingResModel();
  bool isRatingLoading = false;

  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  List searchAngelsList = [];

  AddWalletBallanceResponseModel addWalletBallanceResponseModel = AddWalletBallanceResponseModel();
  bool isAmountLoading = false;

  LogOutResModel logOutResModel = LogOutResModel();
  bool logOutLoading = false;

  bool createPaymentLoading = false;
  CreatePaymentResModel createPaymentResModel = CreatePaymentResModel();

  AngleData? selectedAngle;
  setAngle(AngleData value) {
    selectedAngle = value;
    update();
  }

  search() {
    if (handleNetworkConnection.isResult == true) {
      searchController.clear();
      update();
    }
  }

  List<AngleData> angleAllData = [];
  homeAngleApi() async {
    isLoading = true;

    ResponseItem item = await HomeRepoAngels.getAngleAPi();
    if (item.status == true) {
      try {
        angleAllData.clear();
        update();
        resModel = GetAngleListResModel.fromJson(item.data);
        resModel.data!.forEach((element) {
          angleAllData.add(element);
        });
        anglesFilterData();
        isLoading = false;
        update();
      } catch (e) {
        // log("e========error=======>$e");
        isLoading = false;
        update();
      }
    } else {
      isLoading = false;
      update();
    }
    return resModel;
  }

  Future<void> angleListeners() async {
    getSocketAllAngleOn();
  }

  Future<void> getSocketAllAngle() async {
    SocketConnection.socket!.emit(
      'getAllAngels',
      {},
    );
  }

  getSocketAllAngleOn() {
    SocketConnection.socket!.on("getAllAngels", (data) {
      angleAllData.clear();

      update();
      GetAngleListResModel resModel = GetAngleListResModel.fromJson(data);
      resModel.data!.forEach((element) {
        angleAllData.add(element);
        anglesFilterData();
      });
      update();
    });
  }

  List<AngleData> availableCallStatusAngelsList = [];
  List<AngleData> angelsAvailableList = [];
  List<AngleData> angelsBusyList = [];
  List<AngleData> angelsNotAvailableList = [];
  List<AngleData> allAngelsListData = [];

  anglesFilterData() {
    availableCallStatusAngelsList = [];
    angelsAvailableList = [];
    angelsBusyList = [];
    angelsNotAvailableList = [];
    allAngelsListData = [];

    angleAllData.forEach((element) {
      if (element.callAvailableStatus == "0") {
        availableCallStatusAngelsList.add(element);
        update();
      } else {
        if (element.callStatus == AppString.available) {
          angelsAvailableList.add(element);
          update();
        } else if (element.callStatus == AppString.busy) {
          angelsBusyList.add(element);
          update();
        } else {
          angelsNotAvailableList.add(element);
          update();
        }
      }
    });

    allAngelsListData = angelsAvailableList + angelsBusyList + angelsNotAvailableList + availableCallStatusAngelsList;
    update();
    return allAngelsListData;
  }

  searchData(String text) {
    searchAngelsList = [];
    if (text.isNotEmpty || text != "") {
      angleAllData.forEach((element) {
        if (element.name.toString().trim().toLowerCase().contains(text.toString().trim().toLowerCase())) {
          searchAngelsList.add(element);
          update();
        }
      });
    }
  }

  angleCallingApi(String angleId, String userId) async {
    isCallLoading = true;
    update();
    ResponseItem item = await HomeRepoAngels.callApi(angleId, userId);
    // log("item---------->${item.data}");
    if (item.status == true) {
      try {
        angleCallResModel = AngleCallResModel.fromJson(item.data);


        debugPrint('WakelockPlus==========>>>>>${await WakelockPlus.enabled}');
        Get.toNamed(Routes.callingScreen, arguments: {
          "selectedAngle": selectedAngle,
          "angleCallResModel": angleCallResModel,
        });

        isCallLoading = false;
        update();
      } catch (e) {
        // log("e----->$e");
        isCallLoading = false;
        update();
      }
    } else {
      if (item.statusCode == 404) {
        ///Angel is now busy. Please try again later
        ///

        if (item.message == "Insufficient balance. Please recharge your account.") {
          /// Add Wallet Amount DialogBox
          addWalletAmountDialogBox();
        } else {
          showAppSnackBar("${item.message}");
        }
        isCallLoading = false;
        update();
      }
      isCallLoading = false;
      update();
    }
    return angleCallResModel;
  }

  /// Get User Detail Api
  userDetailsApi() async {
    isUserLoading = true;

    ResponseItem item = await HomeRepoAngels.getUserDetailsAPi();
    if (item.status == true) {
      // try {
      userDetailsResModel = UserDetailsResponseModel.fromJson(item.data);
      isUserLoading = false;
      update();
      // } catch (e) {
      //   log("e===============>$e");
      isUserLoading = false;
      update();
      // }
    } else {
      isUserLoading = false;
      update();
    }
    return userDetailsResModel;
  }

  /// Delete Account Api
  deleteAccountApi() async {
    isDelete = true;
    update();
    ResponseItem item = await HomeRepoAngels.deleteAngelApi();
    if (item.status == true) {
      try {
        deleteAngelsResModel = DeleteAngelsResModel.fromJson(item.data);
        isDelete = false;
        update();
      } catch (e) {
        // log("e===============>$e");
        isDelete = false;
        update();
      }
    } else {
      isDelete = false;
      update();
    }
    return deleteAngelsResModel;
  }

  /// Add Rating Api
  addRatingApi(String angelId, String rating, String comment) async {
    isRatingLoading = true;
    update();

    ResponseItem result = await HomeRepoAngels.postRatingApi(angelId, rating, comment);
    if (result.status) {
      try {
        addRatingResModel = AddRatingResModel.fromJson(result.data);
        Get.back();
        isRatingLoading = false;
        update();
      } catch (e) {
        // log("e----------   $e");
        isRatingLoading = false;
        update();
      }
    } else {
      isRatingLoading = false;
      update();
      showAppSnackBar("${result.message}");
    }
    return addRatingResModel;
  }

  /// Add Wallet Amount
  addMyWalletAmountApi(String amount, String paymentId) async {
    isAmountLoading = true;
    update();

    ResponseItem item = await HomeRepoAngels.walletApi(amount, paymentId);
    if (item.status == true) {
      try {
        addWalletBallanceResponseModel = AddWalletBallanceResponseModel.fromJson(item.data);
        isAmountLoading = false;
        update();
      } catch (e) {
        // log("e----->$e");
        isAmountLoading = false;
        update();
      }
    } else {
      isAmountLoading = false;
      update();
    }
    return addWalletBallanceResponseModel;
  }

  /// LOG-OUT API
  logOut(String mobileNumber) async {
    logOutLoading = true;
    update();

    ResponseItem item = await AuthRepo.logOut(mobileNumber);
    // log("item---4------->${item.data}");
    if (item.status == true) {
      try {
        logOutResModel = LogOutResModel.fromJson(item.data);
        logOutLoading = false;
        update();
      } catch (e) {
        // log("e=======logOut=======>$e");
        logOutLoading = false;
        update();
      }
    } else {
      logOutLoading = false;
      update();
    }
    return logOutResModel;
  }

  /// Create Payment Api
  createPaymentApi({
    required String userId,
    required String userName,
    required String phoneNumber,
    required String amount,
    required String token,
  }) async {
    createPaymentLoading = true;
    update();

    ResponseItem item = await HomeRepoStaff.postCreatePaymentApi(
        userId: userId, userName: userName, phoneNumber: phoneNumber, amount: amount, token: token);
    if (item.status == true) {
      try {
        createPaymentResModel = CreatePaymentResModel.fromJson(item.data);

        createPaymentLoading = false;
        update();
      } catch (e) {
        log("e=======addCallHistory=======>$e");
        createPaymentLoading = false;
        update();
      }
    } else {
      createPaymentLoading = false;
      update();
    }
    return createPaymentResModel;
  }

  getReversePaymentHistory() {}
}
