// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Navbar.dart';
import 'analFutBit.dart';
import 'dashboard_helper.dart';
import 'localization/app_localization.dart';
import 'models/Bitcoin.dart';
import 'models/PortfolioBitcoin.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  _TrendsPageState createState() => _TrendsPageState();

}

class _TrendsPageState extends State<TrendsPage> {

  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  List<Bitcoin> bitcoinDataList = [];
  double diffRate = 0;
  List<CartData> currencyData = [];
  String name = "";
  double coin = 0;
  String result = '';
  int graphButton = 1;
  String _type = 'Week';
  String? URL;
  bool isLoading = false;
  final _formKey2 = GlobalKey<FormState>();
  String? currencyNameForImage;
  double totalValuesOfPortfolio = 0.0;
  SharedPreferences? sharedPreferences;

  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    fetchRemoteValue();
    AnalFutBit.futCurScnBit(AnalFutBit.Fut_Trd_Bit_Scn, "Bitcoin Future Trend Page");

    coinCountTextEditingController = TextEditingController();
    coinCountEditTextEditingController = TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      for (var note in notes) {
        items.add(PortfolioBitcoin.fromMap(note));
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

      URL = remoteConfig.getString('bitFuture_image_url').trim();

      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    callGraphApi();
  }

  @override
  Widget build(BuildContext context) {
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
                      MaterialPageRoute(builder: (context) => const NavBar()),
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
        title: Text(AppLocalizations.of(context).translate('trends')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: isLoading == true
          ?const Center(child: CircularProgressIndicator(color: Colors.blue,),)
          :SafeArea(
        child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image:AssetImage("assets/image/trends.png"),fit: BoxFit.fill
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
                              padding: const EdgeInsets.all(5),
                              child: Text(name,textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),
                              )
                            ),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: <Widget>[
                                    Text(diffRate < 0 ? '-' : "+", style: TextStyle(fontSize: 16, color: diffRate < 0 ? Colors.red : Colors.green)),
                                    Icon(Icons.attach_money, size: 16, color: diffRate < 0 ? Colors.red : Colors.green),
                                    Text('${double.parse(result).toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: diffRate < 0 ? Colors.red : Colors.green)),
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
                                      ColumnSeries<CartData, String>(
                                        dataSource: currencyData,
                                        xValueMapper: (CartData data, _) => data.date,
                                        yValueMapper: (CartData data, _) => data.rate,
                                        pointColorMapper:(CartData data, _) => data.color,

                                      ),
                                    ],
                                    primaryXAxis: CategoryAxis(
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
                        child: Text(AppLocalizations.of(context).translate('add_coins'),
                          style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                ],
              ),
            ),
      ),
    );
  }


  Future<void> callGraphApi() async {
    final SharedPreferences prefs = await _sprefs;
    var currencyName = prefs.getString("currencyName") ?? 'BTC';
    currencyNameForImage = currencyName;
    var uri = '$URL/Bitcoin/resources/getBitcoinGraph?type=$_type&name=$currencyName';

    var response = await get(Uri.parse(uri));
    //  print(response.body);
    final data = json.decode(response.body) as Map;
    //print(data);
    if(data['error'] == false){
      setState(() {
        bitcoinDataList = data['data'].map<Bitcoin>((json) =>
            Bitcoin.fromJson(json)).toList();
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
          currencyData.add(CartData(element.date!, element.rate!,color));
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
            appBar: AppBar(
              leading:Padding(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              elevation: 0,
              backgroundColor: const Color(0xff111622),
              centerTitle: true,
              title: Text(AppLocalizations.of(context).translate('add_coins')),
              titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
            body: Container(
              decoration: const BoxDecoration(color: Color(0xff1a202e)
              ),
              child: ListView(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
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
                                                image: NetworkImage("$URL/Bitcoin/resources/icons/${name.toLowerCase()}.png"),
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
                                                  '\$${double.parse(coin.toStringAsFixed(2))}',
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
                                  return AppLocalizations.of(context).translate('invalid_coins');
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
                            child: Text(AppLocalizations.of(context).translate('add_coins'),
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
        PortfolioBitcoin? bitcoinLocal =
        items.firstWhereOrNull(
                (element) => element.name == name);

        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: name,
            DatabaseHelper.columnRateDuringAdding: rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) +
                bitcoinLocal.numberOfCoins,
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!) +
                bitcoinLocal.totalValue,
          };
          final id = await dbHelper.update(row);
        } else {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: name,
            DatabaseHelper.columnRateDuringAdding: rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text),
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!),
          };
          final id = await dbHelper.insert(row);
        }
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columnName: name,
          DatabaseHelper.columnRateDuringAdding: rate,
          DatabaseHelper.columnCoinsQuantity:
          double.parse(coinCountTextEditingController!.text),
          DatabaseHelper.columnTotalValue:
          double.parse(coinCountTextEditingController!.value.text) *
              (rate!),
        };
        final id = await dbHelper.insert(row);
      }

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", name!);
        sharedPreferences!.setString("title", AppLocalizations.of(context).translate('portfolio'));
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/portPage', (r) => false);
    } else {}
  }
}


class CartData {
  final String date;
  final double rate;
  final Color color;

  CartData(this.date, this.rate,this.color);
}