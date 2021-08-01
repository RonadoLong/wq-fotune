import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wq_fotune/utils/device_utils.dart';

class DownloadApp extends StatefulWidget {

  @override
  _DownloadAppState createState() => _DownloadAppState();
}

class _DownloadAppState extends State<DownloadApp> {
  @override
  Widget build(BuildContext context) {
    if(Device.isWeb){
      return GestureDetector(
        child: new Container(
          child: Image.asset(
            'assets/images/mmexport1601215469979.jpg',
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        onTap: (){
          String clickUrl = "https://www.ifortune.io/";
          canLaunch(clickUrl).then((ok) {
            if (ok) {
              launch(clickUrl);
            }
          });
        },
      );
    }
    return Container();
  }
}