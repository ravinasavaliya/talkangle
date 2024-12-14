// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:talkangels/const/app_color.dart';
// import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
//
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   String angelId = Get.arguments["angel_id"];
//   String userNumber = Get.arguments["user_number"];
//   String userName = Get.arguments["user_name"];
//   String amount = Get.arguments["amount"];
//   String token = Get.arguments["token"];
//   HomeScreenController homeController = Get.put(HomeScreenController());
//
//   bool isLoading = true;
//   bool selectedPage = false;
//
//   RxDouble progress = 0.0.obs;
//   setProgress(int newProgress) {
//     progress.value = newProgress / 100;
//   }
//
//   InAppWebViewController? _inAppWebViewController;
//
//   setWebViewController(InAppWebViewController controller) {
//     _inAppWebViewController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: selectedPage,
//       onPopInvoked: (didPop) async {
//         if (selectedPage == false) {
//           await homeController.userDetailsApi();
//           Get.back();
//           Get.back();
//           debugPrint(":::::selectedPage - PopScope:::::: $selectedPage");
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Payment",
//             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'League Spartan'),
//           ),
//           centerTitle: true,
//           backgroundColor: appBarColor,
//           iconTheme: const IconThemeData(color: Colors.white),
//           leading: const Icon(Icons.arrow_back, color: appBarColor),
//           elevation: 0,
//         ),
//         body: Stack(
//           children: [
//             InAppWebView(
//               onProgressChanged: (InAppWebViewController inAppWebViewController, int progress) {
//                 setProgress(progress);
//               },
//               onWebViewCreated: (InAppWebViewController inAppWebViewController) {
//                 setWebViewController(inAppWebViewController);
//               },
//               onCloseWindow: (InAppWebViewController controller) {
//                 controller.closeAllMediaPresentations();
//                 controller.clearFocus();
//                 controller.clearHistory();
//               },
//               onPermissionRequest: (InAppWebViewController controller, PermissionRequest permissionRequest) async {
//                 if (permissionRequest.resources.contains(PermissionResourceType.MICROPHONE)) {
//                   final PermissionStatus permissionStatus = await Permission.microphone.request();
//                   if (permissionStatus.isGranted) {
//                     return PermissionResponse(
//                       resources: permissionRequest.resources,
//                       action: PermissionResponseAction.GRANT,
//                     );
//                   } else if (permissionStatus.isDenied) {
//                     return PermissionResponse(
//                       resources: permissionRequest.resources,
//                       action: PermissionResponseAction.DENY,
//                     );
//                   }
//                 }
//                 return null;
//               },
//               initialUrlRequest: URLRequest(
//                   url: WebUri.uri(Uri.parse('https://www.talkangels.com/payment/$angelId/$userNumber/$userName/$amount/$token'))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// OLD CODE
// // import 'dart:developer';
// // import 'dart:io';
// //
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// // import 'package:get/get.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:talkangels/common/app_button.dart';
// // import 'package:talkangels/const/app_assets.dart';
// // import 'package:talkangels/const/app_color.dart';
// // import 'package:talkangels/const/extentions.dart';
// // import 'package:talkangels/ui/angels/constant/app_string.dart';
// // import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
// // // import 'package:webview_flutter/webview_flutter.dart';
// // // import 'package:webview_flutter_android/webview_flutter_android.dart';
// // // import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// //
// // class PaymentScreen extends StatefulWidget {
// //   const PaymentScreen({super.key});
// //
// //   @override
// //   State<PaymentScreen> createState() => _PaymentScreenState();
// // }
// //
// // class _PaymentScreenState extends State<PaymentScreen> {
// //   String angelId = Get.arguments["angel_id"];
// //   String userNumber = Get.arguments["user_number"];
// //   String userName = Get.arguments["user_name"];
// //   String amount = Get.arguments["amount"];
// //   String token = Get.arguments["token"];
// //   HomeScreenController homeController = Get.put(HomeScreenController());
// //
// //   // late final WebViewController _controller;
// //   bool isLoading = true;
// //   bool selectedPage = false;
// //
// //   // @override
// //   // void initState() {
// //   //   super.initState();
// //   //   log("***************${"https://www.talkangels.com/payment/$angelId/$userNumber/$userName/$amount/$token"}");
// //   //   late final PlatformWebViewControllerCreationParams params;
// //   //   if (WebViewPlatform.instance is WebKitWebViewPlatform) {
// //   //     params = WebKitWebViewControllerCreationParams(
// //   //       allowsInlineMediaPlayback: true,
// //   //       mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
// //   //     );
// //   //   } else {
// //   //     params = const PlatformWebViewControllerCreationParams();
// //   //   }
// //   //
// //   //   final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
// //   //
// //   //   controller
// //   //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //   //     ..setNavigationDelegate(
// //   //       NavigationDelegate(
// //   //         // onProgress: (int progress) {
// //   //         //   debugPrint('WebView is loading (progress : $progress%)');
// //   //         // },
// //   //         onPageStarted: (String url) {
// //   //           isLoading = true;
// //   //           setState(() {});
// //   //           debugPrint('Page started loading: $url');
// //   //         },
// //   //         onPageFinished: (String url) {
// //   //           isLoading = false;
// //   //           setState(() {});
// //   //           debugPrint('Page finished loading: $url');
// //   //         },
// //   //         // onNavigationRequest: (NavigationRequest request) {
// //   //         //   if (request.url.startsWith('https://www.youtube.com/')) {
// //   //         //     debugPrint('blocking navigation to ${request.url}');
// //   //         //     return NavigationDecision.prevent;
// //   //         //   }
// //   //         //   debugPrint('allowing navigation to ${request.url}');
// //   //         //   return NavigationDecision.navigate;
// //   //         // },
// //   //         onUrlChange: (UrlChange change) {
// //   //           debugPrint('url change to ${change.url}');
// //   //         },
// //   //         onHttpAuthRequest: (HttpAuthRequest request) {
// //   //           debugPrint('url change to $request');
// //   //           openDialog(request);
// //   //         },
// //   //       ),
// //   //     )
// //   //     ..addJavaScriptChannel(
// //   //       'Toaster',
// //   //       onMessageReceived: (JavaScriptMessage message) {
// //   //         ScaffoldMessenger.of(context).showSnackBar(
// //   //           SnackBar(content: Text(message.message)),
// //   //         );
// //   //       },
// //   //     )
// //   //     ..loadRequest(Uri.parse('https://www.talkangels.com/payment/$angelId/$userNumber/$userName/$amount/$token'));
// //   //
// //   //   if (kIsWeb || !Platform.isMacOS) {
// //   //     controller.setBackgroundColor(const Color(0x80000000));
// //   //   }
// //   //
// //   //   if (controller.platform is AndroidWebViewController) {
// //   //     AndroidWebViewController.enableDebugging(true);
// //   //     (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
// //   //   }
// //   //
// //   //   _controller = controller;
// //   // }
// //
// //   RxDouble progress = 0.0.obs;
// //   setProgress(int newProgress) {
// //     progress.value = newProgress / 100;
// //   }
// //
// //   InAppWebViewController? _inAppWebViewController;
// //
// //   setWebViewController(InAppWebViewController controller) {
// //     _inAppWebViewController = controller;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return PopScope(
// //       canPop: selectedPage,
// //       onPopInvoked: (didPop) async {
// //         if (selectedPage == false) {
// //           await homeController.userDetailsApi();
// //           Get.back();
// //           Get.back();
// //           // exitDialog();
// //           debugPrint(":::::selectedPage - PopScope:::::: $selectedPage");
// //         }
// //       },
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text(
// //             "Payment",
// //             style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'League Spartan'),
// //           ),
// //           centerTitle: true,
// //           backgroundColor: appBarColor,
// //           iconTheme: const IconThemeData(color: Colors.white),
// //           leading: const Icon(Icons.arrow_back, color: appBarColor),
// //           elevation: 0,
// //         ),
// //         body: Stack(
// //           children: [
// //             // WebViewWidget(controller: _controller),
// //             InAppWebView(
// //               onProgressChanged: (InAppWebViewController inAppWebViewController, int progress) {
// //                 setProgress(progress);
// //               },
// //               onWebViewCreated: (InAppWebViewController inAppWebViewController) {
// //                 setWebViewController(inAppWebViewController);
// //               },
// //               onCloseWindow: (InAppWebViewController controller) {
// //                 controller.closeAllMediaPresentations();
// //                 controller.clearFocus();
// //                 controller.clearHistory();
// //               },
// //               onPermissionRequest: (InAppWebViewController controller, PermissionRequest permissionRequest) async {
// //                 if (permissionRequest.resources.contains(PermissionResourceType.MICROPHONE)) {
// //                   final PermissionStatus permissionStatus = await Permission.microphone.request();
// //                   if (permissionStatus.isGranted) {
// //                     return PermissionResponse(
// //                       resources: permissionRequest.resources,
// //                       action: PermissionResponseAction.GRANT,
// //                     );
// //                   } else if (permissionStatus.isDenied) {
// //                     return PermissionResponse(
// //                       resources: permissionRequest.resources,
// //                       action: PermissionResponseAction.DENY,
// //                     );
// //                   }
// //                 }
// //                 return null;
// //               },
// //               initialUrlRequest: URLRequest(
// //                   url: WebUri.uri(Uri.parse('https://www.talkangels.com/payment/$angelId/$userNumber/$userName/$amount/$token'))),
// //             ),
// //             // if (isLoading)
// //             //   const Center(
// //             //     child: CircularProgressIndicator(),
// //             //   )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// exit Dialog - payment failed
// //   Future<void> exitDialog() {
// //     final h = MediaQuery.of(context).size.height;
// //     final w = MediaQuery.of(context).size.width;
// //     return showDialog(
// //       barrierDismissible: false,
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
// //         contentPadding: EdgeInsets.all(w * 0.05),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //         content: Container(
// //           padding: EdgeInsets.zero,
// //           height: h * 0.4,
// //           width: w * 0.9,
// //           child: Column(
// //             children: [
// //               const Spacer(),
// //               SizedBox(height: h * 0.13, width: w * 0.26, child: assetImage(AppAssets.sureAnimationAssets, fit: BoxFit.cover)),
// //               const Spacer(),
// //               AppString.areYouSure.regularLeagueSpartan(fontColor: blackColor, fontSize: 24, fontWeight: FontWeight.w800),
// //               SizedBox(height: h * 0.02),
// //               AppString.paymentExitDescription.regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15, textAlign: TextAlign.center),
// //               (h * 0.04).addHSpace(),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     flex: 1,
// //                     child: AppButton(
// //                       height: h * 0.06,
// //                       color: Colors.transparent,
// //                       onTap: () async {
// //                         selectedPage = true;
// //                         setState(() {});
// //                         Get.back();
// //                         Get.back();
// //                       },
// //                       child: AppString.yesImSure.regularLeagueSpartan(fontColor: blackColor, fontSize: 14, fontWeight: FontWeight.w700),
// //                     ),
// //                   ),
// //                   (w * 0.02).addWSpace(),
// //                   Expanded(
// //                     flex: 1,
// //                     child: AppButton(
// //                       height: h * 0.06,
// //                       border: Border.all(color: redFontColor),
// //                       color: redFontColor,
// //                       onTap: () {
// //                         Get.back();
// //                       },
// //                       child: AppString.noGoBack.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w700),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   ///
// //   ///
// //   // Future<void> openDialog(HttpAuthRequest httpRequest) async {
// //   //   final TextEditingController usernameTextController = TextEditingController();
// //   //   final TextEditingController passwordTextController = TextEditingController();
// //   //
// //   //   return showDialog(
// //   //     context: context,
// //   //     barrierDismissible: false,
// //   //     builder: (BuildContext context) {
// //   //       return AlertDialog(
// //   //         title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
// //   //         content: SingleChildScrollView(
// //   //           child: Column(
// //   //             mainAxisSize: MainAxisSize.min,
// //   //             children: <Widget>[
// //   //               TextField(
// //   //                 decoration: const InputDecoration(labelText: 'Username'),
// //   //                 autofocus: true,
// //   //                 controller: usernameTextController,
// //   //               ),
// //   //               TextField(
// //   //                 decoration: const InputDecoration(labelText: 'Password'),
// //   //                 controller: passwordTextController,
// //   //               ),
// //   //             ],
// //   //           ),
// //   //         ),
// //   //         actions: <Widget>[
// //   //           TextButton(
// //   //             onPressed: () {
// //   //               httpRequest.onCancel();
// //   //               Navigator.of(context).pop();
// //   //             },
// //   //             child: const Text('Cancel'),
// //   //           ),
// //   //           TextButton(
// //   //             onPressed: () {
// //   //               httpRequest.onProceed(
// //   //                 WebViewCredential(
// //   //                   user: usernameTextController.text,
// //   //                   password: passwordTextController.text,
// //   //                 ),
// //   //               );
// //   //               Navigator.of(context).pop();
// //   //             },
// //   //             child: const Text('Authenticate'),
// //   //           ),
// //   //         ],
// //   //       );
// //   //     },
// //   //   );
// //   // }
// // }
