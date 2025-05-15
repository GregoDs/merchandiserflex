class OutletResponse {
  final bool success;
  final int statusCode;
  final List<Outlet> data;
  final List<dynamic> errors;

  OutletResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.errors,
  });

  factory OutletResponse.fromJson(Map<String, dynamic> json) {
    return OutletResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Outlet.fromJson(e))
              .toList() ??
          [],
      errors: json['errors'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
      'errors': errors,
    };
  }
}

class Outlet {
  final int id;
  final String outletName;
  final int merchantId;
  final String locationName;
  final int accountManager;
  final String merchantOutletCode;
  final String outletType;
  final double? outletLongitude;
  final double? outletLatitude;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasNewCommission;
  final double commissionPercentage;

  Outlet({
    required this.id,
    required this.outletName,
    required this.merchantId,
    required this.locationName,
    required this.accountManager,
    required this.merchantOutletCode,
    required this.outletType,
    this.outletLongitude,
    this.outletLatitude,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.hasNewCommission,
    required this.commissionPercentage,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'] ?? 0,
      outletName: json['outlet_name'] ?? '',
      merchantId: json['merchant_id'] ?? 0,
      locationName: json['location_name'] ?? '',
      accountManager: json['account_manager'] ?? 0,
      merchantOutletCode: json['merchant_outlet_code'] ?? '',
      outletType: json['outlet_type'] ?? '',
      outletLongitude: json['outlet_longitude']?.toDouble(),
      outletLatitude: json['outlet_latitude']?.toDouble(),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      hasNewCommission: (json['has_new_commission'] ?? 0) == 1,
      commissionPercentage: (json['commission_percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outlet_name': outletName,
      'merchant_id': merchantId,
      'location_name': locationName,
      'account_manager': accountManager,
      'merchant_outlet_code': merchantOutletCode,
      'outlet_type': outletType,
      'outlet_longitude': outletLongitude,
      'outlet_latitude': outletLatitude,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'has_new_commission': hasNewCommission ? 1 : 0,
      'commission_percentage': commissionPercentage,
    };
  }
}