import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Dashboard extends StatelessWidget {

   @override 
  Widget build(BuildContext context) {

    return MaterialApp(
     home: Scaffold(
        backgroundColor: Colors.white,
        body:  Column(
          children: <Widget>[
            SizedBox(height:60),
             Image.asset('assets/bank.png'),
             SizedBox(height:10),
              Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[ Text("Checking Account Summary",style: TextStyle(fontSize: 20, color: Colors.grey),), Text("(last 24 months)",style: TextStyle(fontSize: 10, color: Colors.grey))],),),
                   
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Loss \$999.00", style:TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Breakdown", style:TextStyle(fontSize: 20, color: Colors.grey),)],),),
                 
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Purchasing power \$759.00", style:TextStyle(fontSize: 20, color: Colors.red),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Service Fee \$240.00", style:TextStyle(fontSize: 20, color: Colors.red),)],),),
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
                   
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Gain \$999.00", style:TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Breakdown", style:TextStyle(fontSize: 20, color: Colors.grey),)],),),
                 
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Purchasing power \$759.00", style:TextStyle(fontSize: 20, color: Colors.green),)],),),
                  
                  Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Service Fee \$240.00", style:TextStyle(fontSize: 20, color: Colors.green),)],),),
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
                                      
                                      Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Gain \$999.00", style:TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),)],),),
                                      
                                      Padding(padding: EdgeInsets.all(8.0), child: Row(children: <Widget>[Text("Breakdown", style:TextStyle(fontSize: 20, color: Colors.grey),)],),),
                                    
                                      Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Purchasing power \$759.00", style:TextStyle(fontSize: 20, color: Colors.green),)],),),
                                      
                                      Padding(padding: EdgeInsets.all(8.0), child:Row(children: <Widget>[Text("Service Fee \$240.00", style:TextStyle(fontSize: 20, color: Colors.green),)],),),
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