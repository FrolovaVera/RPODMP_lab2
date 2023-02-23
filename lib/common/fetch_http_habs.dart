import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

fetchHttpHabs(url) {//адрес страницы
var client = http.Client();//экземпляр класса клиент
return  client.get(url);// возвращаем ответ от сервера
}

parseDescription(description){
  description = parse(description);
  var txtDescription = parse(description.body.text).documentElement?.text;
  return txtDescription;
}