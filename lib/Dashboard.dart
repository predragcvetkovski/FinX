import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';


class Dashboard extends StatelessWidget {

   dynamic analysisResponse = {};

  Dashboard(dynamic response) {
    this.analysisResponse = response;
  }

   @override 
  Widget build(BuildContext context) {

    Map jsonResponse = JsonDecoder().convert(analysisResponse);
    var summaryJson = jsonResponse['summary'];
    var lossValueStr = (summaryJson['Total_loss'] != null) ? summaryJson['Total_loss'].toStringAsFixed(2) : '999.00';
    var purchasingPowser = summaryJson['loss_in_purchase_power'] != null ? summaryJson['loss_in_purchase_power'].toStringAsFixed(2) : '759.00';
    var cardFee = summaryJson['loss_credit_card_fee'] != null? summaryJson['loss_credit_card_fee'].toStringAsFixed(2) : '240.00';

    var recommendations = jsonResponse['recommendations'] != null ?  jsonResponse['recommendations']  : [];
    var recommendation1Gain = '999.00';
    var recommendation1PurchasingPow = '759.00';
    var recommendation1ServiceFee = '240.00';

    var recommendation2Gain = '999.00';
    var recommendation2PurchasingPow = '759.00';
    var recommendation2ServiceFee = '240.00';

    if(recommendations.length > 0) {
       var recommendations1 = recommendations[0];
       var recommendations2 = recommendations[1];
       recommendation1Gain = recommendations1['gain'] != null ? recommendations1['gain'].toStringAsFixed(2) : recommendation1Gain;
       recommendation1PurchasingPow = recommendations1['purchasing_power'] != null ? recommendations1['purchasing_power'].toStringAsFixed(2) : recommendation1PurchasingPow;
         recommendation1ServiceFee = recommendations1['service_fee'] != null ? recommendations1['service_fee'].toStringAsFixed(2) : recommendation1ServiceFee;


         recommendation2Gain = recommendations2['gain'] != null ? recommendations2['gain'].toStringAsFixed(2) : recommendation2Gain;
       recommendation2PurchasingPow = recommendations2['purchasing_power'] != null ? recommendations2['purchasing_power'].toStringAsFixed(2) : recommendation2PurchasingPow;
         recommendation2ServiceFee = recommendations2['service_fee'] != null ? recommendations2['service_fee'].toStringAsFixed(2) : recommendation2ServiceFee;
    }
   


    return MaterialApp(
     home: Scaffold(
        backgroundColor: Colors.white,
        body:  Column(
          children: <Widget>[
            SizedBox(height:60),
             Image.asset('assets/bank.png'),
             SizedBox(height:10),
              Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[ Text("Checking Account Summary",style: TextStyle(fontSize: 20, color: Colors.grey),), Text("(last 24 months)",style: TextStyle(fontSize: 10, color: Colors.grey))],),),
                   
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Loss \$"+lossValueStr, style:TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Breakdown", style:TextStyle(fontSize: 20, color: Colors.grey),)],),),
                 
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Purchasing power \$"+purchasingPowser, style:TextStyle(fontSize: 20, color: Colors.red),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Service Fee \$"+cardFee, style:TextStyle(fontSize: 20, color: Colors.red),)],),),
        SizedBox(height: 50,child: Container(color: Colors.blue, child:Center(child:Text("Swipe and Save", style:TextStyle(fontSize: 20, color: Colors.white))),),),         
        SizedBox(height: 10,),
        Container( decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Column(children: <Widget>[
              CarouselSlider(
          height: 400.0,
          items: [1,2].map((i) {
              if(i == 1) {
                return Builder(
              builder: (BuildContext context) {
                  return Container(
                  
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                       color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(0.6)),
                       border: Border.all(color: Colors.grey,width: 0.6),
                    ),
                    child: Column(
          children: <Widget>[
            SizedBox(height:40),
             Image.asset('assets/simple.png'),
             SizedBox(height:10),
              Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[ Text("Checking Account Offer",style: TextStyle(fontSize: 18, color: Colors.grey),), Text("(next 24 months)",style: TextStyle(fontSize: 10, color: Colors.grey))],),),
                   
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Gain \$"+recommendation1Gain, style:TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Breakdown", style:TextStyle(fontSize: 20, color: Colors.grey),)],),),
                 
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Purchasing power \$"+recommendation1PurchasingPow, style:TextStyle(fontSize: 20, color: Colors.green),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Service Fee \$"+recommendation1ServiceFee, style:TextStyle(fontSize: 20, color: Colors.green),)],),),
                ])
                  );
                },
              );
              }
            else {
               return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(0.6)),
                            border: Border.all(color: Colors.grey,width: 0.6),
                              
                          ),
                          child: Column(
                              children: <Widget>[
                                SizedBox(height:40),
                                Image.asset('assets/amerant.png'),
                                SizedBox(height:10),
                                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[ Text("Checking Account Summary",style: TextStyle(fontSize: 18, color: Colors.grey),), Text("(last 24 months)",style: TextStyle(fontSize: 10, color: Colors.grey))],),),
                                      
                                      Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Gain \$"+recommendation2Gain, style:TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),)],),),
                                      
                                      Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Breakdown", style:TextStyle(fontSize: 20, color: Colors.grey),)],),),
                                    
                                      Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Purchasing power \$"+recommendation2PurchasingPow, style:TextStyle(fontSize: 20, color: Colors.green),)],),),
                                      
                                      Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Service Fee \$"+recommendation2ServiceFee, style:TextStyle(fontSize: 20, color: Colors.green),)],),),
                                    ])
                         );
                        },
                  );
              }
            }).toList(),
          )]
          ) ,           
        )
        ],
        ),
      ),
     );
  }



}