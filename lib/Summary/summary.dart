import 'package:finpal/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plaid/flutter_plaid.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:finpal/Loading/loading.dart';


class FinPalSummary extends StatelessWidget {

LoadingIndicator _loadingIndicator;
BuildContext _buildContext;

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
      fetchAccessToken(context, result.token);
      _loadingIndicator =  LoadingIndicator();
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return _loadingIndicator.build(context);
      }));
    });
  }
  

Future fetchAccessToken(BuildContext context, String publicToken) async {

  Map data = {
    'public_token': publicToken,
    'secret': '54f436fa913daa9fec635c0f73c5a1',
    'client_id': '5d65bfb1744b460013d3ea8a'
  };

  final response =  await http.post('https://development.plaid.com/item/public_token/exchange', headers: { "content-type" : "application/json", "accept" : "application/json"}, body: json.encode(data));
  if (response.statusCode == 200) {
     var decodedJson = json.decode(response.body);
     fetchTransactions(decodedJson['access_token'], context);
  } else {
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
      fetchTransactionAnalysis(response.body, context);
      
    } else {

    }
}

Future fetchTransactionAnalysis(dynamic responseStr, BuildContext context)  async {

  final response = await http.post('https://finx-hacakthon.herokuapp.com/analysis', headers: { "content-type" : "application/json", "accept" : "application/json"},  body: responseStr);

  if(response.statusCode == 200) {
      debugPrint("returned transactional data" + response.body);
       var dashBoard = Dashboard(response.body);
       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return dashBoard.build(context);
      }));
    } else {

    }
}


 @override 
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      //  appBar: AppBar(
      //    //title: Text("Plaid API"),
      //    backgroundColor: Colors.indigo[900],
      //   ),
        body: Center( child :Column(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      ImageIcon(AssetImage('assets/Logo.png',), size: 200, color: Colors.red,),
                    SizedBox(height: 100),
                    RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () { this.showPlaidView(context); },
                        child: const Text(
                          'Start Saving',
                          style: TextStyle(fontSize: 20, color: Colors.red)
                        ),
                      )
                    ],)
          ));
  }
}