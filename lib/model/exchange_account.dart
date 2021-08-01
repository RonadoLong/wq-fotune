class ExchangeAccount {
    List<ExchangePo> exchange_pos;

    ExchangeAccount({this.exchange_pos});

    factory ExchangeAccount.fromJson(Map<String, dynamic> json) {
        return ExchangeAccount(
            exchange_pos: json['exchange_pos'] != null ? (json['exchange_pos'] as List).map((i) => ExchangePo.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.exchange_pos != null) {
            data['exchange_pos'] = this.exchange_pos.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class ExchangePo {
    String available;
    String balance;
    String frozen;
    String symbol;
    String type;

    ExchangePo({this.available, this.balance, this.frozen, this.symbol, this.type});

    factory ExchangePo.fromJson(Map<String, dynamic> json) {
        return ExchangePo(
            available: json['available'], 
            balance: json['balance'], 
            frozen: json['frozen'], 
            symbol: json['symbol'], 
            type: json['type'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['available'] = this.available;
        data['balance'] = this.balance;
        data['frozen'] = this.frozen;
        data['symbol'] = this.symbol;
        data['type'] = this.type;
        return data;
    }
}