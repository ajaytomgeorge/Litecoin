
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:convert';


const request = "https://api.hgbrasil.com/finance?format=json&key=80f27c39";
List<String> urls = [
  "USD-https://cex.io/api/ticker/LTC/USD",
  "EUR-https://cex.io/api/ticker/LTC/EUR"
];

List<String> scrappingUrls = [
  "NGN_USD-https://www.xe.com/currencyconverter/convert/?Amount=1&From=USD&To=NGN",
  "CUP_USD-https://www.xe.com/currencyconverter/convert/?Amount=1&From=USD&To=CUP",
  "CHF_USD-https://www.xe.com/currencyconverter/convert/?Amount=1&From=USD&To=CHF"
];


Future<List> getCurrencyUsdRate(String currency, String url) async {
  final response = await http.get(url);
  var NngUsd = double.parse(parse(response.body)
      .getElementsByClassName("result__BigRate-sc-1bsijpp-1 iGrAod")[0]
      .innerHtml
      .split("<")[0]);
  return [currency, NngUsd];
}

Future<List> getCurrencyInfo(String currency, String url) async {
  final response = await http.get(url);
  var price = double.parse(json.decode(response.body)["last"]);
  return [currency, price];
}

Future<Map> getData() async {
  List<Future> futures = [];
  urls.asMap().forEach((key, url) {
    var currencyUrl = url.split("-");
    futures.add(getCurrencyInfo(currencyUrl[0], currencyUrl[1]));
  });

  scrappingUrls.asMap().forEach((key, url) {
    var currencyUrl = url.split("-");
    futures.add(getCurrencyUsdRate(currencyUrl[0], currencyUrl[1]));
  });

  final results = await Future.wait(futures);
  results.asMap().forEach((key, value) {
    print(value);
  });

  final ltc_conversion_rate =
      Map.fromIterable(results, key: (v) => v[0], value: (v) => v[1]);
  return ltc_conversion_rate;
}
