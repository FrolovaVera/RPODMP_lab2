import 'package:flutter/material.dart';
import 'package:lab2/model/hab_model.dart';
import 'package:lab2/common/fetch_http_habs.dart';
import 'package:html/parser.dart';
import 'package:logging/logging.dart';
import 'package:webfeed/util/xml.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';



class ReadScreen extends StatefulWidget{
 final urlHab;

 ReadScreen({@required this.urlHab});

  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen>{
var _habModel = Hab();
var _data;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('News'),
         leading: IconButton(
           icon: Icon(Icons.arrow_back_ios),
           onPressed: () => Navigator.pop(context),
         ),
       ),
       body: _getHab()

     );
  }

   _getHab(){
    // return FutureBuilder(
    //   future: _getHttpHab(),
    //   builder: (context, AsyncSnapshot snapshot){
    //     if(!snapshot.hasData){
    //       return Center(
    //           child: CircularProgressIndicator(),
    //       );
    //     } else {
          return WebView(
            initialUrl: widget.urlHab,
            javascriptMode: JavascriptMode.unrestricted,
          );

          //return Container(
          //  child: ListView.builder(
          //      padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
          //      scrollDirection: Axis.vertical,
          //      itemCount: 1,
          //      itemBuilder: (BuildContext context, int index){
          //        return Card(
          //         elevation: 10.0,//тень
            //        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            //       child: Container(
            //          padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            //          child: Column(
            //            children: [
            //              Text(//заголовок
            //              '${_habModel.title}',
            //              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            //              ),
            //              SizedBox(height: 20.0,),//описание
            //              Text('${_habModel.body}',style: TextStyle(color: Colors.blueGrey),
            //              ),
            //            ],
            //          ),
            //        ),
            //      );
            //    }
            //),
          //);

    //     }
    //   },
    // );
   }

   _getHttpHab() async{

     var urihabs = Uri.parse(widget.urlHab);




     var resp = await http.get(urihabs);
        // var response = await fetchHttpHabs(urihabs);
        _data = parse(resp.body);

        //Text('${_habModel.title}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        //Text('${_habModel.body}'),
        //var _hab = parse(response.body);
       _habModel.title = _data.getElementsByClassName('tm-article-snippet__title tm-article-snippet__title_h1')[0].children[0].text;
       _habModel.body = _data.getElementsByClassName('article-formatted-body article-formatted-body article-formatted-body_version-2')[0].children[0].text;
        //_habModel.hab_url = widget.urlHab;
        // return _habModel;
     return _habModel;
   }
}


