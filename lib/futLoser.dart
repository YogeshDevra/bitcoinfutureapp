// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitMod/futCrypt.dart';
import 'futLocate/futLang.dart';
import 'futMap.dart';
import 'topFutSheet.dart';

class LoserFut extends StatefulWidget {
  const LoserFut({Key? key}) : super(key: key);
  @override
  _LoserFut createState() => _LoserFut();
}

class _LoserFut extends State<LoserFut> with SingleTickerProviderStateMixin{

  bool isLoading = false;
  late List<FutCrypto> looserFut = [];
  SharedPreferences? sharedPreferences;
  String? coin;
  String? futLogo;

  @override
  void initState() {

    fetchRemoteValue();
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

      futLogo = remoteConfig.getString('bitFuture_image_url').trim();

      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    callGainerLooserBitcoinApi();
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
        title: Text(FutLang.of(context).translate('top_coin')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff111622)),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(FutLang.of(context).translate('top_lose'),textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TopFutSheet()));
                            }, // Image tapped
                            child: Container(
                              decoration: BoxDecoration(color: const Color(0xff2e3546),borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(FutLang.of(context).translate('gain'),textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: topLooser(),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topLooser(){
    var list = looserFut.where((element) => double.parse(element.diffRate!)< 0).toList();

    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int i) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(width: 2,color: Colors.red))),
                // color: Color(0xff1A202E),
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: FadeInImage(
                                  placeholder: const AssetImage('assets/image/cob.png'),
                                  image: NetworkImage("$futLogo/Bitcoin/resources/icons/${list[i].name!.toLowerCase()}.png"),
                                ),
                              )
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                child: Text(
                                  '${list[i].name}',
                                  style: GoogleFonts.poppins(
                                      textStyle:  const TextStyle(fontWeight: FontWeight.normal,fontSize: 24,color: Colors.white)
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          callCurrencyDetails(list[i].name);
                        },
                        child: Container(
                          width:MediaQuery.of(context).size.width/4,
                          height: 40,
                          child: charts.LineChart(
                            _createSampleData(list[i].historyRate, double.parse(list[i].diffRate!)),
                            layoutConfig: charts.LayoutConfig(
                                leftMarginSpec: charts.MarginSpec.fixedPixel(5),
                                topMarginSpec: charts.MarginSpec.fixedPixel(10),
                                rightMarginSpec: charts.MarginSpec.fixedPixel(5),
                                bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
                            defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true,),
                            animate: true,
                            domainAxis: const charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
                            primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    '\$${double.parse(list[i].rate!.toStringAsFixed(2))}',
                                    style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15,color: Colors.white,   fontWeight: FontWeight.normal,)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  double.parse(list[
                                  i]
                                      .diffRate!) <
                                      0
                                      ? Container(
                                    // color: Colors.red,
                                    child: const Icon(
                                      Icons
                                          .arrow_downward,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                  )
                                      : Container(
                                    // color: Colors.green,
                                    child: const Icon(
                                      Icons.arrow_upward_sharp,
                                      color: Colors.green,
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:2
                                  ),
                                  Text(
                                      list[i]
                                          .perRate!,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: double.parse(
                                              list[
                                              i]
                                                  .diffRate!) <
                                              0
                                              ? Colors.red
                                              : Colors.green)
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              callCurrencyDetails(looserFut[i].name);
            },
          );
        });
  }

  List<charts.Series<LinearSales, int>> _createSampleData(
      historyRate, diffRate) {
    List<LinearSales> listData = [];
    for (int i = 0; i < historyRate.length; i++) {
      double rate = historyRate[i]['rate'];
      listData.add(LinearSales(i, rate));
    }

    return [
      charts.Series<LinearSales, int>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => diffRate < 0
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        // areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.count,
        measureFn: (LinearSales sales, _) => sales.rate,
        data: listData,
      ),
    ];
  }

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  _saveProfileData(String name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("currencyName", name);
      sharedPreferences!.setString("title", FutLang.of(context).translate('trends'));
      sharedPreferences!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, '/trendPage', (r) => false);
  }

  Future<void> callGainerLooserBitcoinApi() async {

    var uri = '$futLogo/Bitcoin/resources/getBitcoinListLoser?size=0';

    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (mounted) {
      if (data['error'] == false) {
        setState(() {
          looserFut.addAll(data['data']
              .map<FutCrypto>((json) => FutCrypto.fromJson(json))
              .toList());
          isLoading = false;
          // _size = _size + data['data'].length;
        }
        );
      }

      else {
        //  _ackAlert(context);
        setState(() {});
      }
    }
  }

}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
