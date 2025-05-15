// customer_model.dart
class CustomerResponse {
  final bool success;
  final int statusCode;
  final List<String> errors;
  final CustomerData data;

  CustomerResponse({
    required this.success,
    required this.statusCode,
    required this.errors,
    required this.data,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      errors: List<String>.from(json['errors'] ?? []),
      data: CustomerData.fromJson(json['data'] ?? {}),
    );
  }
}

class CustomerData {
  final List<Customer> customers;
  final PaginationInfo pagination;

  CustomerData({required this.customers, required this.pagination});

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      customers: List<Customer>.from(
        (json['data'] as List<dynamic>? ?? []).map(
          (x) => Customer.fromJson(x as Map<String, dynamic>),
        ),
      ),
      pagination: PaginationInfo.fromJson(json),
    );
  }
}

class Customer {
  final int id;
  final String name;
  final String phone;
  final bool isFlexsaveCustomer;
  final CustomerFollowup? followup;
  final String dateCreated;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.isFlexsaveCustomer,
    this.followup,
    required this.dateCreated,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      name: json['customer_name']?.toString().trim() ?? '',
      phone: json['phone']?.toString().trim() ?? '',
      isFlexsaveCustomer: (json['is_flexsave_customer'] ?? 0) == 1,
      followup:
          json['customer_followup'] != null
              ? CustomerFollowup.fromJson(json['customer_followup'])
              : null,
      dateCreated: json['date_created'] ?? '',
    );
  }
}

class CustomerFollowup {
  final int id;
  final int userId;
  final String status;
  final int createdBy;
  final String? description;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerFollowup({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdBy,
    this.description,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerFollowup.fromJson(Map<String, dynamic> json) {
    return CustomerFollowup(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      status: json['status'] ?? '',
      createdBy: json['created_by'] ?? 0,
      description: json['description'],
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toString(),
      ),
    );
  }
}

class PaginationInfo {
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  PaginationInfo({
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      lastPageUrl: json['last_page_url'] ?? '',
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: int.tryParse(json['per_page']?.toString() ?? '0') ?? 0,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
