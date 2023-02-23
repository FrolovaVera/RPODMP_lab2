import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webfeed/webfeed.dart';
import 'package:lab2/common/fetch_http_habs.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lab2/screens/read_screen.dart';

class HomeScreenRSS extends StatefulWidget{
  @override
  _HomeScreenRSSState createState() => _HomeScreenRSSState();
}

class _HomeScreenRSSState extends State{
  bool _darkTheme = false;
  List _habsList = [];//список

  @override
  Widget build(BuildContext context) { //
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: !_darkTheme ? ThemeData(primarySwatch: Colors.blueGrey): ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('RSS-News'),
          actions: [
            Icon(_getAppBarIcon()),
            CupertinoSwitch(
              value: _darkTheme,
              onChanged: (bool value){
                setState(() {
                  _darkTheme = !_darkTheme;
                });
              }
            ),
          ],
        ),
        body: FutureBuilder(
          future: _getHttpHabs(),
          builder: (context,AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return Center(
              child: CircularProgressIndicator(),//не получили данные с сайта
              );
            } else{
              return Container(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                  scrollDirection: Axis.vertical,
                  itemCount: _habsList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      elevation: 10.0,//тень
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        padding:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Column(
                          children: [Text(//заголовок
                            '${_habsList[index].title}',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                            SizedBox(height: 20.0,),//описание
                            Text('${parseDescription(_habsList[index].description)}',
                              style: TextStyle(color: Colors.blueGrey),
                            ),

                            SizedBox(height: 20.0,),//дата
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(DateFormat('dd.mm.yyyy kk:mm').format(
                                DateTime.parse('${_habsList[index].pubDate}'
                                )//pubDate on lastBuildDate
                              )),
                                FloatingActionButton.extended(//кнопка
                                  heroTag: null,
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReadScreen(urlHab: '${_habsList[index].guid}',)
                                    )),
                                    label: Text('Читать'),
                                icon: Icon(Icons.arrow_forward),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _getAppBarIcon(){
    if(_darkTheme){
      return Icons.highlight;
    }
    else{
      return Icons.lightbulb_outline;
    }
  }


  _getHttpHabs() async{
    var uri = Uri.parse('https://habr.com/ru/rss/hubs/all/');

    //final log = Logger('ExampleLogger');
    // Logger.root.level = Level.ALL; // defaults to Level.INFO
    // Logger.root.onRecord.listen((record) {
    //  print('${record.level.name}: ${record.time}: ${record.message}');
    // });
    // Logger.root.level = Level.SEVERE;


      var response = await fetchHttpHabs(uri);
     // log.info('response: n = $response');
      var  chanel = RssFeed.parse(response.body);

        chanel.items?.forEach((element) {
          _habsList.add(element);
        });


      return _habsList;
  }
}