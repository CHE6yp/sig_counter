// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import "package:http/http.dart";
import 'config_data.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() => runApp(Counter());

class Counter extends StatelessWidget{

  static Client httpClient;

  Counter(){
    httpClient = Client();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Счетчик сижек',

      home:Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Счетчик сижек')//backgroundColor: Color.fromARGB(255, 100, 100, 255),

        ),
        body:Center(
          child: Day()
        )
      ),
      theme: ThemeData(primaryColor: Color.fromARGB(255, 100, 100, 255)),
    );
  }
}

class Day extends StatefulWidget{
  final int s = 0;
  @override
  State<StatefulWidget> createState() {
    return DayState();
  }
}

class DayState extends State<Day>{
  DateTime pickedDate;
  int y = 0;
  int m = 0;
  int d = 0;
  int sigCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    changeDate(DateTime.now());
    //fetchData();
  }

  //like Update() in Unity
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: [
            FlatButton(child:Text("Сижек за $d $m $y:", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              onPressed: (){
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(2019, 10, 5),
                  maxTime: DateTime.now(),
                  onChanged: (date) {
                    print('change $date');
                  },
                  onConfirm: (date) {
                    print('confirm $date');
                    changeDate(date);
                  },
                  currentTime: pickedDate,
                  locale: LocaleType.ru
                );
              },
            ),
            Container(
              child: (isLoading)? Center(child: CircularProgressIndicator(),heightFactor: 2.55,):
                Text("$sigCount", style: TextStyle(fontSize: 78, color: (sigCount<5)? Colors.green : Colors.red),)
            )
          ],
        ),
        Row(
          children: <Widget>[
            FloatingActionButton(child: Text("-"), backgroundColor: Theme.of(context).primaryColor, onPressed: ()=>changeSigCount(-1)),
            FloatingActionButton(child: Text("+"), backgroundColor: Theme.of(context).primaryColor, onPressed: ()=>changeSigCount(1))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }

  changeSigCount(int x) async {
    print ('count sig $x');
    sigCount+=x;
    await Counter.httpClient.get(configData['HOSTNAME']+'/calendar/saveDay/$y/$m/$d/$sigCount');
    fetchData();
  }

  changeDate(DateTime date){
    setState((){
      pickedDate = date;
      y = pickedDate.year;
      m = pickedDate.month;
      d = pickedDate.day;
    });
    fetchData();
  }

  fetchData() async {
    setState((){isLoading = true;});
    print ("isLoading before $isLoading");
    var response = await Counter.httpClient.get(configData['HOSTNAME']+'/calendar/getDay/$y/$m/$d');

    setState(() {
      isLoading = false;
      sigCount = int.parse(response.body);
    });

    print ("isLoading after $isLoading");
  }
}