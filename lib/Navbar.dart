// ignore_for_file: file_names

import 'dart:async';

import 'package:bitcoinfutureapp/api_config.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';

import 'coins_page.dart';
import 'dashboard_home.dart';
import 'iframePage.dart';
import 'localization/app_localization.dart';
import 'portfolio_page.dart';
import 'top_coin.dart';
import 'translation.dart';
import 'trendsPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  @override
  void initState() {
    super.initState();
    final newVersion = NewVersionPlus(
        iOSId: 'com.shs.bitcoinfutureapp',
        // iOSAppStoreCountry: 'GB'
    );
    Timer(const Duration(milliseconds: 800),() {
      versionUpdate(newVersion);
    });
  }

  void versionUpdate(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if(status!=null){
      if(status.canUpdate){
        newVersion.showUpdateDialog(
          context: context,
          versionStatus:status,
          dialogTitle:'Update Available!!!',
          dialogText:'Please Update Your App',
          allowDismissal: false,
        );
      }
    }
  }

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
              api_config.hideIframe == true
              ?SafeArea(
              child:Column(
                children : [
              Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  IframeHomePage()),
                    ); SizedBox(height:50);
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                            Icons.dashboard,color: Colors.grey,

                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Flexible(
                          child:Text(AppLocalizations.of(context).translate('dashboard'),textAlign: TextAlign.start,softWrap: true,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 28,
                        ),
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
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                    );
                  }, // Image tapped

                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/homepage.png"),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child:Text(AppLocalizations.of(context).translate('home'),textAlign: TextAlign.start,softWrap: true,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
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
                      MaterialPageRoute(builder: (context) => const TopGainer()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/up-arrow.png"),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child:Text(AppLocalizations.of(context).translate('top_coin'),textAlign: TextAlign.start,
                            softWrap: true,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
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
                      MaterialPageRoute(builder: (context) => const PortfolioPage()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Shape.png"),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: Text(AppLocalizations.of(context).translate('portfolio'),textAlign: TextAlign.start,softWrap: true,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
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
                      MaterialPageRoute(builder: (context) => const CoinsPage()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Icon.png"),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: Text(AppLocalizations.of(context).translate('coins'),textAlign: TextAlign.start,softWrap: true,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
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
                      MaterialPageRoute(builder: (context) => const TrendsPage()),
                    );
                  }, // Image tapped
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/image/Rise.png"),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: Text(AppLocalizations.of(context).translate('trends'),textAlign: TextAlign.start,softWrap: true,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
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
                      MaterialPageRoute(builder: (context) => const NativeReLocation()),
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
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: Text(AppLocalizations.of(context).translate('trans'),textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],),
              )
                  :SafeArea(
                child:Column(
                  children : [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DashboardPage()),
                          );
                        }, // Image tapped

                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/image/homepage.png"),
                              const SizedBox(
                                width: 30,
                              ),
                              Flexible(
                                child:Text(AppLocalizations.of(context).translate('home'),textAlign: TextAlign.start,softWrap: true,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
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
                            MaterialPageRoute(builder: (context) => const TopGainer()),
                          );
                        }, // Image tapped
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/image/up-arrow.png"),
                              const SizedBox(
                                width: 30,
                              ),
                              Flexible(
                                child:Text(AppLocalizations.of(context).translate('top_coin'),textAlign: TextAlign.start,
                                  softWrap: true,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
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
                            MaterialPageRoute(builder: (context) => const PortfolioPage()),
                          );
                        }, // Image tapped
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/image/Shape.png"),
                              const SizedBox(
                                width: 30,
                              ),
                              Flexible(
                                child: Text(AppLocalizations.of(context).translate('portfolio'),textAlign: TextAlign.start,softWrap: true,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
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
                            MaterialPageRoute(builder: (context) => const CoinsPage()),
                          );
                        }, // Image tapped
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/image/Icon.png"),
                              const SizedBox(
                                width: 30,
                              ),
                              Flexible(
                                child: Text(AppLocalizations.of(context).translate('coins'),textAlign: TextAlign.start,softWrap: true,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
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
                            MaterialPageRoute(builder: (context) => const TrendsPage()),
                          );
                        }, // Image tapped
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/image/Rise.png"),
                              const SizedBox(
                                width: 30,
                              ),
                              Flexible(
                                child: Text(AppLocalizations.of(context).translate('trends'),textAlign: TextAlign.start,softWrap: true,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
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
                            MaterialPageRoute(builder: (context) => const NativeReLocation()),
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
                              const SizedBox(
                                width: 30,
                              ),
                              Flexible(
                                child: Text(AppLocalizations.of(context).translate('trans'),textAlign: TextAlign.start,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],),
              )
            ]
          ),
        ),
      ),
    );
  }
}