class Result {
  bool success = false;
  String message = '';
  String data = '';
  String data2 = '';

  Result({
    this.success = false,
    this.message = '',
    this.data = '',
    this.data2 = '',
  });

  Result.fromJson(dynamic json) {
    success = json["success"];
    message = json["message"].toString();
    data = json["data"].toString();
    data2 = json["data2"].toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = success;
    map["message"] = message;
    map["data"] = data;
    map["data2"] = data2;
    return map;
  }

  @override
  String toString() {
    return 'Result{success: $success, message: $message, data: $data, data2: $data2}';
  }
}
