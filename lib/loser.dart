// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:bitcoinfutureapp/api_config.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Navbar.dart';
import 'localization/app_localization.dart';
import 'models/Bitcoin.dart';
import 'top_coin.dart';

class TopLoser extends StatefulWidget {
  const TopLoser({Key? key}) : super(key: key);
  @override
  _TopLoser createState() => _TopLoser();
}

class _TopLoser extends State<TopLoser> with SingleTickerProviderStateMixin{
  bool isLoading = false;
  late List<Bitcoin> topLooserAndGainerList = [];
  SharedPreferences? sharedPreferences;
  String? coin;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    callGainerLooserBitcoinApi();
    super.initState();
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NavBar()),);
                  }, // Image tapped
                  child: const Icon(Icons.menu_rounded,color: Colors.grey,)
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff111622),
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('top_coin')),
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
                          child: Text(AppLocalizations.of(context).translate('top_lose'),textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TopGainer()));
                            }, // Image tapped
                            child: Container(
                              decoration: BoxDecoration(color: const Color(0xff2e3546),borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(AppLocalizations.of(context).translate('gain'),textAlign: TextAlign.center,
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
                          child: isLoading ? Center(child: CircularProgressIndicator())
                              :topLooserAndGainerList.isEmpty
                              ? Center(child: Image.asset("assets/image/no_data_found.png"))
                              : topLooser(),
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
    var list = topLooserAndGainerList.where((element) => double.parse(element.diffRate!) < 0).toList();

    return list.isNotEmpty
     ? ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int i) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(5),
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
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: FadeInImage(
                                  placeholder: const AssetImage('assets/image/cob.png'),
                                  image: NetworkImage("https://assets.coinlayer.com/icons/${list[i].name!.toUpperCase()}.png"),
                                ),
                              )
                          ),
                          const SizedBox(
                            width: 5,
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
                                      textStyle:  const TextStyle(fontWeight: FontWeight.normal,fontSize: 20,color: Colors.white)
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
              callCurrencyDetails(topLooserAndGainerList[i].name);
            },
          );
        })
     : Center(
      child: Text(AppLocalizations.of(context).translate('data_found'),style: TextStyle(color: Colors.white,fontFamily: 'Manrope',fontSize: 24),),
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

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  _saveProfileData(String name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("currencyName", name);
      sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
      sharedPreferences!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, '/trendPage', (r) => false);
  }

  Future<void> callGainerLooserBitcoinApi() async {

    var uri = '${api_config.URL}/Bitcoin/resources/getBitcoinListLoser?size=0';
    if (await api_config.internetConnection()) {
      try {
        //  print(uri);
        var response = await get(Uri.parse(uri)).timeout(const Duration(seconds: 60));
        if(response.statusCode == 200) {
        final data = json.decode(response.body) as Map;
        //  print(data);
        if (mounted) {
          if (data['error'] == false) {
            setState(() {
              topLooserAndGainerList.addAll(data['data']
                  .map<Bitcoin>((json) => Bitcoin.fromJson(json))
                  .toList());
              isLoading = false;
              // _size = _size + data['data'].length;
            }
            );
          } else {
            api_config.toastMessage(message: 'Under Maintenance');
            setState(() {
              isLoading = false;
            });
          }
        }
        } else {
      api_config.toastMessage(message: 'Under Maintenance');
      setState(() {
        isLoading = false;
      });
    }
      } on TimeoutException catch(e) {
        setState(() {
          isLoading = false;
        });
        print(e);
      }catch(e){
        // toastMessage(message: 'An error occurred while fetching data.');
        setState(() {
          isLoading = false;
        });
      }
    }else {
      api_config.toastMessage(message: 'No Internet Connection');
      setState(() {
        isLoading = false;
      });
    }
    api_config.internetConnection();
  }
}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
