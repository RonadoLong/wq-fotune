/// id : 86
/// user_id : "1266203624401276928"
/// exchange_id : 1
/// exchange_name : "okex"
/// api_key : "67a3ea44-32d7-49bd-80f6-65e240b5580a"
/// secret : ""
/// passphrase : ""
/// total_usdt : "140.22"
/// total_rmb : "992.79"
/// usdt_balance : "87.47619388"
/// balance_detail : [{"symbol":"ETH","balance":"0.00000064","available":"0.00000064","frozen":"0","type":"spot"},{"symbol":"EOS","balance":"0.0000698","available":"0.0000698","frozen":"0","type":"spot"},{"symbol":"ETC","balance":"0.00000416","available":"0.00000416","frozen":"0","type":"spot"},{"symbol":"USDT","balance":"87.47619388","available":"65.47622998","frozen":"21.9999639","type":"spot"},{"symbol":"NEO","balance":"0.00000099","available":"0.00000099","frozen":"0","type":"spot"},{"symbol":"LTC","balance":"0.00008288","available":"0.00008288","frozen":"0","type":"spot"},{"symbol":"ATOM","balance":"1.1205975","available":"1.1205975","frozen":"0","type":"spot"},{"symbol":"XRP","balance":"0.0009175","available":"0.0009175","frozen":"0","type":"spot"},{"symbol":"ADA","balance":"524.147683","available":"3.525683","frozen":"520.622","type":"spot"}]
/// created_at : "2020-07-02T06:18:32+08:00"
/// updated_at : "2020-07-02T06:18:32+08:00"

class Account {
  int _id;
  String _userId;
  int _exchangeId;
  String _exchangeName;
  String _apiKey;
  String _secret;
  String _passphrase;
  String _totalUsdt;
  String _totalRmb;
  String _usdtBalance;
  List<Balance_detail> _balanceDetail;
  String _createdAt;
  String _updatedAt;

  int get id => _id;
  String get userId => _userId;
  int get exchangeId => _exchangeId;
  String get exchangeName => _exchangeName;
  String get apiKey => _apiKey;
  String get secret => _secret;
  String get passphrase => _passphrase;
  String get totalUsdt => _totalUsdt;
  String get totalRmb => _totalRmb;
  String get usdtBalance => _usdtBalance;
  List<Balance_detail> get balanceDetail => _balanceDetail;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Account({
      int id, 
      String userId, 
      int exchangeId, 
      String exchangeName, 
      String apiKey, 
      String secret, 
      String passphrase, 
      String totalUsdt, 
      String totalRmb, 
      String usdtBalance, 
      List<Balance_detail> balanceDetail, 
      String createdAt, 
      String updatedAt}){
    _id = id;
    _userId = userId;
    _exchangeId = exchangeId;
    _exchangeName = exchangeName;
    _apiKey = apiKey;
    _secret = secret;
    _passphrase = passphrase;
    _totalUsdt = totalUsdt;
    _totalRmb = totalRmb;
    _usdtBalance = usdtBalance;
    _balanceDetail = balanceDetail;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Account.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["user_id"];
    _exchangeId = json["exchange_id"];
    _exchangeName = json["exchange_name"];
    _apiKey = json["api_key"];
    _secret = json["secret"];
    _passphrase = json["passphrase"];
    _totalUsdt = json["total_usdt"];
    _totalRmb = json["total_rmb"];
    _usdtBalance = json["usdt_balance"];
    if (json["balance_detail"] != null) {
      _balanceDetail = [];
      json["balance_detail"].forEach((v) {
        _balanceDetail.add(Balance_detail.fromJson(v));
      });
    }
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["userId"] = _userId;
    map["exchangeId"] = _exchangeId;
    map["exchangeName"] = _exchangeName;
    map["apiKey"] = _apiKey;
    map["secret"] = _secret;
    map["passphrase"] = _passphrase;
    map["totalUsdt"] = _totalUsdt;
    map["totalRmb"] = _totalRmb;
    map["usdtBalance"] = _usdtBalance;
    if (_balanceDetail != null) {
      map["balanceDetail"] = _balanceDetail.map((v) => v.toJson()).toList();
    }
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    return map;
  }

}

/// symbol : "ETH"
/// balance : "0.00000064"
/// available : "0.00000064"
/// frozen : "0"
/// type : "spot"

class Balance_detail {
  String _symbol;
  String _balance;
  String _available;
  String _frozen;
  String _type;
  String _price;
  String _totalUsdt;

  String get symbol => _symbol;
  String get balance => _balance;
  String get available => _available;
  String get frozen => _frozen;
  String get type => _type;
  String get price => _price;
  String get totalUsdt => _totalUsdt;

  Balance_detail({
      String symbol, 
      String balance, 
      String available, 
      String frozen, 
      String type,
  String price,
  String totalUsdt}){
    _symbol = symbol;
    _balance = balance;
    _available = available;
    _frozen = frozen;
    _type = type;
    _price = price;
    _totalUsdt = totalUsdt;
}

  Balance_detail.fromJson(dynamic json) {
    _symbol = json["symbol"];
    _balance = json["balance"];
    _available = json["available"];
    _frozen = json["frozen"];
    _type = json["type"];
    _price = json["price"];
    _totalUsdt = json["total_usdt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["symbol"] = _symbol;
    map["balance"] = _balance;
    map["available"] = _available;
    map["frozen"] = _frozen;
    map["type"] = _type;
    return map;
  }

}