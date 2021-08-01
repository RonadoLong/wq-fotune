
import 'size_fit.dart';

extension DoubleFit on double {
  double get px {
    return TLSizeFit.setPx(this);
  }

  double get rpx {
    return TLSizeFit.setRpx(this);
  }
}
