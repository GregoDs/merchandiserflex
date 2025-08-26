class ChamaProduct {
  final int id;
  final String name;
  final String expirationTime;
  final int monthlyPrice;
  final int targetAmount;

  ChamaProduct({ 
    required this.id,
    required this.name,
    required this.expirationTime,
    required this.monthlyPrice,
    required this.targetAmount,
  });

  factory ChamaProduct.fromJson(Map<String, dynamic> json) {
    return ChamaProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      expirationTime: json['expiration_time'] ?? '',
      monthlyPrice: json['monthly_price'] ?? 0,
      targetAmount: json['target_amount'] ?? 0,
    );
  }
}

class ChamaProductsResponse {
  final List<ChamaProduct> data;
  final List<String> errors;
  final bool success;
  final int statusCode;

  ChamaProductsResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ChamaProductsResponse.fromJson(Map<String, dynamic> json) {
    return ChamaProductsResponse(
      data: List<ChamaProduct>.from(
        json['data']?.map((x) => ChamaProduct.fromJson(x)) ?? [],
      ),
      errors: List<String>.from(json['errors'] ?? []),
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
    );
  }
}
