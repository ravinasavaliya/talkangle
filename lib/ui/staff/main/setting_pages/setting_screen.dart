// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:talkangels/const/extentions.dart';
// import 'package:talkangels/const/app_color.dart';
// import 'package:talkangels/ui/staff/constant/app_string.dart';
// import 'package:talkangels/common/app_app_bar.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//
// class SettingScreen extends StatefulWidget {
//   const SettingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }
//
// class _SettingScreenState extends State<SettingScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     final WebViewController controller =
//         WebViewController.fromPlatformCreationParams(params);
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             _isLoading = true;
//             setState(() {});
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             _isLoading = false;
//             setState(() {});
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint('url change to ${change.url}');
//           },
//           onHttpAuthRequest: (HttpAuthRequest request) {
//             debugPrint('url change to $request');
//             openDialog(request);
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadRequest(Uri.parse('https://www.talkangels.com/'));
//
//     // setBackgroundColor is not currently supported on macOS.
//     if (kIsWeb || !Platform.isMacOS) {
//       controller.setBackgroundColor(const Color(0x80000000));
//     }
//
//     // #docregion platform_features
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//     // #enddocregion platform_features
//
//     _controller = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppAppBar(
//         backGroundColor: appBarColor,
//         titleText: AppString.setting,
//         titleFontWeight: FontWeight.w900,
//         titleSpacing: w * 0.06,
//         fontSize: 20,
//         bottom: PreferredSize(
//             preferredSize: const Size(300, 50), child: 1.0.appDivider()),
//       ),
//       body: Container(
//         height: h,
//         width: w,
//         decoration: const BoxDecoration(gradient: appGradient),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               WebViewWidget(controller: _controller),
//               if (_isLoading)
//                 const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> openDialog(HttpAuthRequest httpRequest) async {
//     final TextEditingController usernameTextController =
//         TextEditingController();
//     final TextEditingController passwordTextController =
//         TextEditingController();
//
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Username'),
//                   autofocus: true,
//                   controller: usernameTextController,
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   controller: passwordTextController,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             // Explicitly cancel the request on iOS as the OS does not emit new
//             // requests when a previous request is pending.
//             TextButton(
//               onPressed: () {
//                 httpRequest.onCancel();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 httpRequest.onProceed(
//                   WebViewCredential(
//                     user: usernameTextController.text,
//                     password: passwordTextController.text,
//                   ),
//                 );
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Authenticate'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

/// OLD CODE

import 'package:flutter/material.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/common/app_app_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //       print('appLifeCycleState inactive');
  //       break;
  //     case AppLifecycleState.resumed:
  //       NotificationService.getInitialMsg();
  //
  //       print('call screen--erdrfefe4rf-');
  //       print('appLifeCycleState resumed');
  //       break;
  //     case AppLifecycleState.paused:
  //       print('appLifeCycleState paused');
  //       break;
  //     case AppLifecycleState.hidden:
  //       print('appLifeCycleState suspending');
  //       break;
  //     case AppLifecycleState.detached:
  //       print('appLifeCycleState detached');
  //       break;
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        backGroundColor: appBarColor,
        titleText: AppString.setting,
        titleFontWeight: FontWeight.w900,
        titleSpacing: w * 0.06,
        fontSize: 20,
        bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: appGradient),
        child: SafeArea(
          child: Center(
            child: InkWell(
              onTap: () async {},
              child: const Text(
                "Coming soon!",
                style: TextStyle(color: whiteColor, fontSize: 25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
