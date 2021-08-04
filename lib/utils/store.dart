import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

save(key,val) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key,json.encode(val));
}

Future<String> get(key) async {
  var userName;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userName = prefs.getString(key);
  return userName;
}