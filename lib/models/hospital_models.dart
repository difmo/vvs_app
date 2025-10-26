class HospitalStep1 {
  String orgName = '';
  String address = '';
  String state = '';
  String district = '';
  String website = '';
  String opd = '';
  String doctors = '';
  String orgType = 'Hospital';
  String governmentType = 'Select Government Type';
  bool hmisRegistered = false;

  Map<String, dynamic> toMap() {
    return {
      'orgName': orgName,
      'address': address,
      'state': state,
      'district': district,
      'website': website,
      'opd': opd,
      'doctors': doctors,
      'orgType': orgType,
      'governmentType': governmentType,
      'hmisRegistered': hmisRegistered,
    };
  }
}

class HospitalStep2 {
  String officerName = '';
  String designation = '';
  String mobile = '';
  String landline = '';
  String email = '';
  String headOfOrg = '';
  String? imageUrl;

  Map<String, dynamic> toMap() {
    return {
      'officerName': officerName,
      'designation': designation,
      'mobile': mobile,
      'landline': landline,
      'email': email,
      'headOfOrg': headOfOrg,
      'imageUrl': imageUrl,
    };
  }
}
