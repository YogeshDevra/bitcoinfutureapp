// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'coins_page.dart';
import 'dashboard_home.dart';
import 'localization/app_localization.dart';
import 'portfolio_page.dart';
import 'top_coin.dart';
import 'translation.dart';
import 'trendsPage.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

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
            ],
          ),
        ),
      ),
    );
  }
}