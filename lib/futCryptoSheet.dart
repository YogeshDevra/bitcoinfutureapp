// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitMod/futCrypt.dart';
import 'fitMod/futSheetPort.dart';
import 'futLocate/futLang.dart';
import 'futMap.dart';

class FutCryptoSheet extends StatefulWidget {
  const FutCryptoSheet({Key? key}) : super(key: key);

  @override
  _FutCryptoSheet createState() => _FutCryptoSheet();
}

class _FutCryptoSheet extends State<FutCryptoSheet>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List<FutCrypto> bitcoinList = [];
  SharedPreferences? sharedPreferences;
  num _size = 0;
  double totalValuesOfPortfolio = 0.0;
  String? futLogo;



  @override
  void initState() {
    fetchRemoteValue();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

      futLogo = remoteConfig.getString('bitFuture_image_url_android').trim();


      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    callBitcoinApi();
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
        title: Text(FutLang.of(context).translate('coins')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff111622)),
        child: Column(
          children: <Widget>[
            Expanded(
                child:Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 0, bottom: 0, top: 0),
                  child:
                  LazyLoadScrollView(
                    isLoading: isLoading,
                    onEndOfPage: () => callBitcoinApi(),
                    child: bitcoinList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        :ListView.builder(
                        itemCount: bitcoinList.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Card(
                            elevation: 1,
                            color: const Color(0xff1a202e),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                height: 80,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        callCurrencyDetails(bitcoinList[i].name);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(left:10),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('${bitcoinList[i].name}',textAlign: TextAlign.start,
                                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                                  ),
                                                  Text('\$${double.parse(bitcoinList[i].rate!.toStringAsFixed(2))}',
                                                      style: const TextStyle(fontSize: 18,color: Color(0xff656f82))
                                                  ),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        callCurrencyDetails(bitcoinList[i].name);
                                      },
                                      child: SizedBox(
                                        width:MediaQuery.of(context).size.width/4,
                                        height: 40,
                                        child: charts.LineChart(
                                          _createSampleData(bitcoinList[i].historyRate, double.parse(bitcoinList[i].diffRate!)),
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
                                    const Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          callCurrencyDetails(bitcoinList[i].name);
                                        },
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(double.parse(bitcoinList[i].diffRate!) < 0 ? '-' : '+',
                                                    style: TextStyle(fontSize: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)),
                                                Icon(Icons.attach_money, size: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green),
                                                Text(double.parse(bitcoinList[i].diffRate!) < 0 ? double.parse(bitcoinList[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)
                                                    : double.parse(bitcoinList[i].diffRate!).toStringAsFixed(2),
                                                    style: TextStyle(fontSize: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)),
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
            ),
          ],
        ),
      ),
    );
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

  Future<void> callBitcoinApi() async {
    var uri = '$futLogo/Bitcoin/resources/getBitcoinList?size=$_size';
    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      setState(() {
        bitcoinList.addAll(data['data']
            .map<FutCrypto>((json) => FutCrypto.fromJson(json))
            .toList());
        isLoading = false;
        _size = _size + data['data'].length;
      });
    } else {
      setState(() {});
    }
  }

  getCurrentRateDiff(FutSheetPort items, List<FutCrypto> bitcoinList) {
    FutCrypto j = bitcoinList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! - items.rateDuringAdding;
    return newRateDiff;
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

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
