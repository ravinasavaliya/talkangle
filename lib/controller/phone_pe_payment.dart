// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
// import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
// import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:talkangels/common/app_dialogbox.dart';
// import 'package:talkangels/const/shared_prefs.dart';
// import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
// import 'package:uuid/uuid.dart';
//
// class PaymentController extends GetxController {
//   CFPaymentGatewayService cfPaymentGatewayService = CFPaymentGatewayService();
//   HomeScreenController homeScreenController = Get.put(HomeScreenController());
//   String orderId = "";
//   String amount = "";
//   bool? isSuccess;
//   pay({String? amount}) async {
//     try {
//       var session = await createSession(amount: int.parse(amount.toString()));
//       List<CFPaymentModes> components = <CFPaymentModes>[];
//       // If you want to set paument mode to be shown to customer
//
//       var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();
//       // log('paymentComponent ---------->>>>>>>> ${paymentComponent.getComponents()}');
//       // We will set theme of checkout session page like fonts, color
//       var theme =
//           CFThemeBuilder().setNavigationBarBackgroundColorColor("#28274C").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();
//       // Create checkout with all the settings we have set earlier
//       var cfDropCheckoutPayment =
//           CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();
//       // Launching the payment page
//
//       cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
//     } on CFException catch (e) {
//       // print(e.message);
//     }
//   }
//
//   void verifyPayment(String orderId) {
//     // Here we will only print the statement
//     // to check payment is done or not
//     isSuccess = true;
//     update();
//
//     paymentSuccessDialog();
//     homeScreenController.addMyWalletAmountApi(amount, orderId).then((result) async {
//       await homeScreenController.userDetailsApi();
//     });
//     // print("Verify Payment $orderId");
//     // print("Verify Payment $orderId");
//   }
//
// // If some error occur during payment this will trigger
//   void onError(CFErrorResponse errorResponse, String orderId) {
//     // printing the error message so that we can show
//     // it to user or checkourselves for testing
//     isSuccess = false;
//     update();
//     paymentFailedDialog();
//     // print(errorResponse.getMessage());
//     // print("Error while making payment");
//   }
//
//   Future<CFSession?> createSession({int? amount}) async {
//     try {
//       orderId = const Uuid().v4().substring(0, 30);
//       final mySessionIDData = await createSessionID(orderId, amount: amount); // This will create session id from flutter itself
//
//       // Now we will se some parameter like orderID ,environment,payment sessionID
//       // after that we wil create the checkout session
//       // which will launch through which user can pay.
//
//       var session = CFSessionBuilder()
//           .setEnvironment(CFEnvironment.PRODUCTION)
//           .setOrderId(mySessionIDData["order_id"])
//           .setPaymentSessionId(mySessionIDData["payment_session_id"])
//           .build();
//       return session;
//     } on CFException catch (e) {
//       // print(e.message);
//     }
//     return null;
//   }
//
//   createSessionID(String orderID, {int? amount}) async {
//     var headers = {
//       'Content-Type': 'application/json',
//       'x-client-id': "657113654a6c5da4b57df357df311756",
//       'x-client-secret': "cfsk_ma_prod_fc98aaefee8f9d47bd04e64e4e458b4b_b64265d3",
//       // 'x-client-id': "TEST10160223fbdf4949a2c5c3d24fab32206101",
//       // 'x-client-secret': "cfsk_ma_test_17ce8c051e30f65e25688a6451334a1e_0a1c19ca",
//       'x-api-version': '2022-09-01', // This is latest version for API
//       'Accept': 'application/json',
//       'x-request-id': 'talkAngles'
//     };
//     // print(headers);
//     var request = http.Request('POST', Uri.parse('https://api.cashfree.com/pg/orders'));
//     // http.Request('POST', Uri.parse('https://sandbox.cashfree.com/pg/orders'));
//
//     request.body = json.encode({
//       "order_amount": amount,
//       "order_id": orderID, // OrderiD created by you it must be unique
//       "order_currency": "INR", // Currency of order like INR,USD
//       "customer_details": {
//         "customer_id": preferences.getString(preferences.userId) ?? '',
//         "customer_name": preferences.getString(preferences.names) ?? '',
//         // "customer_email": preferences.getString(preferences.userName) ?? '',
//         "customer_phone": preferences.getString(preferences.userNumber).toString()
//       },
//       "order_meta": {"notify_url": "https://test.cashfree.com"},
//       "order_note": "some order note here" // If you want to store something extra
//     });
//     request.headers.addAll(headers);
//
//     print("request.headers::::::::::::::${request.headers}");
//     print("request.body::::::::::::::${request.body}");
//
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       // If All the details is correct it will return the
//       // response and you can get sessionid for checkout
//
//       return jsonDecode(await response.stream.bytesToString());
//     } else {
//       // log(await response.stream.bytesToString());
//       log(response.reasonPhrase.toString());
//     }
//   }
// }
