
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wq_fotune/utils/UIData.dart';

class PolicyBanner extends StatefulWidget {
  final List banners;
  PolicyBanner({Key key, this.banners}) : super(key: key);

  @override
  PolicyBannerState createState() => PolicyBannerState();

}

class PolicyBannerState extends State<PolicyBanner>{
  Widget _swiperBuilder(BuildContext context, int index) {
    return Container(
      child: FadeInImage.assetNetwork(
        placeholder: "assets/images/empty.png",
        image: widget.banners[index],
        fit: BoxFit.fill,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    print(widget.banners);
    return Container(
        child: Container(
          // height: 180.0,
          height: 124.0,
          // margin: EdgeInsets.only(top: 10),
          child: Swiper(
            itemBuilder: _swiperBuilder,
            itemCount: widget.banners.length,
            pagination: new SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: UIData.white_color,
                activeColor: UIData.blue_color,
              ),
            ),
            autoplay: true,
            duration: 1000,
            onTap: (index) => () {},
          ),
        )
    );
  }
}