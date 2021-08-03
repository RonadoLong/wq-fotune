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
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/screen/int_extension.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class FirendShare {
  final String invitationCode;

  FirendShare({Key key, this.invitationCode});

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

  showModel(ctx, String invitationCode) {
    var url;
    if (inProduction) {
      url = 'https://www.ifortune.io/web/?recommend=$invitationCode#/register';
    } else {
      url = 'http://test.ifortune.io/web/?recommend=$invitationCode#/register';
    }
    var size = MediaQuery.of(ctx).size;
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
                      "assets/images/friend_share.jpg",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Positioned(
                    top: 210.px,
                    // right: 52.px,
                    child: Container(
                      width: size.width,
                      // width: 90.px,
                      height: 30.px,
                      child: Text(
                        "${invitationCode}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: UIData.white_color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 35.px,
                    left: 20.px,
                    child: QrImage(
                      data: url,
                      version: QrVersions.auto,
                      size: 90.px,
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
