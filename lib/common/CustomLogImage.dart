import 'package:flutter/material.dart';
import 'package:wq_fotune/common/Constants.dart';
import 'package:wq_fotune/utils/UIData.dart';

Container buildLogImage(String url, {double height=64,double width=64}) {
  return Container(
    width: width,
    height: height,
    decoration:
        BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
      BoxShadow(
          color: Colors.grey.shade400,
          offset: Offset(0, 0),
          blurRadius: 5,
          spreadRadius: 1)
    ],),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(width*0.5),
      child: url != null ? FadeInImage.assetNetwork(
        placeholder: "assets/images/bitcoin-exchange.png",
        image: url,
        fit: BoxFit.cover,
      ): Image.asset("assets/images/bitcoin-exchange.png",
        fit: BoxFit.cover,
      ),
    ),
  );

//    return Container(
//      width: 80,
//      height: 80,
//      child: CachedNetworkImage(
//        imageUrl: default_icon,
//        imageBuilder: (context, imageProvider) => Container(
//          decoration: BoxDecoration(
//            shape: BoxShape.circle,
//            color: UIData.default_color,
//            image: DecorationImage(
//              image: imageProvider,
//              fit: BoxFit.cover,
//            ),
//          ),
//        ),
//        placeholder: (context, url) => CircularProgressIndicator(),
//        errorWidget: (context, url, error) => Icon(Icons.error_outline),
//      ),
//    );
}
