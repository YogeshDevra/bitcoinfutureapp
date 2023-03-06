// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'futCryptoSheet.dart';
import 'futDrift.dart';
import 'futLocate/futLang.dart';
import 'futPortSheet.dart';
import 'futSheetMain.dart';
import 'futTrans.dart';
import 'topFutSheet.dart';



class FutMap extends StatelessWidget {
  const FutMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 150.0),
      child: Drawer(
        child: Container(
          color: const Color(0xff151c19),
          child: ListView(
            // Remove padding
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/image/logo_hor.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Color(0xffc30508),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FutSheetMain()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/homepage.png"),
                        const Spacer(),
                        Text(FutLang.of(context).translate('home'),textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TopFutSheet()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/up-arrow.png"),
                        const Spacer(),
                        Text(FutLang.of(context).translate('top_coin'),textAlign: TextAlign.start,
                          softWrap: true,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        const Spacer() ,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FutPortSheet()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Shape.png"),
                        const Spacer(),
                        Text(FutLang.of(context).translate('portfolio'),textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FutCryptoSheet()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Icon.png"),
                        const Spacer(),
                        Text(FutLang.of(context).translate('coins'),textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FutDrift()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Rise.png"),
                        const Spacer(),
                        Text(FutLang.of(context).translate('trends'),textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FutTrans()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.translate_rounded,
                          color: Color(0xff6D778B),
                          size: 25,
                        ),
                        const Spacer(),
                        Text(FutLang.of(context).translate('trans'),textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}