// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'futDrift.dart';
import 'futLocate/futLang.dart';
import 'futMap.dart';

class FutSheetMain extends StatefulWidget {
  const FutSheetMain({Key? key}) : super(key: key);

  @override
  _FutSheetMain createState() => _FutSheetMain();
}

class _FutSheetMain extends State<FutSheetMain> {
  ScrollController? _controllerList;


  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  String? futSett;
  bool? futBool;
  late WebViewController controller;


  @override
  void initState() {

    fetchRemoteValue();
    _controllerList = ScrollController();
    super.initState();

  }


  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();


      futSett = remoteConfig.getString('bitFuture_form_url_android').trim();
      futBool = remoteConfig.getBool('bitFuture_disable_form_android');


      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
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
            if (request.url.startsWith(futSett!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(futSett!));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: const Color(0xff111622)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FutMap()),);
                  }, // Image tapped
                  child: const Icon(Icons.menu_rounded,color: Colors.grey,)
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff111622),
        centerTitle: true,
        title: Text(FutLang.of(context).translate('home')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body:ListView(
        controller:_controllerList,
        children: <Widget>[
          Container(
            child: Column(
                children: <Widget>[
                  Container(
                    height: 600,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/image/back.png"),fit: BoxFit.fill
                        )
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset("assets/image/logo_hor.png"),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen1'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen2'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen3'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen4'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Color(0xff07090e)),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen5'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 27),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen6'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xff9c9d9f),fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset("assets/image/start.png"),
                        ),
                        if(futBool == true)
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            height: 520,
                            child : WebViewWidget(controller: controller),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        if(futBool == true)
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(FutLang.of(context).translate('homesen7'),textAlign: TextAlign.left,
                                      style: const TextStyle(color: Color(0xffef443b),fontSize: 25,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    decoration: BoxDecoration(color: const Color(0xff160e33),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset("assets/image/one.png"),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(FutLang.of(context).translate('homesen8'),
                                              style: const TextStyle(color: Color(0xffef443b),fontSize: 20,fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    decoration: BoxDecoration(color: const Color(0xff160e33),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset("assets/image/two.png"),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(FutLang.of(context).translate('homesen9'),
                                              style: const TextStyle(color: Color(0xffef443b),fontSize: 20,fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    decoration: BoxDecoration(color: const Color(0xff160e33),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset("assets/image/three.png"),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(FutLang.of(context).translate('homesen10'),
                                              style: const TextStyle(color: Color(0xffef443b),fontSize: 20,fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    decoration: BoxDecoration(color: const Color(0xff160e33),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset("assets/image/four.png"),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(FutLang.of(context).translate('homesen11'),
                                              style: const TextStyle(color: Color(0xffef443b),fontSize: 20,fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen12'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen13'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xff9c9d9f),fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(31),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: <Widget>[
                                Image.asset("assets/image/bit.png",fit: BoxFit.cover,),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(FutLang.of(context).translate('homesen14'),textAlign: TextAlign.left,
                                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(FutLang.of(context).translate('homesen15'),textAlign: TextAlign.left,
                                    style: const TextStyle(color: Color(0xff736e85),fontWeight: FontWeight.bold,fontSize: 15),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text("\$22,907",textAlign: TextAlign.left,
                                        style: TextStyle(color: Color(0xffef443b),fontSize: 30,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const FutDrift()),
                                          );
                                        }, // Image tapped
                                        child: Container(
                                          decoration: BoxDecoration(color: const Color(0xffef443b),
                                              borderRadius: BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Text(FutLang.of(context).translate('homesen16'),textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(31),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: <Widget>[
                                Image.asset("assets/image/eth.png",fit: BoxFit.fill,),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(FutLang.of(context).translate('homesen17'),textAlign: TextAlign.left,
                                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(FutLang.of(context).translate('homesen18'),textAlign: TextAlign.left,
                                    style: const TextStyle(color: Color(0xff736e85),fontWeight: FontWeight.bold,fontSize: 15),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text("\$1,649",textAlign: TextAlign.left,
                                        style: TextStyle(color: Color(0xffef443b),fontSize: 30,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const FutDrift()),
                                          );
                                        }, // Image tapped
                                        child: Container(
                                          decoration: BoxDecoration(color: const Color(0xffef443b),
                                              borderRadius: BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Text(FutLang.of(context).translate('homesen16'),textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(31),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              children: <Widget>[
                                Image.asset("assets/image/tether.png",fit: BoxFit.fill,),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(FutLang.of(context).translate('homesen19'),textAlign: TextAlign.left,
                                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(FutLang.of(context).translate('homesen20'),textAlign: TextAlign.left,
                                    style: const TextStyle(color: Color(0xff736e85),fontWeight: FontWeight.bold,fontSize: 15),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text("\$1.00",textAlign: TextAlign.left,
                                        style: TextStyle(color: Color(0xffef443b),fontSize: 30,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const FutDrift()),
                                          );
                                        }, // Image tapped
                                        child: Container(
                                          decoration: BoxDecoration(color: const Color(0xffef443b),borderRadius: BorderRadius.circular(30)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Text(FutLang.of(context).translate('homesen16'),textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(FutLang.of(context).translate('homesen21'),textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 35),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(FutLang.of(context).translate('homesen22'),textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xff9c9d9f),fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/image/cup.png"),
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(FutLang.of(context).translate('homesen23'),textAlign: TextAlign.left,
                                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 35),
                                  ),
                                ),
                              ),
                              // const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(FutLang.of(context).translate('homesen24'),
                              textAlign: TextAlign.left,style: const TextStyle(color: Color(0xff9c9d9f),fontSize: 20),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/image/port.png"),
                              ),
                              const SizedBox(width: 25,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(FutLang.of(context).translate('homesen25'),textAlign: TextAlign.left,
                                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 35),
                                  ),
                                ),
                              ),
                              // const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(FutLang.of(context).translate('homesen26'),
                              textAlign: TextAlign.left,style: const TextStyle(color: Color(0xff9c9d9f),fontSize: 20),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/image/Lock1.png"),
                              ),
                              const SizedBox(width: 25,),
                              Expanded(
                                child:  Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(FutLang.of(context).translate('homesen27'),textAlign: TextAlign.left,
                                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 35),
                                  ),
                                ),
                              ),
                              // const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(FutLang.of(context).translate('homesen28'),
                              textAlign: TextAlign.left,style: const TextStyle(color: Color(0xff9c9d9f),fontSize: 20),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/image/CTA.png"),fit: BoxFit.fill
                              )
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 60,bottom: 60,left: 10,right: 10),
                                child: Text(FutLang.of(context).translate('homesen29'),textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 60),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(FutLang.of(context).translate('homesen30'),textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(FutLang.of(context).translate('homesen31'),textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xff9c9d9f),fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(color: const Color(0xff160e33),border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset("assets/image/Vector.png"),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(FutLang.of(context).translate('homesen32'),textAlign: TextAlign.center,
                                      style: const TextStyle(color: Color(0xffa29fad),fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(FutLang.of(context).translate('homesen33'),textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(FutLang.of(context).translate('homesen34'),textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen35'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(FutLang.of(context).translate('homesen36'),textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xff9c9d9f),fontWeight: FontWeight.bold,fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset("assets/image/mid.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(FutLang.of(context).translate('homesen37'),textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(FutLang.of(context).translate('homesen38'),textAlign: TextAlign.left,
                              style: const TextStyle(color: Color(0xff9c9d9f),fontWeight: FontWeight.bold,fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset("assets/image/end.png"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(FutLang.of(context).translate('homesen39'),textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(FutLang.of(context).translate('homesen40'),textAlign: TextAlign.left,
                              style: const TextStyle(color: Color(0xff9c9d9f),fontWeight: FontWeight.bold,fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(color: const Color(0xff160e33),border: Border.all(color: Colors.red),borderRadius: BorderRadius.circular(45)),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(FutLang.of(context).translate('homesen41'),textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}

