
class UserInfoResp {
  String msg;
  var code;
  UserInfo data;

  UserInfoResp({
    this.msg,
    this.code,
    this.data,
  });

  UserInfoResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = UserInfo.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.data.toJson();
    return data;
  }
}

class UserInfo {
  String userId;
  String token;
  String invitationCode;
  String phone;
  String name;
  String avatar;

  UserInfo({
    this.userId,
    this.token,
    this.invitationCode,
    this.phone,
    this.name,
    this.avatar,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    this.userId = json['user_id'];
    this.token = json['token'];
    this.invitationCode = json['invitation_code'];
    this.phone = json['phone'];
    this.name = json['name'];
    this.avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['token'] = this.token;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['invitation_code'] = this.invitationCode;
    data['avatar'] = this.avatar;
    return data;
  }
}
