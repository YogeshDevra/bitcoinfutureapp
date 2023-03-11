// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';
import 'package:bitcoinfutureapp/sqlFut.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'fitMod/futCrypt.dart';
import 'fitMod/futSheetPort.dart';
import 'futLocate/futLang.dart';
import 'futMap.dart';

class FutDrift extends StatefulWidget {
  const FutDrift({super.key});

  @override
  _FutDrift createState() => _FutDrift();

}

class _FutDrift extends State<FutDrift> {
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  List<FutCrypto> bitcoinDataList = [];
  double diffRate = 0;
  List<CartData> currencyData = [];
  String name = "";
  double coin = 0;
  String result = '';
  int graphButton = 1;
  String _type = 'Week';
  String? futLogo;
  bool isLoading = false;
  final _formKey2 = GlobalKey<FormState>();
  String? currencyNameForImage;
  double totalValuesOfPortfolio = 0.0;
  String? futSett;
  bool? futBool;
  SharedPreferences? sharedPreferences;
  late WebViewController controller;

  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = SQLFut.instance;
  List<FutSheetPort> items = [];

  @override
  void initState() {
    fetchRemoteValue();
    coinCountTextEditingController = TextEditingController();
    coinCountEditTextEditingController = TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      for (var note in notes) {
        items.add(FutSheetPort.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      }
      setState(() {});
    });
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

      futLogo = remoteConfig.getString('bitFuture_image_url_android').trim();
      futSett = remoteConfig.getString('bitFuture_form_url_android').trim();
      futBool = remoteConfig.getBool('bitFuture_disable_form_android');

