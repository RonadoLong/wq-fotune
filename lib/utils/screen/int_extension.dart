
import 'size_fit.dart';

extension IntFit on int {
  double get px {
    return TLSizeFit.setPx(this.toDouble());
  }
  double get rpx {
    return TLSizeFit.setRpx(this.toDouble());
  }
}