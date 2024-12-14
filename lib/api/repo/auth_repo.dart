import 'dart:developer';

import 'package:talkangels/api/api_helper.dart';
import 'package:talkangels/const/request_constant.dart';
import 'package:talkangels/models/response_item.dart';

class AuthRepo {
  static Future<ResponseItem> userLogin(String name, String number, String cCode, String fcmToken) async {
    ResponseItem result;

    dynamic params = {
      "name": name,
      "mobile_number": number,
      "country_code": cCode,
      "fcmToken": fcmToken,
    };
    log('params==========33====>>>${params}');

    String requestUrl = AppUrls.BASE_URL + MethodNamesAngels.logIn;
    log('requestUrl========33======>>>${requestUrl}');
    result = await BaseApiHelper.postRequest(requestUrl, params);
    log('result=========33=====>>>${result}');
    return result;
  }

  /// logout _Staff
  static Future<ResponseItem> logOut(String mobileNumber) async {
    ResponseItem result;
    Map<String, dynamic> requestData = {
      "mobile_number": mobileNumber,
    };

    String requestUrl = AppUrls.BASE_URL + CommonApis.logOut;
    result = await BaseApiHelper.postRequestToken(requestUrl, requestData);
    return result;
  }
}
