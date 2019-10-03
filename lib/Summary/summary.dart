import 'package:flutter/material.dart';
import 'package:flutter_plaid/flutter_plaid.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';


class FinPalSummary extends StatelessWidget {

showPlaidView(BuildContext context) async {
    bool plaidSandbox = false;
    
    Configuration configuration = Configuration(
        plaidPublicKey: 'f9467511826b9b6e587eeb4da7b51c',
        plaidBaseUrl: 'https://cdn.plaid.com/link/v2/stable/link.html',
        plaidEnvironment: plaidSandbox ? 'sandbox' : 'development',
        environmentPlaidPathAccessToken:
            'https://development.plaid.com/item/public_token/exchange',
        environmentPlaidPathStripeToken:
            'https://development.plaid.com/processor/stripe/bank_account_token/create',
        plaidClientId: '5d65bfb1744b460013d3ea8a',
        secret: '54f436fa913daa9fec635c0f73c5a1');

    FlutterPlaidApi flutterPlaidApi = FlutterPlaidApi(configuration);
    flutterPlaidApi.launch(context, (Result result) {
      ///handle result
      print(result);
     fetchAccessToken(context, result.token);
       
      
    });
  }
  

Future fetchAccessToken(BuildContext context, String publicToken) async {

  Map data = {
    'public_token': publicToken,
    'secret': '54f436fa913daa9fec635c0f73c5a1',
    'client_id': '5d65bfb1744b460013d3ea8a'
  };

  final response =  await http.post('https://development.plaid.com/item/public_token/exchange', headers: { "content-type" : "application/json", "accept" : "application/json"}, body: json.encode(data));

     // await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
     var decodedJson = json.decode(response.body);
     fetchTransactions(decodedJson['access_token'], context);
    // If the call to the server was successful, parse the JSON.
    //return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}


Future fetchTransactions(String accessToken, BuildContext context) async {
  var now = new DateTime.now();
  var pastMonth = DateTime.now().subtract(Duration(days: 30));
  var formatter = new DateFormat('yyyy-MM-dd');
  Map bodyData =  {'client_id': '5d65bfb1744b460013d3ea8a','secret':'54f436fa913daa9fec635c0f73c5a1','access_token':
      accessToken,'start_date': formatter.format(pastMonth),'end_date': formatter.format(now)};
  var bodyStr = json.encode(bodyData);
  final response = await http.post('https://development.plaid.com/transactions/get', headers: { "content-type" : "application/json", "accept" : "application/json"},  body: bodyStr);

    if(response.statusCode == 200) {
      debugPrint("transactions" + response.body);
      Navigator.pop(context);
    } else {

    }
}


 @override 
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Scaffold(
       appBar: AppBar(
         title: Text("Plaid API"),
        ),
        body: RaisedButton(
          onPressed: () { this.showPlaidView(context); },
          child: const Text(
            'Plaid API',
            style: TextStyle(fontSize: 20)
          ),
        ),
     )
    );

  }
}