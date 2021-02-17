class MessageModel {
  final String message;
  final String res;
  final String personId;
  final DateTime time;
  final int type;
  final String fcmToken;

  MessageModel(
      {this.message,
      this.res,
      this.personId,
      this.time,
      this.type,
      this.fcmToken});

  Map<String, dynamic> get getMap {
    return {
      "message": message,
      "res": res,
      "personId": personId,
      "time": time,
      "type": type,
      "fcmToken": fcmToken
    };
  }
}
