import 'package:app/widgets/currency_fetch.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
//import 'package:app/widgets/drop_elegent.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.white, primaryColor: Colors.white),
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final ngnController = TextEditingController();
  final cupController = TextEditingController();
  final chfController = TextEditingController();

  //here we have decleared the variables, that store rates from API
  double dollar_buy;
  double euro_buy;
  double ngn_usd;
  double cup_usd;
  double chf_usd;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    ngnController.text = "";
    cupController.text = "";
    chfController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (dollar_buy * real).toStringAsFixed(2);
    euroController.text = (euro_buy * real).toStringAsFixed(2);
    ngnController.text = ((dollar_buy * real) * ngn_usd).toStringAsFixed(2);
    cupController.text = ((dollar_buy * real) * cup_usd).toStringAsFixed(2);
    chfController.text = ((dollar_buy * real) * chf_usd).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar / this.dollar_buy).toStringAsFixed(2);
    euroController.text =
        ((dollar / this.dollar_buy) * euro_buy).toStringAsFixed(2);
    ngnController.text = (dollar * ngn_usd).toStringAsFixed(2);
    cupController.text = (dollar * ngn_usd).toStringAsFixed(2);
    chfController.text = (dollar * ngn_usd).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro / this.euro_buy).toStringAsFixed(2);
    var dollar = euro / this.euro_buy * dollar_buy;
    dolarController.text = dollar.toStringAsFixed(2);
    ngnController.text = (dollar * ngn_usd).toStringAsFixed(2);
    cupController.text = (dollar * cup_usd).toStringAsFixed(2);
    chfController.text = (dollar * chf_usd).toStringAsFixed(2);
  }

  void _ngnChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double ngn = double.parse(text);
    var dollar = ngn / this.ngn_usd;
    realController.text = (dollar / this.dollar_buy).toStringAsFixed(2);
    dolarController.text = (dollar).toStringAsFixed(2);
    euroController.text =
        ((dollar / this.dollar_buy) * euro_buy).toStringAsFixed(2);
    cupController.text = (dollar * cup_usd).toStringAsFixed(2);
    chfController.text = (dollar * chf_usd).toStringAsFixed(2);
  }

  void _cupChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double cup = double.parse(text);
    var dollar = cup / this.cup_usd;
    realController.text = (dollar / this.dollar_buy).toStringAsFixed(2);
    dolarController.text = (dollar).toStringAsFixed(2);
    euroController.text =
        ((dollar / this.dollar_buy) * euro_buy).toStringAsFixed(2);
    ngnController.text = (dollar * ngn_usd).toStringAsFixed(2);
    chfController.text = (dollar * chf_usd).toStringAsFixed(2);
  }

  void _chfChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double chf = double.parse(text);
    var dollar = chf / this.chf_usd;
    realController.text = (dollar / this.dollar_buy).toStringAsFixed(2);
    dolarController.text = (dollar).toStringAsFixed(2);
    euroController.text =
        ((dollar / this.dollar_buy) * euro_buy).toStringAsFixed(2);
    ngnController.text = (dollar * ngn_usd).toStringAsFixed(2);
    cupController.text = (dollar * cup_usd).toStringAsFixed(2);
  }
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: FutureBuilder(
          future: getData(),
          //snapshot of the context/getData
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Error :(",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dollar_buy =
                      //here we pull the us and eu rate
                      snapshot.data["USD"];
                  euro_buy = snapshot.data["EUR"];
                  ngn_usd = snapshot.data["NGN_USD"];
                  cup_usd = snapshot.data["CUP_USD"];
                  chf_usd = snapshot.data["CHF_USD"];
                  return SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Icon(CryptoFontIcons.LTC,
                          size: 150.0, color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: buildTextField(
                            "Litecoin", "Ł", realController, _realChanged),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: buildTextField(
                            "Dollars", "\$", dolarController, _dolarChanged),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: buildTextField(
                            "Swiss Franc", "CHf", chfController, _chfChanged),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: buildTextField(
                            "Euros", "€", euroController, _euroChanged),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: buildTextField(
                            "Naira", "₦", ngnController, _ngnChanged),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: buildTextField(
                            "Cuban Pesos", "₱", cupController, _cupChanged),
                      ),
                    ],
                  ));
                }
            }
          }),
    );
  }
   Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.white),
  );
  final TextEditingController _controller = new TextEditingController();

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                // onChanged: searchOperation,
              );
              // _handleSearchStart();
            } else {
              // _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

}



Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.white, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
