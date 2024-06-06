class Webhook{
  String? webhookUrl;

  Webhook({this.webhookUrl});

  Webhook.fromJson(Map<String, dynamic> json) {
    webhookUrl = json['data']['webhook_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['webhook_url'] = this.webhookUrl;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'webhook_url': webhookUrl,
    };
  }
}