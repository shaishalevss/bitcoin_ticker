import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'crypto_card.dart';

class PriceScreen extends StatefulWidget {

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  Map<String,String> coinsVal ={};
  bool isWaiting = false;

  void getData() async{
    isWaiting = true;
    try{
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;

      setState(() {
        coinsVal = data;
      });
    } catch(e){
      print(e);
    }
  }

  //dropdown for android
  DropdownButton<String> androidDropdownButton(){
    List<DropdownMenuItem<String>> currencyItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      currencyItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  //dropdown for ios
  CupertinoPicker IOSPicker(){
    List<Text> currencyItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      currencyItems.add(newItem);
    }
    return CupertinoPicker(itemExtent: 32.0, onSelectedItemChanged: (selectedIndex){
      selectedCurrency = currenciesList[selectedIndex];
      getData();
    }, children: currencyItems,
    );
  }


   Column makeCards() {
   List<CryptoCard> cryptoCards = [];
   for (String crypto in cryptoList) {
     cryptoCards.add(
       CryptoCard(
         cryptoCurrency: crypto,
         value: isWaiting ? '?' : coinsVal[crypto],
         selectedCurrency: selectedCurrency,
       ),
     );
   }
   return Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: cryptoCards,
   );
 }


  String selectedCurrency = 'AUD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black54,
            child: Platform.isIOS ? IOSPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
