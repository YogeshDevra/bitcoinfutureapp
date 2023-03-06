// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitMod/futNative.dart';
import 'futLocate/futLang.dart';
import 'futLocate/nativeFut.dart';
import 'futMap.dart';


class FutTrans extends StatefulWidget {
  const FutTrans({super.key});

  @override
  _FutTrans createState() => _FutTrans();
}

class _FutTrans extends State<FutTrans> {
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;
  final PageStorageBucket bucket = PageStorageBucket();
  String? languageCodeSaved;

  List<FutNative> lang = [
    FutNative(futLangQR: "en", futLangTit: "English"),
    FutNative(futLangQR: "it", futLangTit: "Italian"),
    FutNative(futLangQR: "de", futLangTit: "German"),
    FutNative(futLangQR: "sv", futLangTit: "Swedish"),
    FutNative(futLangQR: "fr", futLangTit: "French"),
    FutNative(futLangQR: "nb", futLangTit: "Norwegian"),
    FutNative(futLangQR: "es", futLangTit: "Spanish"),
    FutNative(futLangQR: "nl", futLangTit: "Dutch"),
    FutNative(futLangQR: "fi", futLangTit: "Finnish"),
    FutNative(futLangQR: "ru", futLangTit: "Russian"),
    FutNative(futLangQR: "pt", futLangTit: "Portuguese"),
    FutNative(futLangQR: "ar", futLangTit: "Arabic"),
  ];

  @override
  void initState() {
    getSharedPrefData();

    super.initState();
  }

  Future<void> getSharedPrefData() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      languageCodeSaved = prefs.getString('language_code') ?? "en";
      _saveProfileData();
    });
  }

  _saveProfileData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<NativeFut>(context);
    return Scaffold(
      backgroundColor: const Color(0xff111622),
      appBar: AppBar(
        leading:Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: const Color(0xff111622)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FutMap()),
                    );
                  }, // Image tapped
                  child: const Icon(Icons.menu_rounded,color: Colors.grey,)
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff111622),
        centerTitle: true,
        title: Text(FutLang.of(context).translate('select')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: lang.length,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  children: <Widget>[
                    InkWell(
                        onTap: () async {
                          appLanguage.changeLanguage(Locale(lang[i].futLangQR!));
                          await getSharedPrefData();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left:25.0,right: 25.0,top:15,bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(lang[i].futLangTit!,style: const TextStyle(color: Colors.white, fontSize: 22),),
                              languageCodeSaved ==
                                  lang[i].futLangQR
                                  ? const Icon(
                                Icons
                                    .radio_button_checked,
                                color: Color(0xffff0000),
                              )
                                  : const Icon(
                                Icons
                                    .radio_button_unchecked,
                                color: Color(0xffff0000),
                              ),
                            ],
                          ),
                        )),
                    // Divider()
                  ],
                );
              }
          )
      ),
    );
  }
}