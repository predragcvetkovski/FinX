import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Dashboard extends StatelessWidget {

   @override 
  Widget build(BuildContext context) {

    return MaterialApp(
     home: Scaffold(
       appBar: AppBar(
         title: Text("Dashboard"),
        ),
        body:  Column(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                     const ListTile(
                        title: Text('Summary'),
                        subtitle: Text(''),
                      ),
                      const ListTile(
                        leading: Icon(Icons.arrow_downward, size: 50,color: Colors.red,),
                        title: Text('300'),
                        subtitle: Text(''),
                      ),
                      Text("Fee Related Loss:"),
                      Text("Purchasing power loss:"),
                ],
              )
            ),
        Card(
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
                       color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(0.6)),
                       border: Border.all(color: Colors.grey,width: 0.6),
                      //  boxShadow: [
                      //       new BoxShadow(
                      //           color: Colors.grey,
                      //           offset: new Offset(20.0, 10.0),
                      //         )
                      //       ],
                    ),
                    child: Text('Switch bank',)
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
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(0.6)),
                            border: Border.all(color: Colors.grey,width: 0.6),
                              // boxShadow: [
                              //     new BoxShadow(
                              //      color: Colors.grey,
                              //       offset: new Offset(20.0, 10.0),
                              //     )
                              // ],
                          ),
                          child: Text('Swith to product')
                         );
                        },
                  );
              }
            }).toList(),
          )]
          )
        ), 
        ],
        ),
      ),
     );
  }



}