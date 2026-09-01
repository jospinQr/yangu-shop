class SendOtpRequestDto {
  const SendOtpRequestDto({required this.phoneNumber});

  final String phoneNumber;

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber};
  }
}
