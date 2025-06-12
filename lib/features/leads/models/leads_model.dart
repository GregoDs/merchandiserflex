class LeadRequest {
  final String promoterUserId;
  final String customerPhone;
  final String customerFirstName;
  final String customerLastName;
  final String description;

  LeadRequest({
    required this.promoterUserId,
    required this.customerPhone,
    required this.customerFirstName,
    required this.customerLastName,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "promoter_user_id": promoterUserId,
        "customer_phone": customerPhone,
        "customer_first_name": customerFirstName,
        "customer_last_name": customerLastName,
        "description": description,
      };
}

class LeadResponse {
  final int? id;
  final String? promoterUserId;
  final String? customerPhone;
  final String? customerFirstName;
  final String? customerLastName;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  LeadResponse({
    this.id,
    this.promoterUserId,
    this.customerPhone,
    this.customerFirstName,
    this.customerLastName,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory LeadResponse.fromJson(Map<String, dynamic> json) => LeadResponse(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? ''),
        promoterUserId: json['promoter_user_id'],
        customerPhone: json['customer_phone'],
        customerFirstName: json['customer_first_name'],
        customerLastName: json['customer_last_name'],
        description: json['description'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}