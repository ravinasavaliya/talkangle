import 'dart:convert';

UserDetailsResponseModel userDetailsResponseModelFromJson(String str) => UserDetailsResponseModel.fromJson(json.decode(str));

String userDetailsResponseModelToJson(UserDetailsResponseModel data) => json.encode(data.toJson());

class UserDetailsResponseModel {
  int? status;
  bool? success;
  Data? data;

  UserDetailsResponseModel({
    this.status,
    this.success,
    this.data,
  });

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) => UserDetailsResponseModel(
        status: json["status"],
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  TalkAngelWallet? talkAngelWallet;
  String? id;
  String? name;
  String? userName;
  int? mobileNumber;
  int? countryCode;
  String? referCode;
  int? referCodeStatus;
  String? image;
  int? status;
  String? role;
  int? logOut;
  int? v;
  String? fcmToken;

  Data({
    this.talkAngelWallet,
    this.id,
    this.name,
    this.userName,
    this.mobileNumber,
    this.countryCode,
    this.referCode,
    this.referCodeStatus,
    this.image,
    this.status,
    this.role,
    this.logOut,
    this.v,
    this.fcmToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        talkAngelWallet: json["talk_angel_wallet"] == null ? null : TalkAngelWallet.fromJson(json["talk_angel_wallet"]),
        id: json["_id"],
        name: json["name"],
        userName: json["user_name"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        referCode: json["refer_code"],
        referCodeStatus: json["refer_code_status"],
        image: json["image"],
        status: json["status"],
        role: json["role"],
        logOut: json["log_out"],
        v: json["__v"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "talk_angel_wallet": talkAngelWallet?.toJson(),
        "_id": id,
        "name": name,
        "user_name": userName,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "refer_code": referCode,
        "refer_code_status": referCodeStatus,
        "image": image,
        "status": status,
        "role": role,
        "log_out": logOut,
        "__v": v,
        "fcmToken": fcmToken,
      };
}

class TalkAngelWallet {
  double? totalBallance;
  List<Transection>? transections;

  TalkAngelWallet({
    this.totalBallance,
    this.transections,
  });

  factory TalkAngelWallet.fromJson(Map<String, dynamic> json) => TalkAngelWallet(
        totalBallance: json["total_ballance"].toDouble(),
        transections: json["transections"] == null ? [] : List<Transection>.from(json["transections"]!.map((x) => Transection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_ballance": totalBallance,
        "transections": transections == null ? [] : List<dynamic>.from(transections!.map((x) => x.toJson())),
      };
}

class Transection {
  double? amount;
  String? paymentId;
  String? type;
  String? status;
  double? curentBellance;
  DateTime? date;
  List<PaymentDetail>? paymentDetails;
  String? id;

  Transection({
    this.amount,
    this.paymentId,
    this.type,
    this.status,
    this.curentBellance,
    this.date,
    this.paymentDetails,
    this.id,
  });

  factory Transection.fromJson(Map<String, dynamic> json) => Transection(
        amount: json["amount"]?.toDouble(),
        paymentId: json["payment_id"],
        type: json["type"],
        status: json["status"],
        curentBellance: json["curent_bellance"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        paymentDetails:
            json["payment_details"] == null ? [] : List<PaymentDetail>.from(json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "payment_id": paymentId,
        "type": type,
        "status": status,
        "curent_bellance": curentBellance,
        "date": date?.toIso8601String(),
        "payment_details": paymentDetails == null ? [] : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "_id": id,
      };
}

class PaymentDetail {
  dynamic authId;
  dynamic authorization;
  dynamic bankReference;
  dynamic cfPaymentId;
  String? entity;
  dynamic errorDetails;
  bool? isCaptured;
  int? orderAmount;
  String? orderId;
  int? paymentAmount;
  DateTime? paymentCompletionTime;
  String? paymentCurrency;
  PaymentGatewayDetails? paymentGatewayDetails;
  String? paymentGroup;
  dynamic paymentMessage;
  PaymentMethod? paymentMethod;
  List<dynamic>? paymentOffers;
  String? paymentStatus;
  DateTime? paymentTime;

  PaymentDetail({
    this.authId,
    this.authorization,
    this.bankReference,
    this.cfPaymentId,
    this.entity,
    this.errorDetails,
    this.isCaptured,
    this.orderAmount,
    this.orderId,
    this.paymentAmount,
    this.paymentCompletionTime,
    this.paymentCurrency,
    this.paymentGatewayDetails,
    this.paymentGroup,
    this.paymentMessage,
    this.paymentMethod,
    this.paymentOffers,
    this.paymentStatus,
    this.paymentTime,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        authId: json["auth_id"],
        authorization: json["authorization"],
        bankReference: json["bank_reference"],
        cfPaymentId: json["cf_payment_id"],
        entity: json["entity"],
        errorDetails: json["error_details"],
        isCaptured: json["is_captured"],
        orderAmount: json["order_amount"],
        orderId: json["order_id"],
        paymentAmount: json["payment_amount"],
        paymentCompletionTime: json["payment_completion_time"] == null ? null : DateTime.parse(json["payment_completion_time"]),
        paymentCurrency: json["payment_currency"],
        paymentGatewayDetails:
            json["payment_gateway_details"] == null ? null : PaymentGatewayDetails.fromJson(json["payment_gateway_details"]),
        paymentGroup: json["payment_group"],
        paymentMessage: json["payment_message"],
        paymentMethod: json["payment_method"] == null ? null : PaymentMethod.fromJson(json["payment_method"]),
        paymentOffers: json["payment_offers"] == null ? [] : List<dynamic>.from(json["payment_offers"]!.map((x) => x)),
        paymentStatus: json["payment_status"],
        paymentTime: json["payment_time"] == null ? null : DateTime.parse(json["payment_time"]),
      );

  Map<String, dynamic> toJson() => {
        "auth_id": authId,
        "authorization": authorization,
        "bank_reference": bankReference,
        "cf_payment_id": cfPaymentId,
        "entity": entity,
        "error_details": errorDetails,
        "is_captured": isCaptured,
        "order_amount": orderAmount,
        "order_id": orderId,
        "payment_amount": paymentAmount,
        "payment_completion_time": paymentCompletionTime?.toIso8601String(),
        "payment_currency": paymentCurrency,
        "payment_gateway_details": paymentGatewayDetails?.toJson(),
        "payment_group": paymentGroup,
        "payment_message": paymentMessage,
        "payment_method": paymentMethod?.toJson(),
        "payment_offers": paymentOffers == null ? [] : List<dynamic>.from(paymentOffers!.map((x) => x)),
        "payment_status": paymentStatus,
        "payment_time": paymentTime?.toIso8601String(),
      };
}

class PaymentGatewayDetails {
  String? gatewayName;
  String? gatewayOrderId;
  String? gatewayPaymentId;
  String? gatewayOrderReferenceId;
  String? gatewayStatusCode;
  String? gatewaySettlement;

  PaymentGatewayDetails({
    this.gatewayName,
    this.gatewayOrderId,
    this.gatewayPaymentId,
    this.gatewayOrderReferenceId,
    this.gatewayStatusCode,
    this.gatewaySettlement,
  });

  factory PaymentGatewayDetails.fromJson(Map<String, dynamic> json) => PaymentGatewayDetails(
        gatewayName: json["gateway_name"],
        gatewayOrderId: json["gateway_order_id"],
        gatewayPaymentId: json["gateway_payment_id"],
        gatewayOrderReferenceId: json["gateway_order_reference_id"],
        gatewayStatusCode: json["gateway_status_code"],
        gatewaySettlement: json["gateway_settlement"],
      );

  Map<String, dynamic> toJson() => {
        "gateway_name": gatewayName,
        "gateway_order_id": gatewayOrderId,
        "gateway_payment_id": gatewayPaymentId,
        "gateway_order_reference_id": gatewayOrderReferenceId,
        "gateway_status_code": gatewayStatusCode,
        "gateway_settlement": gatewaySettlement,
      };
}

class PaymentMethod {
  App? app;

  PaymentMethod({
    this.app,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        app: json["app"] == null ? null : App.fromJson(json["app"]),
      );

  Map<String, dynamic> toJson() => {
        "app": app?.toJson(),
      };
}

class App {
  String? channel;
  String? phone;
  String? provider;

  App({
    this.channel,
    this.phone,
    this.provider,
  });

  factory App.fromJson(Map<String, dynamic> json) => App(
        channel: json["channel"],
        phone: json["phone"],
        provider: json["provider"],
      );

  Map<String, dynamic> toJson() => {
        "channel": channel,
        "phone": phone,
        "provider": provider,
      };
}

///
///
///
///
// To parse this JSON data, do
//
//     final userDetailsResponseModel = userDetailsResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// UserDetailsResponseModel userDetailsResponseModelFromJson(String str) => UserDetailsResponseModel.fromJson(json.decode(str));
//
// String userDetailsResponseModelToJson(UserDetailsResponseModel data) => json.encode(data.toJson());
//
// class UserDetailsResponseModel {
//   int? status;
//   bool? success;
//   Data? data;
//
//   UserDetailsResponseModel({
//     this.status,
//     this.success,
//     this.data,
//   });
//
//   factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) => UserDetailsResponseModel(
//         status: json["status"],
//         success: json["success"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "success": success,
//         "data": data?.toJson(),
//       };
// }
//
// class Data {
//   TalkAngelWallet? talkAngelWallet;
//   String? id;
//   String? name;
//   String? userName;
//   int? mobileNumber;
//   int? countryCode;
//   String? referCode;
//   int? referCodeStatus;
//   String? image;
//   int? status;
//   String? role;
//   int? logOut;
//   int? v;
//   String? fcmToken;
//
//   Data({
//     this.talkAngelWallet,
//     this.id,
//     this.name,
//     this.userName,
//     this.mobileNumber,
//     this.countryCode,
//     this.referCode,
//     this.referCodeStatus,
//     this.image,
//     this.status,
//     this.role,
//     this.logOut,
//     this.v,
//     this.fcmToken,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         talkAngelWallet: json["talk_angel_wallet"] == null ? null : TalkAngelWallet.fromJson(json["talk_angel_wallet"]),
//         id: json["_id"],
//         name: json["name"],
//         userName: json["user_name"],
//         mobileNumber: json["mobile_number"],
//         countryCode: json["country_code"],
//         referCode: json["refer_code"],
//         referCodeStatus: json["refer_code_status"],
//         image: json["image"],
//         status: json["status"],
//         role: json["role"],
//         logOut: json["log_out"],
//         v: json["__v"],
//         fcmToken: json["fcmToken"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "talk_angel_wallet": talkAngelWallet?.toJson(),
//         "_id": id,
//         "name": name,
//         "user_name": userName,
//         "mobile_number": mobileNumber,
//         "country_code": countryCode,
//         "refer_code": referCode,
//         "refer_code_status": referCodeStatus,
//         "image": image,
//         "status": status,
//         "role": role,
//         "log_out": logOut,
//         "__v": v,
//         "fcmToken": fcmToken,
//       };
// }
//
// class TalkAngelWallet {
//   int? totalBallance;
//   List<Transection>? transections;
//
//   TalkAngelWallet({
//     this.totalBallance,
//     this.transections,
//   });
//
//   factory TalkAngelWallet.fromJson(Map<String, dynamic> json) => TalkAngelWallet(
//         totalBallance: json["total_ballance"],
//         transections: json["transections"] == null ? [] : List<Transection>.from(json["transections"]!.map((x) => Transection.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "total_ballance": totalBallance,
//         "transections": transections == null ? [] : List<dynamic>.from(transections!.map((x) => x.toJson())),
//       };
// }
//
// class Transection {
//   String? status;
//   double? amount;
//   String? paymentId;
//   Type? type;
//   int? curentBellance;
//   DateTime? date;
//   String? id;
//   List<PaymentDetail>? paymentDetails;
//
//   Transection({
//     this.status,
//     this.amount,
//     this.paymentId,
//     this.type,
//     this.curentBellance,
//     this.date,
//     this.id,
//     this.paymentDetails,
//   });
//
//   factory Transection.fromJson(Map<String, dynamic> json) => Transection(
//         status: json["status"],
//         amount: json["amount"]?.toDouble(),
//         paymentId: json["payment_id"],
//         type: typeValues.map[json["type"]]!,
//         curentBellance: json["curent_bellance"],
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//         id: json["_id"],
//         paymentDetails:
//             json["payment_details"] == null ? [] : List<PaymentDetail>.from(json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "amount": amount,
//         "payment_id": paymentId,
//         "type": typeValues.reverse[type],
//         "curent_bellance": curentBellance,
//         "date": date?.toIso8601String(),
//         "_id": id,
//         "payment_details": paymentDetails == null ? [] : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
//       };
// }
//
// class PaymentDetail {
//   dynamic authId;
//   dynamic authorization;
//   String? bankReference;
//   String? cfPaymentId;
//   Entity? entity;
//   dynamic errorDetails;
//   bool? isCaptured;
//   int? orderAmount;
//   String? orderId;
//   int? paymentAmount;
//   DateTime? paymentCompletionTime;
//   PaymentCurrency? paymentCurrency;
//   PaymentGatewayDetails? paymentGatewayDetails;
//   PaymentGroup? paymentGroup;
//   String? paymentMessage;
//   PaymentMethod? paymentMethod;
//   List<dynamic>? paymentOffers;
//   PaymentStatus? paymentStatus;
//   DateTime? paymentTime;
//
//   PaymentDetail({
//     this.authId,
//     this.authorization,
//     this.bankReference,
//     this.cfPaymentId,
//     this.entity,
//     this.errorDetails,
//     this.isCaptured,
//     this.orderAmount,
//     this.orderId,
//     this.paymentAmount,
//     this.paymentCompletionTime,
//     this.paymentCurrency,
//     this.paymentGatewayDetails,
//     this.paymentGroup,
//     this.paymentMessage,
//     this.paymentMethod,
//     this.paymentOffers,
//     this.paymentStatus,
//     this.paymentTime,
//   });
//
//   factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
//         authId: json["auth_id"],
//         authorization: json["authorization"],
//         bankReference: json["bank_reference"],
//         cfPaymentId: json["cf_payment_id"],
//         entity: entityValues.map[json["entity"]]!,
//         errorDetails: json["error_details"],
//         isCaptured: json["is_captured"],
//         orderAmount: json["order_amount"],
//         orderId: json["order_id"],
//         paymentAmount: json["payment_amount"],
//         paymentCompletionTime: json["payment_completion_time"] == null ? null : DateTime.parse(json["payment_completion_time"]),
//         paymentCurrency: paymentCurrencyValues.map[json["payment_currency"]]!,
//         paymentGatewayDetails:
//             json["payment_gateway_details"] == null ? null : PaymentGatewayDetails.fromJson(json["payment_gateway_details"]),
//         paymentGroup: paymentGroupValues.map[json["payment_group"]]!,
//         paymentMessage: json["payment_message"],
//         paymentMethod: json["payment_method"] == null ? null : PaymentMethod.fromJson(json["payment_method"]),
//         paymentOffers: json["payment_offers"] == null ? [] : List<dynamic>.from(json["payment_offers"]!.map((x) => x)),
//         paymentStatus: paymentStatusValues.map[json["payment_status"]]!,
//         paymentTime: json["payment_time"] == null ? null : DateTime.parse(json["payment_time"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "auth_id": authId,
//         "authorization": authorization,
//         "bank_reference": bankReference,
//         "cf_payment_id": cfPaymentId,
//         "entity": entityValues.reverse[entity],
//         "error_details": errorDetails,
//         "is_captured": isCaptured,
//         "order_amount": orderAmount,
//         "order_id": orderId,
//         "payment_amount": paymentAmount,
//         "payment_completion_time": paymentCompletionTime?.toIso8601String(),
//         "payment_currency": paymentCurrencyValues.reverse[paymentCurrency],
//         "payment_gateway_details": paymentGatewayDetails?.toJson(),
//         "payment_group": paymentGroupValues.reverse[paymentGroup],
//         "payment_message": paymentMessage,
//         "payment_method": paymentMethod?.toJson(),
//         "payment_offers": paymentOffers == null ? [] : List<dynamic>.from(paymentOffers!.map((x) => x)),
//         "payment_status": paymentStatusValues.reverse[paymentStatus],
//         "payment_time": paymentTime?.toIso8601String(),
//       };
// }
//
// enum Entity { PAYMENT }
//
// final entityValues = EnumValues({"payment": Entity.PAYMENT});
//
// enum PaymentCurrency { INR }
//
// final paymentCurrencyValues = EnumValues({"INR": PaymentCurrency.INR});
//
// class PaymentGatewayDetails {
//   GatewayName? gatewayName;
//   String? gatewayOrderId;
//   String? gatewayPaymentId;
//   String? gatewayOrderReferenceId;
//   String? gatewayStatusCode;
//   String? gatewaySettlement;
//
//   PaymentGatewayDetails({
//     this.gatewayName,
//     this.gatewayOrderId,
//     this.gatewayPaymentId,
//     this.gatewayOrderReferenceId,
//     this.gatewayStatusCode,
//     this.gatewaySettlement,
//   });
//
//   factory PaymentGatewayDetails.fromJson(Map<String, dynamic> json) => PaymentGatewayDetails(
//         gatewayName: gatewayNameValues.map[json["gateway_name"]]!,
//         gatewayOrderId: json["gateway_order_id"],
//         gatewayPaymentId: json["gateway_payment_id"],
//         gatewayOrderReferenceId: json["gateway_order_reference_id"],
//         gatewayStatusCode: json["gateway_status_code"],
//         gatewaySettlement: json["gateway_settlement"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "gateway_name": gatewayNameValues.reverse[gatewayName],
//         "gateway_order_id": gatewayOrderId,
//         "gateway_payment_id": gatewayPaymentId,
//         "gateway_order_reference_id": gatewayOrderReferenceId,
//         "gateway_status_code": gatewayStatusCode,
//         "gateway_settlement": gatewaySettlement,
//       };
// }
//
// enum GatewayName { CASHFREE }
//
// final gatewayNameValues = EnumValues({"CASHFREE": GatewayName.CASHFREE});
//
// enum PaymentGroup { DEBIT_CARD, NET_BANKING, UPI }
//
// final paymentGroupValues =
//     EnumValues({"debit_card": PaymentGroup.DEBIT_CARD, "net_banking": PaymentGroup.NET_BANKING, "upi": PaymentGroup.UPI});
//
// class PaymentMethod {
//   Card? card;
//   Upi? upi;
//   Netbanking? netbanking;
//
//   PaymentMethod({
//     this.card,
//     this.upi,
//     this.netbanking,
//   });
//
//   factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
//         card: json["card"] == null ? null : Card.fromJson(json["card"]),
//         upi: json["upi"] == null ? null : Upi.fromJson(json["upi"]),
//         netbanking: json["netbanking"] == null ? null : Netbanking.fromJson(json["netbanking"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "card": card?.toJson(),
//         "upi": upi?.toJson(),
//         "netbanking": netbanking?.toJson(),
//       };
// }
//
// class Card {
//   Channel? channel;
//   CardNumber? cardNumber;
//   CardNetwork? cardNetwork;
//   PaymentGroup? cardType;
//   CardCountry? cardCountry;
//   CardBankName? cardBankName;
//   dynamic cardNetworkReferenceId;
//   CardSubType? cardSubType;
//
//   Card({
//     this.channel,
//     this.cardNumber,
//     this.cardNetwork,
//     this.cardType,
//     this.cardCountry,
//     this.cardBankName,
//     this.cardNetworkReferenceId,
//     this.cardSubType,
//   });
//
//   factory Card.fromJson(Map<String, dynamic> json) => Card(
//         channel: channelValues.map[json["channel"]]!,
//         cardNumber: cardNumberValues.map[json["card_number"]]!,
//         cardNetwork: cardNetworkValues.map[json["card_network"]]!,
//         cardType: paymentGroupValues.map[json["card_type"]]!,
//         cardCountry: cardCountryValues.map[json["card_country"]]!,
//         cardBankName: cardBankNameValues.map[json["card_bank_name"]]!,
//         cardNetworkReferenceId: json["card_network_reference_id"],
//         cardSubType: cardSubTypeValues.map[json["card_sub_type"]]!,
//       );
//
//   Map<String, dynamic> toJson() => {
//         "channel": channelValues.reverse[channel],
//         "card_number": cardNumberValues.reverse[cardNumber],
//         "card_network": cardNetworkValues.reverse[cardNetwork],
//         "card_type": paymentGroupValues.reverse[cardType],
//         "card_country": cardCountryValues.reverse[cardCountry],
//         "card_bank_name": cardBankNameValues.reverse[cardBankName],
//         "card_network_reference_id": cardNetworkReferenceId,
//         "card_sub_type": cardSubTypeValues.reverse[cardSubType],
//       };
// }
//
// enum CardBankName { HDFC_BANK, KOTAK_MAHINDRA_BANK, WORLD_DEBIT_MASTERCARD_REWARDS }
//
// final cardBankNameValues = EnumValues({
//   "HDFC BANK": CardBankName.HDFC_BANK,
//   "KOTAK MAHINDRA BANK": CardBankName.KOTAK_MAHINDRA_BANK,
//   "WORLD DEBIT MASTERCARD REWARDS": CardBankName.WORLD_DEBIT_MASTERCARD_REWARDS
// });
//
// enum CardCountry { IN }
//
// final cardCountryValues = EnumValues({"IN": CardCountry.IN});
//
// enum CardNetwork { MASTERCARD, RUPAY, VISA }
//
// final cardNetworkValues = EnumValues({"mastercard": CardNetwork.MASTERCARD, "rupay": CardNetwork.RUPAY, "visa": CardNetwork.VISA});
//
// enum CardNumber { XXXXXXXXXXXX1034, XXXXXXXXXXXX2123, XXXXXXXXXXXX3818 }
//
// final cardNumberValues = EnumValues({
//   "XXXXXXXXXXXX1034": CardNumber.XXXXXXXXXXXX1034,
//   "XXXXXXXXXXXX2123": CardNumber.XXXXXXXXXXXX2123,
//   "XXXXXXXXXXXX3818": CardNumber.XXXXXXXXXXXX3818
// });
//
// enum CardSubType { R }
//
// final cardSubTypeValues = EnumValues({"R": CardSubType.R});
//
// enum Channel { LINK }
//
// final channelValues = EnumValues({"link": Channel.LINK});
//
// class Netbanking {
//   Channel? channel;
//   int? netbankingBankCode;
//   String? netbankingBankName;
//   String? netbankingIfsc;
//   String? netbankingAccountNumber;
//
//   Netbanking({
//     this.channel,
//     this.netbankingBankCode,
//     this.netbankingBankName,
//     this.netbankingIfsc,
//     this.netbankingAccountNumber,
//   });
//
//   factory Netbanking.fromJson(Map<String, dynamic> json) => Netbanking(
//         channel: channelValues.map[json["channel"]]!,
//         netbankingBankCode: json["netbanking_bank_code"],
//         netbankingBankName: json["netbanking_bank_name"],
//         netbankingIfsc: json["netbanking_ifsc"],
//         netbankingAccountNumber: json["netbanking_account_number"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "channel": channelValues.reverse[channel],
//         "netbanking_bank_code": netbankingBankCode,
//         "netbanking_bank_name": netbankingBankName,
//         "netbanking_ifsc": netbankingIfsc,
//         "netbanking_account_number": netbankingAccountNumber,
//       };
// }
//
// class Upi {
//   String? channel;
//   String? upiId;
//
//   Upi({
//     this.channel,
//     this.upiId,
//   });
//
//   factory Upi.fromJson(Map<String, dynamic> json) => Upi(
//         channel: json["channel"],
//         upiId: json["upi_id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "channel": channel,
//         "upi_id": upiId,
//       };
// }
//
// enum PaymentStatus { NOT_ATTEMPTED, SUCCESS }
//
// final paymentStatusValues = EnumValues({"NOT_ATTEMPTED": PaymentStatus.NOT_ATTEMPTED, "SUCCESS": PaymentStatus.SUCCESS});
//
// enum Type { CREDIT }
//
// final typeValues = EnumValues({"credit": Type.CREDIT});
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
/// OLD CODE

// // import 'dart:convert';
// //
// // UserDetailsResponseModel userDetailsResponseModelFromJson(String str) =>
// //     UserDetailsResponseModel.fromJson(json.decode(str));
// //
// // String userDetailsResponseModelToJson(UserDetailsResponseModel data) => json.encode(data.toJson());
// //
// // class UserDetailsResponseModel {
// //   int? status;
// //   bool? success;
// //   Data? data;
// //
// //   UserDetailsResponseModel({
// //     this.status,
// //     this.success,
// //     this.data,
// //   });
// //
// //   factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) => UserDetailsResponseModel(
// //         status: json["status"],
// //         success: json["success"],
// //         data: json["data"] == null ? null : Data.fromJson(json["data"]),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "status": status,
// //         "success": success,
// //         "data": data?.toJson(),
// //       };
// // }
// //
// // class Data {
// //   TalkAngelWallet? talkAngelWallet;
// //   String? id;
// //   String? name;
// //   String? userName;
// //   int? mobileNumber;
// //   int? countryCode;
// //   String? referCode;
// //   int? referCodeStatus;
// //   String? image;
// //   int? status;
// //   String? role;
// //   int? v;
// //   String? fcmToken;
// //
// //   Data({
// //     this.talkAngelWallet,
// //     this.id,
// //     this.name,
// //     this.userName,
// //     this.mobileNumber,
// //     this.countryCode,
// //     this.referCode,
// //     this.referCodeStatus,
// //     this.image,
// //     this.status,
// //     this.role,
// //     this.v,
// //     this.fcmToken,
// //   });
// //
// //   factory Data.fromJson(Map<String, dynamic> json) => Data(
// //         talkAngelWallet: json["talk_angel_wallet"] == null ? null : TalkAngelWallet.fromJson(json["talk_angel_wallet"]),
// //         id: json["_id"],
// //         name: json["name"],
// //         userName: json["user_name"],
// //         mobileNumber: json["mobile_number"],
// //         countryCode: json["country_code"],
// //         referCode: json["refer_code"],
// //         referCodeStatus: json["refer_code_status"],
// //         image: json["image"],
// //         status: json["status"],
// //         role: json["role"],
// //         v: json["__v"],
// //         fcmToken: json["fcmToken"],
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "talk_angel_wallet": talkAngelWallet?.toJson(),
// //         "_id": id,
// //         "name": name,
// //         "user_name": userName,
// //         "mobile_number": mobileNumber,
// //         "country_code": countryCode,
// //         "refer_code": referCode,
// //         "refer_code_status": referCodeStatus,
// //         "image": image,
// //         "status": status,
// //         "role": role,
// //         "__v": v,
// //         "fcmToken": fcmToken,
// //       };
// // }
// //
// // class TalkAngelWallet {
// //   double? totalBallance;
// //   List<Transection>? transections;
// //
// //   TalkAngelWallet({
// //     this.totalBallance,
// //     this.transections,
// //   });
// //
// //   factory TalkAngelWallet.fromJson(Map<String, dynamic> json) => TalkAngelWallet(
// //         totalBallance: json["total_ballance"]?.toDouble(),
// //         transections: json["transections"] == null
// //             ? []
// //             : List<Transection>.from(json["transections"]!.map((x) => Transection.fromJson(x))),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "total_ballance": totalBallance,
// //         "transections": transections == null ? [] : List<dynamic>.from(transections!.map((x) => x.toJson())),
// //       };
// // }
// //
// // class Transection {
// //   double? amount;
// //   String? paymentId;
// //   String? type;
// //   double? curentBellance;
// //   DateTime? date;
// //   String? id;
// //
// //   Transection({
// //     this.amount,
// //     this.paymentId,
// //     this.type,
// //     this.curentBellance,
// //     this.date,
// //     this.id,
// //   });
// //
// //   factory Transection.fromJson(Map<String, dynamic> json) => Transection(
// //         amount: json["amount"]?.toDouble(),
// //         paymentId: json["payment_id"],
// //         type: json["type"],
// //         curentBellance: json["curent_bellance"]?.toDouble(),
// //         date: json["date"] == null ? null : DateTime.parse(json["date"]),
// //         id: json["_id"],
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "amount": amount,
// //         "payment_id": paymentId,
// //         "type": type,
// //         "curent_bellance": curentBellance,
// //         "date": date?.toIso8601String(),
// //         "_id": id,
// //       };
// // }
//
// // To parse this JSON data, do
// //
// //     final userDetailsResponseModel = userDetailsResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// UserDetailsResponseModel userDetailsResponseModelFromJson(String str) => UserDetailsResponseModel.fromJson(json.decode(str));
//
// String userDetailsResponseModelToJson(UserDetailsResponseModel data) => json.encode(data.toJson());
//
// class UserDetailsResponseModel {
//   int? status;
//   bool? success;
//   Data? data;
//
//   UserDetailsResponseModel({
//     this.status,
//     this.success,
//     this.data,
//   });
//
//   factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) => UserDetailsResponseModel(
//         status: json["status"],
//         success: json["success"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "success": success,
//         "data": data?.toJson(),
//       };
// }
//
// class Data {
//   TalkAngelWallet? talkAngelWallet;
//   String? id;
//   String? name;
//   String? userName;
//   int? mobileNumber;
//   int? countryCode;
//   String? referCode;
//   int? referCodeStatus;
//   String? image;
//   int? status;
//   String? role;
//   int? logOut;
//   int? v;
//   String? fcmToken;
//
//   Data({
//     this.talkAngelWallet,
//     this.id,
//     this.name,
//     this.userName,
//     this.mobileNumber,
//     this.countryCode,
//     this.referCode,
//     this.referCodeStatus,
//     this.image,
//     this.status,
//     this.role,
//     this.logOut,
//     this.v,
//     this.fcmToken,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         talkAngelWallet: json["talk_angel_wallet"] == null ? null : TalkAngelWallet.fromJson(json["talk_angel_wallet"]),
//         id: json["_id"],
//         name: json["name"],
//         userName: json["user_name"],
//         mobileNumber: json["mobile_number"],
//         countryCode: json["country_code"],
//         referCode: json["refer_code"],
//         referCodeStatus: json["refer_code_status"],
//         image: json["image"],
//         status: json["status"],
//         role: json["role"],
//         logOut: json["log_out"],
//         v: json["__v"],
//         fcmToken: json["fcmToken"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "talk_angel_wallet": talkAngelWallet?.toJson(),
//         "_id": id,
//         "name": name,
//         "user_name": userName,
//         "mobile_number": mobileNumber,
//         "country_code": countryCode,
//         "refer_code": referCode,
//         "refer_code_status": referCodeStatus,
//         "image": image,
//         "status": status,
//         "role": role,
//         "log_out": logOut,
//         "__v": v,
//         "fcmToken": fcmToken,
//       };
// }
//
// class TalkAngelWallet {
//   int? totalBallance;
//   List<Transection>? transections;
//
//   TalkAngelWallet({
//     this.totalBallance,
//     this.transections,
//   });
//
//   factory TalkAngelWallet.fromJson(Map<String, dynamic> json) => TalkAngelWallet(
//         totalBallance: json["total_ballance"],
//         transections: json["transections"] == null ? [] : List<Transection>.from(json["transections"]!.map((x) => Transection.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "total_ballance": totalBallance,
//         "transections": transections == null ? [] : List<dynamic>.from(transections!.map((x) => x.toJson())),
//       };
// }
//
// class Transection {
//   String? status;
//   int? amount;
//   String? paymentId;
//   Type? type;
//   int? curentBellance;
//   DateTime? date;
//   String? id;
//   List<PaymentDetail>? paymentDetails;
//
//   Transection({
//     this.status,
//     this.amount,
//     this.paymentId,
//     this.type,
//     this.curentBellance,
//     this.date,
//     this.id,
//     this.paymentDetails,
//   });
//
//   factory Transection.fromJson(Map<String, dynamic> json) => Transection(
//         status: json["status"],
//         amount: json["amount"],
//         paymentId: json["payment_id"],
//         type: typeValues.map[json["type"]]!,
//         curentBellance: json["curent_bellance"],
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//         id: json["_id"],
//         paymentDetails:
//             json["payment_details"] == null ? [] : List<PaymentDetail>.from(json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "amount": amount ?? 0.0,
//         "payment_id": paymentId,
//         "type": typeValues.reverse[type],
//         "curent_bellance": curentBellance,
//         "date": date?.toIso8601String(),
//         "_id": id,
//         "payment_details": paymentDetails == null ? [] : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
//       };
// }
//
// class PaymentDetail {
//   dynamic authId;
//   dynamic authorization;
//   String? bankReference;
//   String? cfPaymentId;
//   Entity? entity;
//   dynamic errorDetails;
//   bool? isCaptured;
//   int? orderAmount;
//   String? orderId;
//   int? paymentAmount;
//   DateTime? paymentCompletionTime;
//   PaymentCurrency? paymentCurrency;
//   PaymentGatewayDetails? paymentGatewayDetails;
//   PaymentGroup? paymentGroup;
//   String? paymentMessage;
//   PaymentMethod? paymentMethod;
//   List<dynamic>? paymentOffers;
//   PaymentStatus? paymentStatus;
//   DateTime? paymentTime;
//
//   PaymentDetail({
//     this.authId,
//     this.authorization,
//     this.bankReference,
//     this.cfPaymentId,
//     this.entity,
//     this.errorDetails,
//     this.isCaptured,
//     this.orderAmount,
//     this.orderId,
//     this.paymentAmount,
//     this.paymentCompletionTime,
//     this.paymentCurrency,
//     this.paymentGatewayDetails,
//     this.paymentGroup,
//     this.paymentMessage,
//     this.paymentMethod,
//     this.paymentOffers,
//     this.paymentStatus,
//     this.paymentTime,
//   });
//
//   factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
//         authId: json["auth_id"],
//         authorization: json["authorization"],
//         bankReference: json["bank_reference"],
//         cfPaymentId: json["cf_payment_id"],
//         entity: entityValues.map[json["entity"]]!,
//         errorDetails: json["error_details"],
//         isCaptured: json["is_captured"],
//         orderAmount: json["order_amount"],
//         orderId: json["order_id"],
//         paymentAmount: json["payment_amount"],
//         paymentCompletionTime: json["payment_completion_time"] == null ? null : DateTime.parse(json["payment_completion_time"]),
//         paymentCurrency: paymentCurrencyValues.map[json["payment_currency"]]!,
//         paymentGatewayDetails:
//             json["payment_gateway_details"] == null ? null : PaymentGatewayDetails.fromJson(json["payment_gateway_details"]),
//         paymentGroup: paymentGroupValues.map[json["payment_group"]]!,
//         paymentMessage: json["payment_message"],
//         paymentMethod: json["payment_method"] == null ? null : PaymentMethod.fromJson(json["payment_method"]),
//         paymentOffers: json["payment_offers"] == null ? [] : List<dynamic>.from(json["payment_offers"]!.map((x) => x)),
//         paymentStatus: paymentStatusValues.map[json["payment_status"]]!,
//         paymentTime: json["payment_time"] == null ? null : DateTime.parse(json["payment_time"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "auth_id": authId,
//         "authorization": authorization,
//         "bank_reference": bankReference,
//         "cf_payment_id": cfPaymentId,
//         "entity": entityValues.reverse[entity],
//         "error_details": errorDetails,
//         "is_captured": isCaptured,
//         "order_amount": orderAmount,
//         "order_id": orderId,
//         "payment_amount": paymentAmount,
//         "payment_completion_time": paymentCompletionTime?.toIso8601String(),
//         "payment_currency": paymentCurrencyValues.reverse[paymentCurrency],
//         "payment_gateway_details": paymentGatewayDetails?.toJson(),
//         "payment_group": paymentGroupValues.reverse[paymentGroup],
//         "payment_message": paymentMessage,
//         "payment_method": paymentMethod?.toJson(),
//         "payment_offers": paymentOffers == null ? [] : List<dynamic>.from(paymentOffers!.map((x) => x)),
//         "payment_status": paymentStatusValues.reverse[paymentStatus],
//         "payment_time": paymentTime?.toIso8601String(),
//       };
// }
//
// enum Entity { PAYMENT }
//
// final entityValues = EnumValues({"payment": Entity.PAYMENT});
//
// enum PaymentCurrency { INR }
//
// final paymentCurrencyValues = EnumValues({"INR": PaymentCurrency.INR});
//
// class PaymentGatewayDetails {
//   GatewayName? gatewayName;
//   String? gatewayOrderId;
//   String? gatewayPaymentId;
//   String? gatewayOrderReferenceId;
//   String? gatewayStatusCode;
//   String? gatewaySettlement;
//
//   PaymentGatewayDetails({
//     this.gatewayName,
//     this.gatewayOrderId,
//     this.gatewayPaymentId,
//     this.gatewayOrderReferenceId,
//     this.gatewayStatusCode,
//     this.gatewaySettlement,
//   });
//
//   factory PaymentGatewayDetails.fromJson(Map<String, dynamic> json) => PaymentGatewayDetails(
//         gatewayName: gatewayNameValues.map[json["gateway_name"]]!,
//         gatewayOrderId: json["gateway_order_id"],
//         gatewayPaymentId: json["gateway_payment_id"],
//         gatewayOrderReferenceId: json["gateway_order_reference_id"],
//         gatewayStatusCode: json["gateway_status_code"],
//         gatewaySettlement: json["gateway_settlement"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "gateway_name": gatewayNameValues.reverse[gatewayName],
//         "gateway_order_id": gatewayOrderId,
//         "gateway_payment_id": gatewayPaymentId,
//         "gateway_order_reference_id": gatewayOrderReferenceId,
//         "gateway_status_code": gatewayStatusCode,
//         "gateway_settlement": gatewaySettlement,
//       };
// }
//
// enum GatewayName { CASHFREE }
//
// final gatewayNameValues = EnumValues({"CASHFREE": GatewayName.CASHFREE});
//
// enum PaymentGroup { DEBIT_CARD, NET_BANKING, UPI }
//
// final paymentGroupValues =
//     EnumValues({"debit_card": PaymentGroup.DEBIT_CARD, "net_banking": PaymentGroup.NET_BANKING, "upi": PaymentGroup.UPI});
//
// class PaymentMethod {
//   Card? card;
//   Upi? upi;
//   Netbanking? netbanking;
//
//   PaymentMethod({
//     this.card,
//     this.upi,
//     this.netbanking,
//   });
//
//   factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
//         card: json["card"] == null ? null : Card.fromJson(json["card"]),
//         upi: json["upi"] == null ? null : Upi.fromJson(json["upi"]),
//         netbanking: json["netbanking"] == null ? null : Netbanking.fromJson(json["netbanking"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "card": card?.toJson(),
//         "upi": upi?.toJson(),
//         "netbanking": netbanking?.toJson(),
//       };
// }
//
// class Card {
//   Channel? channel;
//   CardNumber? cardNumber;
//   CardNetwork? cardNetwork;
//   PaymentGroup? cardType;
//   CardCountry? cardCountry;
//   CardBankName? cardBankName;
//   dynamic cardNetworkReferenceId;
//   CardSubType? cardSubType;
//
//   Card({
//     this.channel,
//     this.cardNumber,
//     this.cardNetwork,
//     this.cardType,
//     this.cardCountry,
//     this.cardBankName,
//     this.cardNetworkReferenceId,
//     this.cardSubType,
//   });
//
//   factory Card.fromJson(Map<String, dynamic> json) => Card(
//         channel: channelValues.map[json["channel"]]!,
//         cardNumber: cardNumberValues.map[json["card_number"]]!,
//         cardNetwork: cardNetworkValues.map[json["card_network"]]!,
//         cardType: paymentGroupValues.map[json["card_type"]]!,
//         cardCountry: cardCountryValues.map[json["card_country"]]!,
//         cardBankName: cardBankNameValues.map[json["card_bank_name"]]!,
//         cardNetworkReferenceId: json["card_network_reference_id"],
//         cardSubType: cardSubTypeValues.map[json["card_sub_type"]]!,
//       );
//
//   Map<String, dynamic> toJson() => {
//         "channel": channelValues.reverse[channel],
//         "card_number": cardNumberValues.reverse[cardNumber],
//         "card_network": cardNetworkValues.reverse[cardNetwork],
//         "card_type": paymentGroupValues.reverse[cardType],
//         "card_country": cardCountryValues.reverse[cardCountry],
//         "card_bank_name": cardBankNameValues.reverse[cardBankName],
//         "card_network_reference_id": cardNetworkReferenceId,
//         "card_sub_type": cardSubTypeValues.reverse[cardSubType],
//       };
// }
//
// enum CardBankName { HDFC_BANK, KOTAK_MAHINDRA_BANK, WORLD_DEBIT_MASTERCARD_REWARDS }
//
// final cardBankNameValues = EnumValues({
//   "HDFC BANK": CardBankName.HDFC_BANK,
//   "KOTAK MAHINDRA BANK": CardBankName.KOTAK_MAHINDRA_BANK,
//   "WORLD DEBIT MASTERCARD REWARDS": CardBankName.WORLD_DEBIT_MASTERCARD_REWARDS
// });
//
// enum CardCountry { IN }
//
// final cardCountryValues = EnumValues({"IN": CardCountry.IN});
//
// enum CardNetwork { MASTERCARD, RUPAY, VISA }
//
// final cardNetworkValues = EnumValues({"mastercard": CardNetwork.MASTERCARD, "rupay": CardNetwork.RUPAY, "visa": CardNetwork.VISA});
//
// enum CardNumber { XXXXXXXXXXXX1034, XXXXXXXXXXXX2123, XXXXXXXXXXXX3818 }
//
// final cardNumberValues = EnumValues({
//   "XXXXXXXXXXXX1034": CardNumber.XXXXXXXXXXXX1034,
//   "XXXXXXXXXXXX2123": CardNumber.XXXXXXXXXXXX2123,
//   "XXXXXXXXXXXX3818": CardNumber.XXXXXXXXXXXX3818
// });
//
// enum CardSubType { R }
//
// final cardSubTypeValues = EnumValues({"R": CardSubType.R});
//
// enum Channel { LINK }
//
// final channelValues = EnumValues({"link": Channel.LINK});
//
// class Netbanking {
//   Channel? channel;
//   int? netbankingBankCode;
//   String? netbankingBankName;
//   String? netbankingIfsc;
//   String? netbankingAccountNumber;
//
//   Netbanking({
//     this.channel,
//     this.netbankingBankCode,
//     this.netbankingBankName,
//     this.netbankingIfsc,
//     this.netbankingAccountNumber,
//   });
//
//   factory Netbanking.fromJson(Map<String, dynamic> json) => Netbanking(
//         channel: channelValues.map[json["channel"]]!,
//         netbankingBankCode: json["netbanking_bank_code"],
//         netbankingBankName: json["netbanking_bank_name"],
//         netbankingIfsc: json["netbanking_ifsc"],
//         netbankingAccountNumber: json["netbanking_account_number"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "channel": channelValues.reverse[channel],
//         "netbanking_bank_code": netbankingBankCode,
//         "netbanking_bank_name": netbankingBankName,
//         "netbanking_ifsc": netbankingIfsc,
//         "netbanking_account_number": netbankingAccountNumber,
//       };
// }
//
// class Upi {
//   String? channel;
//   String? upiId;
//
//   Upi({
//     this.channel,
//     this.upiId,
//   });
//
//   factory Upi.fromJson(Map<String, dynamic> json) => Upi(
//         channel: json["channel"],
//         upiId: json["upi_id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "channel": channel,
//         "upi_id": upiId,
//       };
// }
//
// enum PaymentStatus { NOT_ATTEMPTED, SUCCESS }
//
// final paymentStatusValues = EnumValues({"NOT_ATTEMPTED": PaymentStatus.NOT_ATTEMPTED, "SUCCESS": PaymentStatus.SUCCESS});
//
// enum Type { CREDIT }
//
// final typeValues = EnumValues({"credit": Type.CREDIT});
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
