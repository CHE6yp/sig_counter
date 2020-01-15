// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import "package:http/http.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'config_data.dart';


void main() => runApp(Counter());

class Counter extends StatelessWidget{

  static Client httpClient;
//  static var config;

  Counter(){
    httpClient = Client();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: 'Счетчик сижек',

        home:Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 255, 100),
            appBar: AppBar(
              title: Text('Счетчик сижек'),backgroundColor: Color.fromARGB(255, 100, 100, 255),
            ),
            body:Center(
                child: Day()
            )
        )
    );
  }


}

class Day extends StatefulWidget{
  final int s =0;
  @override
  State<StatefulWidget> createState() {
    return DayState();
  }
}

class DayState extends State<Day>{
  int y = 0;
  int m = 0;
  int d = 0;
  int sigCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
//    _loadData();
//    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      fetchData();
    });
    return (isLoading)? Center(child: CircularProgressIndicator(),): Column(
      children: <Widget>[
        Column(
          children: [
//              Text("$context"),
            Text("Сижек за $d $m $y:", style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic),),
//              Text("Сижек за "+initializeDateFormatting("ru_RU",null).then(()=>{new DateFormat.yMMMd().format(dateTime)})),
            Text("$sigCount", style: TextStyle(fontSize: 62, color: (sigCount<5)?Colors.green:Colors.red),),
          ],
        ),
        Row(
          children: <Widget>[
            FloatingActionButton(child: Text("-"), onPressed: ()=>{ setState(()=> {changeSigCount(-1)})},),
            FloatingActionButton(child: Text("+"), onPressed: ()=>{ setState(()=> {changeSigCount(1)}) },)
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  changeSigCount(int x) async {
    print ('cj');
    sigCount+=x;
    await Counter.httpClient.get(configData['HOSTNAME']+'/calendar/saveDay/$y/$m/$d/$sigCount');
  }

  fetchData() async {
    //Client httpClient = Client();
    DateTime dateTime = DateTime.now();
    y = dateTime.year;
    m = dateTime.month;
    d = dateTime.day;
//    isLoading = true;
    var response = await Counter.httpClient.get(configData['HOSTNAME']+'/calendar/getDay/$y/$m/$d');

    setState(() {
      isLoading = false;
    });

    print("getDay "+response.body);
    sigCount = int.parse(response.body);
  }
}