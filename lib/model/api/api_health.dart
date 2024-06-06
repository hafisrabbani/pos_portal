class ApiHealth{
  // status: true,
  // message: "Service Running normally"

  final bool status;
  final String message;

  ApiHealth({required this.status, required this.message});

  factory ApiHealth.fromJson(Map<String, dynamic> json) {
    return ApiHealth(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
    };
  }
}