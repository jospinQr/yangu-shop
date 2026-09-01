class VerifyOtpRequestDto {
  const VerifyOtpRequestDto({required this.phoneNumber, required this.code});

  final String phoneNumber;
  final String code;

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'code': code};
  }
}
