import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wq_fotune/page/login/login_page.dart';

Future gotoLoginPage(BuildContext context, {String route}) async {
 if (route != null) {
  var res = await Navigator.pushNamed(
      context, '/login', arguments: {'route': route});
  return res;
 }
 var res = await Navigator.pushNamed(context, '/login');
 return res;
}
