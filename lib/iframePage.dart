// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use, must_be_immutable


import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'analFutBit.dart';

class IframeHomePage extends StatefulWidget {
  IframeHomePage({Key? key}) : super(key: key);

  @override
  _IframeHomePageState createState() => _IframeHomePageState();
}

class _IframeHomePageState extends State<IframeHomePage> {
  late WebViewController controller;
  bool isLoading = true ;
  String? iFrameUrl;

  @override
  void initState() {
    AnalFutBit.futCurScnBit(AnalFutBit.Fut_Frm_Bit_Scn, "Bitcoin Future Iframe Page");
    setState(() {
      isLoading = true ;
    });
    super.initState();
    fetchFirebaseValue();
  }

  fetchFirebaseValue() async{
    final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;
    try{
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      iFrameUrl = remoteConfig.getString('bitFuture_form_url_iOS').trim();
      // blockUrl = remoteConfig.getString('bitcoin_code_block_url_sst').trim();
    }catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith("www")) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(iFrameUrl!));
    setState(() {
      isLoading = false ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff171616),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 3));
          },
          child: isLoading ?Center(child: CircularProgressIndicator(),):
          WebViewWidget(
              gestureRecognizers: Set()
                ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()
                )),
              controller: controller),));
  }
}
