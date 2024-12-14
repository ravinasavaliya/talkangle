import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:talkangels/api/api_helper.dart';
import 'package:talkangels/const/request_constant.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/staff/models/update_staff_details_res_model.dart';

///Angels
class HomeRepoAngels {
  static Future<ResponseItem> getAngleAPi() async {
    ResponseItem result;

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.getAngle;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.getRequest(requestUrl);
    return result;
  }

  /// Get Single Angel Data Api
  static Future<ResponseItem> getSingleAngleAPi(String angelId) async {
    ResponseItem result;

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.getSingleAngleDetails + angelId;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.getRequest(requestUrl);
    return result;
  }

  static Future<ResponseItem> callApi(String angleId, String userId) async {
    ResponseItem result;
    Map<String, dynamic> params = {
      "angel_id": angleId,
      "user_id": userId,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.callAngle;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, params);
    return result;
  }

  /// add wallet amount api
  static Future<ResponseItem> walletApi(String amount, String paymentId) async {
    ResponseItem result;
    Map<String, dynamic> params = {
      "user_id": preferences.getString(preferences.userId) ?? '',
      "amount": amount,
      "payment_id": paymentId,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.angleWallet;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, params);
    return result;
  }

  /// get user details
  static Future<ResponseItem> getUserDetailsAPi() async {
    ResponseItem result;
    String userId = preferences.getString(preferences.userId) ?? '';

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.getUserDetails + userId;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.getRequest(requestUrl);
    return result;
  }

  /// get all recharge list
  static Future<ResponseItem> getAllRechargesApi() async {
    ResponseItem result;

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.getRechargeList;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.getRequest(requestUrl);
    return result;
  }

