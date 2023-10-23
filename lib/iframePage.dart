// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use, must_be_immutable


import 'package:bitcoinfutureapp/api_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Navbar.dart';
import 'analFutBit.dart';
import 'localization/app_localization.dart';

class IframeHomePage extends StatefulWidget {
  IframeHomePage({Key? key}) : super(key: key);

  @override
  _IframeHomePageState createState() => _IframeHomePageState();
}

class _IframeHomePageState extends State<IframeHomePage> {
  late WebViewController controller;
  bool isLoading = false ;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    AnalFutBit.futCurScnBit(AnalFutBit.Fut_Frm_Bit_Scn, "Bitcoin Future Iframe Page");
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
            if (request.url.startsWith(api_config.blockUrl)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(api_config.iFrameUrl));
    setState(() {
      isLoading = false ;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff111622)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const NavBar()),);
                    }, // Image tapped
                    child: const Icon(Icons.menu_rounded, color: Colors.grey,)
                ),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: const Color(0xff111622),
          centerTitle: true,
          title: Text(AppLocalizations.of(context).translate('dashboard')),
          titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 3));
          },
          child: isLoading ? Center(child: CircularProgressIndicator(),):
          WebViewWidget(
              gestureRecognizers: Set()
                ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()
                )),
              controller: controller),));
  }
}
