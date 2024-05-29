class RespPayment {
  String? message;
  Data? data;
  String? webhookUrl;

  RespPayment({this.message, this.data, this.webhookUrl});

  RespPayment.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    webhookUrl = json['webhook_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['webhook_url'] = this.webhookUrl;
    return data;
  }
}

class Data {
  String? reference;
  int? merchantRef;
  String? paymentSelectionType;
  String? paymentMethod;
  String? paymentName;
  String? customerName;
  String? customerEmail;
  Null? customerPhone;
  String? callbackUrl;
  Null? returnUrl;
  int? amount;
  int? feeMerchant;
  int? feeCustomer;
  int? totalFee;
  int? amountReceived;
  Null? payCode;
  Null? payUrl;
  String? checkoutUrl;
  String? status;
  int? expiredTime;
  List<OrderItems>? orderItems;
  List<Instructions>? instructions;
  String? qrString;
  String? qrUrl;

  Data(
      {this.reference,
        this.merchantRef,
        this.paymentSelectionType,
        this.paymentMethod,
        this.paymentName,
        this.customerName,
        this.customerEmail,
        this.customerPhone,
        this.callbackUrl,
        this.returnUrl,
        this.amount,
        this.feeMerchant,
        this.feeCustomer,
        this.totalFee,
        this.amountReceived,
        this.payCode,
        this.payUrl,
        this.checkoutUrl,
        this.status,
        this.expiredTime,
        this.orderItems,
        this.instructions,
        this.qrString,
        this.qrUrl});

  Data.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    merchantRef = json['merchant_ref'];
    paymentSelectionType = json['payment_selection_type'];
    paymentMethod = json['payment_method'];
    paymentName = json['payment_name'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerPhone = json['customer_phone'];
    callbackUrl = json['callback_url'];
    returnUrl = json['return_url'];
    amount = json['amount'];
    feeMerchant = json['fee_merchant'];
    feeCustomer = json['fee_customer'];
    totalFee = json['total_fee'];
    amountReceived = json['amount_received'];
    payCode = json['pay_code'];
    payUrl = json['pay_url'];
    checkoutUrl = json['checkout_url'];
    status = json['status'];
    expiredTime = json['expired_time'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    if (json['instructions'] != null) {
      instructions = <Instructions>[];
      json['instructions'].forEach((v) {
        instructions!.add(new Instructions.fromJson(v));
      });
    }
    qrString = json['qr_string'];
    qrUrl = json['qr_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    data['merchant_ref'] = this.merchantRef;
    data['payment_selection_type'] = this.paymentSelectionType;
    data['payment_method'] = this.paymentMethod;
    data['payment_name'] = this.paymentName;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone'] = this.customerPhone;
    data['callback_url'] = this.callbackUrl;
    data['return_url'] = this.returnUrl;
    data['amount'] = this.amount;
    data['fee_merchant'] = this.feeMerchant;
    data['fee_customer'] = this.feeCustomer;
    data['total_fee'] = this.totalFee;
    data['amount_received'] = this.amountReceived;
    data['pay_code'] = this.payCode;
    data['pay_url'] = this.payUrl;
    data['checkout_url'] = this.checkoutUrl;
    data['status'] = this.status;
    data['expired_time'] = this.expiredTime;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.map((v) => v.toJson()).toList();
    }
    data['qr_string'] = this.qrString;
    data['qr_url'] = this.qrUrl;
    return data;
  }
}

class OrderItems {
  String? sku;
  String? name;
  int? price;
  int? quantity;
  int? subtotal;
  Null? productUrl;
  Null? imageUrl;

  OrderItems(
      {this.sku,
        this.name,
        this.price,
        this.quantity,
        this.subtotal,
        this.productUrl,
        this.imageUrl});

  OrderItems.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    subtotal = json['subtotal'];
    productUrl = json['product_url'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['subtotal'] = this.subtotal;
    data['product_url'] = this.productUrl;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Instructions {
  String? title;
  List<String>? steps;

  Instructions({this.title, this.steps});

  Instructions.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    steps = json['steps'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['steps'] = this.steps;
    return data;
  }
}