  /// post referral code
  static Future<ResponseItem> postReferralCodeApi(String referCode) async {
    ResponseItem result;
    Map<String, dynamic> requestData = {
      "user_id": preferences.getString(preferences.userId) ?? '',
      "refer_code": referCode,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.postReferralCode;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    return result;
  }

  /// post Rating code
  static Future<ResponseItem> postRatingApi(String angelId, String rating, String comment) async {
    // log("ID==1===  ${PreferenceManager().getId()}");
    // log("ID===2==  ${angelId}");
    // log("ID===3==  ${rating}");
    // log("ID===4==  ${comment}");
    ResponseItem result;
    Map<String, dynamic> requestData = {
      "user_id": preferences.getString(preferences.userId) ?? '',
      "angel_id": angelId,
      "rating": rating,
      "comment": comment
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.postRating;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    return result;
  }

  /// Post Report a Problem
  static Future<ResponseItem> postReportAProblemApi(String comment) async {
    ResponseItem result;
    Map<String, dynamic> requestData = {
      "user": preferences.getString(preferences.userId) ?? '',
      "comment": comment,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.postReportAProblem;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    return result;
  }

  /// Delete Angel Account
  static Future<ResponseItem> deleteAngelApi() async {
    ResponseItem result;
    String userId = preferences.getString(preferences.userId) ?? '';

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.deleteAngel + userId;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.deleteAngel(requestUrl);
    return result;
  }
}

///Staff
class HomeRepoStaff {
  /// Get staff Details

  static Future<ResponseItem> getStaffDetail() async {
    ResponseItem result;
    String userId = preferences.getString(preferences.userId) ?? '';

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.getStaffDetails + userId;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.getRequest(requestUrl);

    return result;
  }

  /// Get Call History

  static Future<ResponseItem> getCallHistory() async {
    ResponseItem result;

    String userId = preferences.getString(preferences.userId) ?? '';

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.getStaffCallHistory + userId;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.getRequest(requestUrl);

    return result;
  }

  /// Post Send Withdraw Request
  static Future<ResponseItem> sendWithdrawRequest(String amount) async {
    ResponseItem result;
    String userId = preferences.getString(preferences.userId) ?? '';

    Map<String, dynamic> requestData = {
      "staffId": userId,
      "request_amount": amount,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.sendWithdrawRequest;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    return result;
  }

  /// Put Active Status

  static Future<ResponseItem> activeStatusUpdate(String status) async {
    ResponseItem result;
    String userId = preferences.getString(preferences.userId) ?? '';

    Map<String, dynamic> requestData = {
      "active_status": status,
      // "Online", "Offline"
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.activeStatus + userId;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.putRequestToken(requestUrl, requestData);
    return result;
  }

  /// Add Call History

  static Future<ResponseItem> addCallHistory(String angelId, String staffId, String callType, String minutes) async {
    ResponseItem result;

    Map<String, dynamic> requestData = {
      "staff_id": staffId,
      "user_id": angelId,
      "call_type": callType,
      "seconds": minutes,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.addCallHistory;

    // debugPrint('requestUrl::${requestUrl}');
    // debugPrint('requestData::${requestData}');
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    // debugPrint('result::${result.statusCode}::${result.message}::${result.data}');

    return result;
  }

  ///call reject
  ///
  static Future<ResponseItem> callReject(String angelId, String userId, String type) async {
    ResponseItem result;

    Map<String, dynamic> requestData = {
      "angel_id": angelId,
      "user_id": userId,
      "type": type,
    };
    String requestUrl = AppUrls.BASE_URL + CommonApis.rejectCall;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    return result;
  }

  /// Post Report a Problem _Staff
  static Future<ResponseItem> postReportAProblemStaffApi(String comment) async {
    ResponseItem result;
    Map<String, dynamic> requestData = {
      "user": preferences.getString(preferences.userId) ?? '',
      "comment": comment,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.postReportProblemStaff;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    return result;
  }

  /// Post Report a Problem _Staff
  static Future<ResponseItem> updateCallStatus(String callStatus) async {
    ResponseItem result;
    String userId = preferences.getString(preferences.userId) ?? '';
    Map<String, dynamic> requestData = {
      "call_status": callStatus,
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.updateCallStatus + userId;
    // debugPrint('requestUrl::${requestUrl}');
    // debugPrint('requestData::${requestData}');
    result = await BaseApiHelper.putRequestToken(requestUrl, requestData);
    // debugPrint('result::${result.statusCode}::${result.message}::${result.data}');

    return result;
  }

  /// Post Report a Problem _Staff
  static Future<ResponseItem> updateAngelAvailableStatus(String availableStatus) async {
    ResponseItem result;
    String userId = preferences.getString(preferences.userId) ?? '';
    Map<String, dynamic> requestData = {
      "call_available_status": availableStatus.toString()
      // 0, 1
    };

    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.updateAngelAvailableStatus + userId;
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.putRequestToken(requestUrl, requestData);

    return result;
  }

  /// Post Staff Details
  static Future<UpdateStaffDetailResModel?> updateStaffDetails(
      {String? userName,
      String? name,
      String? email,
      String? gender,
      String? bio,
      String? language,
      String? age,
      String? image,
      String? fileType}) async {
    UpdateStaffDetailResModel? result;

    var res = await BaseApiHelper.putStaffDetails(
        age: age,
        language: language,
        bio: bio,
        name: name,
        email: email,
        userName: userName,
        image: image,
        gender: gender,
        fileType: fileType);
    result = UpdateStaffDetailResModel.fromJson(res);
    return result;
  }

  /// Post Create Payment API
  static Future<ResponseItem> postCreatePaymentApi({
    required String userId,
    required String userName,
    required String phoneNumber,
    required String amount,
    required String token,
  }) async {
    ResponseItem result;

    String requestUrl = "${AppUrls.BASE_URL}user/create-payment/$userId?phone=$phoneNumber&name=$userName&amount=$amount";
    // String requestUrl = "${AppUrls.BASE_URL}user/create-payment/66e425b95eab634e343fd5c4?phone=7623977513&name=Flutter Dev&amount=10";
    // debugPrint('requestUrl::${requestUrl}');
    result = await BaseApiHelper.getRequest(requestUrl);
    return result;
  }
}
