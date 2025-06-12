class ChamaRegistrationResponse {
  final bool success;
  final int statusCode;
  final List<String> errors;
  final ChamaRegistrationData data;

  ChamaRegistrationResponse({
    required this.success,
    required this.statusCode,
    required this.errors,
    required this.data,
  });

  factory ChamaRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return ChamaRegistrationResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      errors: List<String>.from(json['errors'] ?? []),
      data: ChamaRegistrationData.fromJson(json['data'] ?? {}),
    );
  }
}

class ChamaRegistrationData {
  final String phoneNumber;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final int gender;
  final String idNumber;
  final int agentId;
  final String txnRef;
  final String uuid;
  final int userId;
  final String updatedAt;
  final String createdAt;
  final int id;
  final ChamaUser user;

  ChamaRegistrationData({
    required this.phoneNumber,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.idNumber,
    required this.agentId,
    required this.txnRef,
    required this.uuid,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.user,
  });

  factory ChamaRegistrationData.fromJson(Map<String, dynamic> json) {
    return ChamaRegistrationData(
      phoneNumber: json['phone_number'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? 0,
      idNumber: json['id_number'] ?? '',
      agentId: json['agent_id'] ?? 0,
      txnRef: json['txn_ref'] ?? '',
      uuid: json['uuid'] ?? '',
      userId: json['user_id'] ?? 0,
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
      user: ChamaUser.fromJson(json['user'] ?? {}),
    );
  }
}

class ChamaUser {
  final int id;
  final String userName;
  final String authPin;
  final String accountStatus;
  final String? email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? mywagepayId;
  final List<dynamic> account;
  final ChamaMembership membership;

  ChamaUser({
    required this.id,
    required this.userName,
    required this.authPin,
    required this.accountStatus,
    this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.mywagepayId,
    required this.account,
    required this.membership,
  });

  factory ChamaUser.fromJson(Map<String, dynamic> json) {
    return ChamaUser(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      authPin: json['auth_pin'] ?? '',
      accountStatus: json['account_status'] ?? '',
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      mywagepayId: json['mywagepay_id'],
      account: List<dynamic>.from(json['account'] ?? []),
      membership: ChamaMembership.fromJson(json['membership'] ?? {}),
    );
  }
}

class ChamaMembership {
  final int id;
  final int userId;
  final String phoneNumber;
  final String source;
  final String firstName;
  final String lastName;
  final String middleName;
  final String dob;
  final String idNumber;
  final String idType;
  final String? taxId;
  final String? approvalStatus;
  final String txnRef;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String uuid;
  final int gender;
  final int agentId;

  ChamaMembership({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.source,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.dob,
    required this.idNumber,
    required this.idType,
    this.taxId,
    this.approvalStatus,
    required this.txnRef,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.uuid,
    required this.gender,
    required this.agentId,
  });

  factory ChamaMembership.fromJson(Map<String, dynamic> json) {
    return ChamaMembership(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      phoneNumber: json['phone_number'] ?? '',
      source: json['source'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      dob: json['dob'] ?? '',
      idNumber: json['id_number'] ?? '',
      idType: json['id_type'] ?? '',
      taxId: json['tax_id'],
      approvalStatus: json['approval_status'],
      txnRef: json['txn_ref'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      uuid: json['uuid'] ?? '',
      gender: json['gender'] ?? 0,
      agentId: json['agent_id'] ?? 0,
    );
  }
}
