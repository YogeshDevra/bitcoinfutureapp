// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe, library_private_types_in_public_api, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitMod/futCrypt.dart';
import 'fitMod/futSheetPort.dart';
import 'futCryptoSheet.dart';
import 'futLocate/futLang.dart';
import 'futMap.dart';
import 'sqlFut.dart';

class FutPortSheet extends StatefulWidget {
  const FutPortSheet({Key? key}) : super(key: key);

  @override
  _FutPortSheet createState() => _FutPortSheet();
}

class _FutPortSheet extends State<FutPortSheet>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List<FutCrypto> cryptoFut = [];
  SharedPreferences? sharedPreferences;
  num _size = 0;
  double totalValuesOfPortfolio = 0.0;
  final _futLock = GlobalKey<FormState>();
  String? futLogo;



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

  @override
  void dispose() {
    super.dispose();
  }
  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;

    try {

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
        title: Text(FutLang.of(context).translate('portfolio')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Color(0xff111622)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '\$${totalValuesOfPortfolio.toStringAsFixed(2)}',textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xffff0000),borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(FutLang.of(context).translate('portfolio_value'),textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: items.isNotEmpty && cryptoFut.isNotEmpty
                      ? ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          elevation: 1,
                          child: Container(
                            decoration: const BoxDecoration(color: Color(0xff1a202e),
                                border: Border(top: BorderSide(color: Colors.red, width: 1))),
                            height: MediaQuery.of(context).size.height/11,
                            width: MediaQuery.of(context).size.width/.5,
                            child:GestureDetector(
                                onTap: (){
                                  showPortfolioEditDialog(items[i]);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(1),
                                        child:Container(
                                            child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Text('${items[i].name}',
                                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white), textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Text('\$ ${items[i].rateDuringAdding.toStringAsFixed(2)}',
                                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff6d778b))
                                                ),
                                              ],
                                            )
                                        )
                                    ),
                                    const Spacer(),
                                    // Visibility(
                                    //   visible: _isShow,
                                    //   maintainSize: true,
                                    //   maintainAnimation: true,
                                    //   maintainState: true,
                                    //   child: Image.asset(
                                    //     'assets/image/Lock.png',
                                    //   ),
                                    //   replacement:
                                    InkWell(
                                      onTap: (){
                                        _showdeleteCoinFromPortfolioDialog(items[i]);
                                      },
                                      child: Image.asset(
                                        'assets/image/trash-can.png',
                                      ),
                                    ),
                                    // ),
                                    const Spacer(),
                                    InkWell(

                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          children: [
                                            const Spacer(),

                                            Text('\$${items[i].totalValue.toStringAsFixed(2)}',
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                              textAlign: TextAlign.end,),

                                            const Spacer()
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width:10),
                                    const SizedBox(
                                      width: 2,
                                    )
                                  ],
                                )
                            ),
                          ),
                        );
                      })
                      :Center(
                    child: ElevatedButton(
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FutCryptoSheet()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(FutLang.of(context).translate('add_coins')),
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white,),
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff0000),),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                  side: const BorderSide(width: 3, color: Color(0xffff0000))
                              )
                          )
                      ),
                    ),
                    // Text("No Coins Added", style: TextStyle(color: Colors.white))
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }


  Future<void> callBitcoinApi() async {
    var uri = '$futLogo/Bitcoin/resources/getBitcoinList?size=${_size}';

    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      setState(() {
        cryptoFut.addAll(data['data']
            .map<FutCrypto>((json) => FutCrypto.fromJson(json))
            .toList());
        isLoading = false;
        _size = _size + data['data'].length;
      });
    } else {
      //  _ackAlert(context);
      setState(() {});
    }
  }

  Future<void> showPortfolioEditDialog(FutSheetPort bitcoin) async {
    coinCountEditTextEditingController!.text = bitcoin.numberOfCoins.toInt().toString();
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Color(0xff1a202e)),
              child: ListView(
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 20,
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
                                const SizedBox(
                                  width: 100,
                                ),
                                Text(FutLang.of(context).translate('update_coins'),
                                  style: const TextStyle(
                                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:50),
                            child: Text(FutLang.of(context).translate('enter_coins'),
                                style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              decoration: BoxDecoration(color: const Color(0xff2e3546),
                                border: Border.all(color: const Color(0xffc30508)
                                ),
                              ),
                              child: Row(
                                  children:<Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: FadeInImage(
                                                height: 70,
                                                placeholder: const AssetImage('assets/image/cob.png'),
                                                image: NetworkImage(
                                                    "$futLogo/Bitcoin/resources/icons/${bitcoin.name!.toLowerCase()}.png"),
                                              ),
                                            ),
                                            const SizedBox(
                                              height:10,
                                            ),
                                          ]
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        Text(bitcoin.name!,
                                          style: const TextStyle(fontSize: 25, color: Colors.white),),
                                        const SizedBox(
                                          height:10,
                                        ),
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Form(
                              key: _futLock,
                              child: TextFormField(
                                controller: coinCountEditTextEditingController,
                                style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ], // O
                                //only numbers can be entered
                                validator: (val) {
                                  if (coinCountEditTextEditingController!.value.text == "" ||
                                      int.parse(coinCountEditTextEditingController!.value.text) <= 0) {
                                    return FutLang.of(context).translate('invalid_coins');
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              SizedBox(
                                width:300,
                                child: TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff0000)),
                                  ),
                                  child: Text(FutLang.of(context).translate('add_coins'),
                                    textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                        fontSize: 15),),
                                  // color: Colors.blueAccent,
                                  onPressed: (){
                                    _updateSaveCoinsToLocalStorage(bitcoin);
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),]
              ),
            ),
          ),
        )
    );
  }

  getCurrentRateDiff(FutSheetPort items, List<FutCrypto> bitcoinList) {
    FutCrypto j = bitcoinList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! - items.rateDuringAdding;
    return newRateDiff;
  }

  _updateSaveCoinsToLocalStorage(FutSheetPort bitcoin) async {
    if (_futLock.currentState!.validate()) {
      int adf = int.parse(coinCountEditTextEditingController!.text);
      print(adf);
      Map<String, dynamic> row = {
        SQLFut.columnName: bitcoin.name,
        SQLFut.columnRateDuringAdding: bitcoin.rateDuringAdding,
        SQLFut.columnCoinsQuantity:
        double.parse(coinCountEditTextEditingController!.value.text),
        SQLFut.columnTotalValue: (adf) * (bitcoin.rateDuringAdding),
      };
      final id = await dbHelper.update(row);
      print('inserted row id: $id');
      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", bitcoin.name);
        sharedPreferences!.setInt("index", 3);
        sharedPreferences!.setString("title", FutLang.of(context).translate('portfolio'));
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/portPage', (r) => false);
    } else {}
  }

  void _showdeleteCoinFromPortfolioDialog(FutSheetPort item) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Color(0xff1a202e)),
              child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                              const SizedBox(
                                width: 100,
                              ),
                              Text(FutLang.of(context).translate('remove_coins'),
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.start,
                              ),

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
                            child:
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(FutLang.of(context).translate('do_you'),
                                style: const TextStyle(color: Colors.white,fontSize: 18),),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Container(
                            decoration: BoxDecoration(color: const Color(0xff2e3546),
                              border: Border.all(color: const Color(0xffc30508)
                              ),
                            ),
                            child: Row(
                                children:<Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: FadeInImage(
                                              height: 70,
                                              placeholder: const AssetImage('assets/image/cob.png'),
                                              image: NetworkImage(
                                                  "$futLogo/Bitcoin/resources/icons/${item.name!.toLowerCase()}.png"),
                                            ),
                                          ),
                                          const SizedBox(
                                            height:10,
                                          ),
                                        ]
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    children: [
                                      Text(item.name!,
                                        style: const TextStyle(fontSize: 25, color: Colors.white),),
                                      const SizedBox(
                                        height:10,
                                      ),
                                    ],
                                  ),
                                ]
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(
                              width:300,
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff0000)),
                                ),
                                child: Text(FutLang.of(context).translate('remove'),
                                  textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                      fontSize: 15),),
                                // color: Colors.blueAccent,
                                onPressed: (){
                                  _deleteCoinsToLocalStorage(item);
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
        )
    );
  }

  _deleteCoinsToLocalStorage(FutSheetPort item) async {
    final id = await dbHelper.delete(item.name);
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("title", FutLang.of(context).translate('portfolio'));
      sharedPreferences!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/portPage', (r) => false);
  }

}
