import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/page/home/view/home_header.dart';

class HomeBanner extends StatefulWidget {
  final List banners;
  final Function press;

  HomeBanner({
    Key key,
    this.banners,
    this.press,
  }) : super(key: key);

  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  List banners = ["banner1.jpg", "banner2.jpg", "banner3.jpg", "banner4.jpg"];
  Widget _swiperBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        print("=====");
        this.widget.press(index);
      },
      child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          // child: FadeInImage.assetNetwork(
          //   placeholder: "assets/images/empty.png",
          //   image: widget.banners[index]["image"],
          //   fit: BoxFit.fill,
          // ),
          child: Image(
            image: AssetImage("assets/images/${banners[index]}"),
            fit: BoxFit.fill,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      margin: EdgeInsets.all(8),
      child: Swiper(
        itemBuilder: _swiperBuilder,
        itemCount: widget.banners.length,
        scale: 0.95,
        scrollDirection: Axis.horizontal,
        autoplay: true,
        duration: 1000,
        onTap: (index) => () {},
      ),
    );
  }
}
