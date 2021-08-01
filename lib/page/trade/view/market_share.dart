import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_extend/share_extend.dart';
import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/utils/screen/int_extension.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class MarketShare {
  final Map item;

  MarketShare({Key key, this.item});

  GlobalKey _globalKey = new GlobalKey();
  Uint8List pngBytes;
  var event = EventBus();
  bool inProduction = const bool.fromEnvironment("dart.vm.product");
  BuildContext context;

  Future<Uint8List> capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String bs64 = base64Encode(pngBytes);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Future<String> writeShareImageByteToImageFile(Uint8List pngBytes) async {
    Directory dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    File imageFile = new File(
        "${dir.path}/flutter/${DateTime.now().millisecondsSinceEpoch}.png");
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(pngBytes);
    return imageFile.path;
  }

  Future<void> shareImage() async {
    try {
      handleRefresh(() async {
        capturePng().then((pngBytes) async {
          String path = await writeShareImageByteToImageFile(pngBytes);
          ShareExtend.share(path, "image",
              sharePanelTitle: "分享您的成果", subject: "ifortune，您值得信赖")
              .whenComplete(() {
            print("share whenComplete done");
          }).catchError((err) {
            print("share err done: ${err.toString()}");
          });
        });

      });
    } catch (e) {
      print(e);
    }
  }

  showModel(ctx, Map item, String rec) {
    var T;
    var url;
    if(item['anchorSymbol'].contains('usdt')){
      T = double.parse(item['totalProfit']).toStringAsFixed(2);
    }else{
      T = double.parse(item['totalProfit']);
    }
    if(inProduction){
      url = 'https://www.ifortune.io/web/?recommend=$rec#/register';
    }else{
      url = 'http://test.ifortune.io/web/?recommend=$rec#/register';
    }
    showModalBottomSheet(
      context: ctx,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        context = context;
        return StatefulBuilder(builder: (context, state) {
          return Center(
            child: RepaintBoundary(
              key: _globalKey,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/images/share.jpg",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Positioned(
                    bottom: 335.px,
                    right: 84.px,
                    child: Container(
                      width: 210.px,
                      height: 60.px,
                      child: Text(
                        "${item['annualReturn']}%",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 32.px,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 215.px,
                    right: 88.px,
                    child: Container(
                      width: 200.px,
                      height: 60.px,
                      child: Text(
                        "${T}${item['anchorSymbol'].toUpperCase()}(${item["rateReturn"]}%)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15.px,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 135.px,
                    left: 52.px,
                    child: Container(
                      width: 90.px,
                      height: 38.px,
                      child: Text(
                        "${item["totalSum"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 135.px,
                    left: 145.px,
                    child: Container(
                      width: 90.px,
                      height: 38.px,
                      child: Text(
                        "${item['symbol'].toUpperCase()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 135.px,
                    left: 235.px,
                    child: Container(
                      width: 90.px,
                      height: 38.px,
                      child: Text(
                        "${item['tradeCount']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 50.px,
                    child: QrImage(
                      data: url,
                      version: QrVersions.auto,
                      size: 110.px,
                      foregroundColor: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