      setState(() {

      });
    } catch (exception) {
    }
    callGraphApi();
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
        title: Text(FutLang.of(context).translate('trends')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image:AssetImage("futasst/futpic/trends.png"),fit: BoxFit.fill
              )
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:  Text('\$ $coin',textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(name,textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Text(diffRate < 0 ? '-' : "+", style: TextStyle(fontSize: 16, color: diffRate < 0 ? Colors.red : Colors.green)),
                              Icon(Icons.attach_money, size: 16, color: diffRate < 0 ? Colors.red : Colors.green),
                              Text(result, style: TextStyle(fontSize: 16, color: diffRate < 0 ? Colors.red : Colors.green)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  ButtonTheme(
                    minWidth: 50.0, height: 40.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(graphButton == 1 ? const Color(0xff111622):const Color(0xff2e3546)),
                          backgroundColor: MaterialStateProperty.all<Color>(graphButton == 1 ? const Color(0xff2e3546) : const Color(0xff111622),),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                // side: BorderSide(color: Color(0xfff4f727))
                              )
                          )
                      ),
                      onPressed: () {
                        setState(() {
                          graphButton = 1;
                          _type = "Week";
                          callGraphApi();
                        });
                      },
                      child: const Text("Week" , style: TextStyle(fontSize: 15)
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 50.0, height: 40.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(graphButton == 2 ? const Color(0xff111622):const Color(0xff2e3546)),
                          backgroundColor: MaterialStateProperty.all<Color>(graphButton == 2 ? const Color(0xff2e3546) : const Color(0xff111622),),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                // side: BorderSide(color: Color(0xfff4f727))
                              )
                          )
                      ),
                      onPressed: () {
                        setState(() {
                          graphButton = 2;
                          _type = "Month";
                          callGraphApi();
                        });
                      },
                      child: const Text("Month" , style: TextStyle(fontSize: 15)
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 50.0, height: 40.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? const Color(0xff111622):const Color(0xff2e3546)),
                          backgroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? const Color(0xff2e3546) : const Color(0xff111622),),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                // side: BorderSide(color: Color(0xfff4f727))
                              )
                          )
                      ),
                      onPressed: () {
                        setState(() {
                          graphButton = 3;
                          _type = "Year";
                          callGraphApi();
                        });
                      },
                      child: const Text("Year" , style: TextStyle(fontSize: 15)
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child:Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(),
                        child:  Row(children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width ,
                              height: MediaQuery.of(context).size.height / 2.5,
                              //   height :MediaQuery.of(context).size.height,
                              //     width: MediaQuery.of(context).size.width,
                              child: SfCartesianChart(
                                isTransposed: false,
                                plotAreaBorderWidth: 0,
                                enableAxisAnimation: true,
                                enableSideBySideSeriesPlacement: true,
                                //  plotAreaBackgroundColor:Colors.blue.shade100 ,
                                series: <ChartSeries>[
                                  // Renders spline chart
                                  ColumnSeries<CartData, double>(
                                    dataSource: currencyData,
                                    xValueMapper: (CartData data, _) => data.date,
                                    yValueMapper: (CartData data, _) => data.rate,
                                    pointColorMapper:(CartData data, _) => data.color,

                                  ),
                                ],
                                primaryXAxis: NumericAxis(

                                  isVisible: true,
                                  borderColor: const Color(0xff3e475a),

                                ),
                                primaryYAxis: NumericAxis(
                                    isVisible: true,
                                    borderColor: const Color(0xff3e475a)
                                  // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                ),
                              )
                          )
                        ],),
                      ),

                    ],
                  ),
                ),

              ),
              SizedBox(
                width:300,
                child: TextButton(
                  onPressed: (){
                    showPortfolioDialog(name,coin);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff0000)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(FutLang.of(context).translate('add_coins'),
                      style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              const SizedBox(height: 25,),

            ],
          ),
        ),
      ),
    );
  }


  Future<void> callGraphApi() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await _sprefs;
    var currencyName = prefs.getString("currencyName") ?? 'BTC';
    currencyNameForImage = currencyName;
    var uri = '$futLogo/Bitcoin/resources/getBitcoinGraph?type=$_type&name=$currencyName';

    var response = await get(Uri.parse(uri));
    //  print(response.body);
    final data = json.decode(response.body) as Map;
    //print(data);
    if(data['error'] == false){
      setState(() {
        bitcoinDataList = data['data'].map<FutCrypto>((json) =>
            FutCrypto.fromJson(json)).toList();
        double count = 0;
        var color = const Color(0xffF13434),

            diffRate = double.parse(data['diffRate']);
        if(diffRate < 0) {
          result = data['diffRate'].replaceAll("-", "");
        } else {
          result = data['diffRate'];
        }

        currencyData = [];
        for (var element in bitcoinDataList) {
          currencyData.add(CartData(count, element.rate!,color));
          name = element.name!;
          String step2 = element.rate!.toStringAsFixed(2);
          double step3 = double.parse(step2);
          coin = step3;
          count = count+1;
          color = count % 2 == 0 ?const Color(0xffF13434) : const Color(0xff00B84A);
        }
        //  print(currencyData.length);
        isLoading = false;
      }
      );
    }
    else {
      //  _ackAlert(context);
    }
  }

  Future<void> showPortfolioDialog(String name, double coin) async {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Color(0xff1a202e)
              ),
              child: ListView(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            ),
                            const Spacer(),
                            Text(FutLang.of(context).translate('add_coins'),
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(color: const Color(0xff2e3546),
                            border: Border.all(color: const Color(0xffc30508)
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              decoration: const BoxDecoration(border: Border(top: BorderSide(width: 2,color: Colors.red))),
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
                                                placeholder: const AssetImage('futasst/futpic/cob.png'),
                                                image: NetworkImage("$futLogo/Bitcoin/resources/icons/${name!.toLowerCase()}.png"),
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
                                              child: Text(name,
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
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '\$${double.parse(coin!.toStringAsFixed(2))}',
                                                  style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15,color: Colors.white,   fontWeight: FontWeight.normal,)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                diffRate < 0
                                                    ? Container(
                                                  child: const Icon(
                                                    Icons
                                                        .arrow_downward,
                                                    color: Colors.red,
                                                    size: 15,
                                                  ),
                                                )
                                                    : Container(
                                                  child: const Icon(
                                                    Icons.arrow_upward_sharp,
                                                    color: Colors.green,
                                                    size: 15,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width:2
                                                ),
                                                Text(diffRate.toStringAsFixed(2),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.normal,
                                                        color: diffRate < 0
                                                            ? Colors.red : Colors.green)
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
                          // Row(
                          //   children: <Widget>[
                          //     Padding(
                          //       padding: const EdgeInsets.all(10),
                          //       child: FadeInImage(
                          //         height: 70,
                          //         placeholder: const AssetImage('futasst/futpic/cob.png'),
                          //         image: NetworkImage(
                          //             "$URL/Bitcoin/resources/icons/${name!.toLowerCase()}.png"),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(10),
                          //       child: Column(
                          //         children: <Widget>[
                          //           Padding(
                          //             padding: const EdgeInsets.all(10),
                          //             child: Text(name,
                          //               style: const TextStyle(fontSize: 15, color: Colors.white),
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.all(10),
                          //             child: Align(
                          //               alignment: Alignment.centerLeft,
                          //               child: Row(
                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                          //                 mainAxisAlignment:  MainAxisAlignment.center,
                          //                 children: <Widget>[
                          //                   Text(diffRate < 0 ? '-' : "+", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: diffRate < 0 ? Colors.red : Colors.green)),
                          //                   Icon(Icons.attach_money, size: 20, color: diffRate < 0 ? Colors.red : Colors.green),
                          //                   Text(result, textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: diffRate < 0 ? Colors.red : Colors.green)),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.all(10),
                          //             child: Text('\$$coin',
                          //                 style: const TextStyle(fontSize: 25,
                          //                     fontWeight:FontWeight.bold,color:Colors.white)
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Form(
                          key: _formKey2,
                          child: TextFormField(
                            controller: coinCountTextEditingController,
                            style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color:Colors.white),textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (val) {
                              if (coinCountTextEditingController!.text == "" || int.parse(coinCountTextEditingController!.value.text) <= 0) {
                                return FutLang.of(context).translate('invalid_coins');
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 200,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(
                        width:300,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff0000)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(FutLang.of(context).translate('add_coins'),
                              textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                  fontSize: 15),),
                          ),
                          // color: Colors.blueAccent,
                          onPressed: (){
                            _addSaveCoinsToLocalStorage(name,coin);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  _addSaveCoinsToLocalStorage(String name,double rate) async {
    if (_formKey2.currentState!.validate()) {
      if (items.length > 0) {
        FutSheetPort? bitcoinLocal =
        items.firstWhereOrNull(
                (element) => element.name == name);

        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            SQLFut.columnName: name,
            SQLFut.columnRateDuringAdding: rate,
            SQLFut.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) +
                bitcoinLocal.numberOfCoins,
            SQLFut.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!) +
                bitcoinLocal.totalValue,
          };
          final id = await dbHelper.update(row);
        } else {
          Map<String, dynamic> row = {
            SQLFut.columnName: name,
            SQLFut.columnRateDuringAdding: rate,
            SQLFut.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text),
            SQLFut.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!),
          };
          final id = await dbHelper.insert(row);
        }
      } else {
        Map<String, dynamic> row = {
          SQLFut.columnName: name,
          SQLFut.columnRateDuringAdding: rate,
          SQLFut.columnCoinsQuantity:
          double.parse(coinCountTextEditingController!.text),
          SQLFut.columnTotalValue:
          double.parse(coinCountTextEditingController!.value.text) *
              (rate!),
        };
        final id = await dbHelper.insert(row);
      }

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", name!);
        sharedPreferences!.setString("title", FutLang.of(context).translate('portfolio'));
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/portPage', (r) => false);
    } else {}
  }
}


class CartData {
  final double date;
  final double rate;
  final Color color;

  CartData(this.date, this.rate,this.color);
}