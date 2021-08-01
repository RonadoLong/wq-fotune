class Strategy {
  String userId;
  String strategyId;
  dynamic parentStrategyId;
  String apiKey;
  String platform;
  dynamic balance;
  dynamic status;
  dynamic validity;

  Strategy(
      {this.userId,
      this.strategyId,
      this.parentStrategyId,
      this.apiKey,
      this.platform,
      this.balance,
      this.status,
      this.validity});

  Strategy.fromJson(Map<String, dynamic> json) {
    this.userId = json['user_id'];
    this.strategyId = json['strategy_id'];
    this.parentStrategyId = json['parent_strategy_id'];
    this.apiKey = json['api_key'];
    this.platform = json['platform'];
    this.balance = json['balance'];
    this.status = json['status'];
    this.validity = json['validity'];
  }
}
