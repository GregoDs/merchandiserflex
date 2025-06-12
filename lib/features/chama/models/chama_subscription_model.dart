class ChamaSubscriptionRequest {
  final String phoneNumber;
  final int productId;
  final double depositAmount;

  ChamaSubscriptionRequest({
    required this.phoneNumber,
    required this.productId,
    required this.depositAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'product_id': productId,
      'deposit_amount': depositAmount,
    };
  }
}

class ChamaSubscriptionResponse {
  final ChamaSubscriptionData? data;
  final List<String> errors;
  final bool success;
  final int statusCode;

  ChamaSubscriptionResponse({
    this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ChamaSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return ChamaSubscriptionResponse(
      data: json['data'] != null
          ? ChamaSubscriptionData.fromJson(json['data'])
          : null,
      errors: List<String>.from(json['errors'] ?? []),
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
    );
  }
}

class ChamaSubscriptionData {
  final int id;
  final String productName;
  final String slug;
  final int productMinimumBalance;
  final String productCategory;
  final String productType;
  final String productAccessTerms;
  final String contributionTerms;
  final String expirlyTime;
  final String txnRef;
  final String createdAt;
  final String updatedAt;
  final String uuid;
  final String expiryDate;

  ChamaSubscriptionData({
    required this.id,
    required this.productName,
    required this.slug,
    required this.productMinimumBalance,
    required this.productCategory,
    required this.productType,
    required this.productAccessTerms,
    required this.contributionTerms,
    required this.expirlyTime,
    required this.txnRef,
    required this.createdAt,
    required this.updatedAt,
    required this.uuid,
    required this.expiryDate,
  });

  factory ChamaSubscriptionData.fromJson(Map<String, dynamic> json) {
    return ChamaSubscriptionData(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      slug: json['slug'] ?? '',
      productMinimumBalance: json['product_minimum_balance'] ?? 0,
      productCategory: json['product_category'] ?? '',
      productType: json['product_type'] ?? '',
      productAccessTerms: json['product_access_terms'] ?? '',
      contributionTerms: json['contribution_terms'] ?? '',
      expirlyTime: json['expirly_time'] ?? '',
      txnRef: json['txn_ref'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      uuid: json['uuid'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
    );
  }
} 