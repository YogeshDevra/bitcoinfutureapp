// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe, library_private_types_in_public_api, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';
import 'package:bitcoinfutureapp/api_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coins_page.dart';
import 'dashboard_helper.dart';
import 'localization/app_localization.dart';
import 'models/Bitcoin.dart';
import 'models/PortfolioBitcoin.dart';
import 'Navbar.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  double totalValuesOfPortfolio = 0.0;
  final _formKey = GlobalKey<FormState>();
  String? image;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    coinCountTextEditingController = TextEditingController();
    coinCountEditTextEditingController = TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      for (var note in notes) {
        items.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      }
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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
        title: Text(AppLocalizations.of(context).translate('portfolio')),
        titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: isLoading == true
          ?const Center(child: CircularProgressIndicator(color: Colors.blue,),)
          :Container(
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
                        child: Text(AppLocalizations.of(context).translate('portfolio_value'),textAlign: TextAlign.center,
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
                  child: isLoading ? Center(child: CircularProgressIndicator())
                      :items.isNotEmpty
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
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(items[i].name,
                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white), textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Text('\$ ${items[i].rateDuringAdding.toStringAsFixed(2)}',
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff6d778b))
                                            ),
                                          ],
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CoinsPage()));
                      },
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
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(AppLocalizations.of(context).translate('add_coins')),
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

  Future<void> showPortfolioEditDialog(PortfolioBitcoin bitcoin) async {
    coinCountEditTextEditingController!.text = bitcoin.numberOfCoins.toInt().toString();
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            appBar: AppBar(
              leading:Padding(
                padding: const EdgeInsets.all(10),
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
              title: Text(AppLocalizations.of(context).translate('update_coins')),
              titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
            body: Container(
              decoration: const BoxDecoration(color: Color(0xff1a202e)),
              child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:50),
                          child: Text(AppLocalizations.of(context).translate('enter_coins'),
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
                                                  "${api_config.URL}/Bitcoin/resources/icons/${bitcoin.name.toLowerCase()}.png"),
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
                                      Text(bitcoin.name,
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
                              key: _formKey,
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
                                    return AppLocalizations.of(context).translate('invalid_coins');
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
                                child: Text(AppLocalizations.of(context).translate('add_coins'),
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
                    ),]
              ),
            ),
          ),
        )
    );
  }

  getCurrentRateDiff(PortfolioBitcoin items, List<Bitcoin> bitcoinList) {
    Bitcoin j = bitcoinList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! - items.rateDuringAdding;
    return newRateDiff;
  }

  _updateSaveCoinsToLocalStorage(PortfolioBitcoin bitcoin) async {
    if (_formKey.currentState!.validate()) {
      int adf = int.parse(coinCountEditTextEditingController!.text);
      print(adf);
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: bitcoin.name,
        DatabaseHelper.columnRateDuringAdding: bitcoin.rateDuringAdding,
        DatabaseHelper.columnCoinsQuantity:
        double.parse(coinCountEditTextEditingController!.value.text),
        DatabaseHelper.columnTotalValue: (adf) * (bitcoin.rateDuringAdding),
      };
      final id = await dbHelper.update(row);
      print('inserted row id: $id');
      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", bitcoin.name);
        sharedPreferences!.setInt("index", 3);
        sharedPreferences!.setString("title", AppLocalizations.of(context).translate('portfolio'));
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/portPage', (r) => false);
    } else {}
  }

  void _showdeleteCoinFromPortfolioDialog(PortfolioBitcoin item) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            appBar: AppBar(
              leading:Padding(
                padding: const EdgeInsets.all(10),
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
              title: Text(AppLocalizations.of(context).translate('remove_coins')),
              titleTextStyle: GoogleFonts.openSans(textStyle: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
            body: Container(
              decoration: const BoxDecoration(color: Color(0xff1a202e)),
              child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                              child: Text(AppLocalizations.of(context).translate('do_you'),
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
                                                  "${api_config.URL}/Bitcoin/resources/icons/${item.name.toLowerCase()}.png"),
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
                                      Text(item.name,
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
                                child: Text(AppLocalizations.of(context).translate('remove'),
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

  _deleteCoinsToLocalStorage(PortfolioBitcoin item) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("title", AppLocalizations.of(context).translate('portfolio'));
      sharedPreferences!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/portPage', (r) => false);
  }

}
