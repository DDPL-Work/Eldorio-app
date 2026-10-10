class AlertModel {
  final String id;
  final String to;
  final String title;
  final String body;
  final String bookingId;
  final String time;
  bool isRead;

  AlertModel({
    required this.id,
    required this.to,
    required this.title,
    required this.body,
    this.bookingId = '',
    required this.time,
    this.isRead = false,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      bookingId: json['bookingId']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      isRead: json['isRead'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'to': to,
    'title': title,
    'body': body,
    'bookingId': bookingId,
    'time': time,
    'isRead': isRead,
  };
}
