class Ticker {
  String symbol;
  dynamic last;
  dynamic buy;
  dynamic open;
  dynamic sell;
  dynamic high;
  dynamic low;
  dynamic vol;
  String change;
  dynamic date;

  Ticker(
      {this.symbol,
      this.last,
      this.buy,
      this.open,
      this.sell,
      this.high,
      this.low,
      this.vol,
      this.change,
      this.date});

  Ticker.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    last = json['last'];
    buy = json['buy'];
    open = json['open'];
    sell = json['sell'];
    high = json['high'];
    low = json['low'];
    vol = json['vol'];
    change = json['change'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['last'] = this.last;
    data['buy'] = this.buy;
    data['open'] = this.open;
    data['sell'] = this.sell;
    data['high'] = this.high;
    data['low'] = this.low;
    data['vol'] = this.vol;
    data['change'] = this.change;
    data['date'] = this.date;
    return data;
  }
}
