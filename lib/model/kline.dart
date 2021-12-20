/// type : "kline"
/// symbol : "btcusdt"
/// fin : 1
/// data : {"open":"45710.43000000","high":"45717.62000000","low":"45651.19000000","close":"45661.11000000","vol":"9.46433000","amount":"432332.84393940","time":"1639792740000"}

class Kline {
  Kline({
    dynamic type,
      dynamic symbol,
      int fin, 
      Data data,}){
    _type = type;
    _symbol = symbol;
    _fin = fin;
    _data = data;
}

  Kline.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _symbol = json['symbol'];
    _fin = json['fin'] ?? 0;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String _type;
  String _symbol;
  int _fin;
  Data _data;

  String get type => _type;
  String get symbol => _symbol;
  int get fin => _fin;
  Data get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['symbol'] = _symbol;
    map['fin'] = _fin;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// open : "45710.43000000"
/// high : "45717.62000000"
/// low : "45651.19000000"
/// close : "45661.11000000"
/// vol : "9.46433000"
/// amount : "432332.84393940"
/// time : "1639792740000"

class Data {
  Data({
      String open, 
      String high, 
      String low, 
      String close, 
      String vol, 
      String amount, 
      String time,}){
    _open = open;
    _high = high;
    _low = low;
    _close = close;
    _vol = vol;
    _amount = amount;
    _time = time;
}

  Data.fromJson(dynamic json) {
    _open = json['open'];
    _high = json['high'];
    _low = json['low'];
    _close = json['close'];
    _vol = json['vol'];
    _amount = json['amount'];
    _time = json['time'];
  }
  String _open;
  String _high;
  String _low;
  String _close;
  String _vol;
  String _amount;
  String _time;

  String get open => _open;
  String get high => _high;
  String get low => _low;
  String get close => _close;
  String get vol => _vol;
  String get amount => _amount;
  String get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['open'] = _open;
    map['high'] = _high;
    map['low'] = _low;
    map['close'] = _close;
    map['vol'] = _vol;
    map['amount'] = _amount;
    map['time'] = _time;
    return map;
  }

}