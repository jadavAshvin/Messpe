import 'dart:convert';

class GenerateReferralCode {
  static String generateReferralCode(String name, String phoneNo) {
    String referralCode;

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(phoneNo);
    if (name.length >= 4) {
      referralCode = name.substring(0, 4) + encoded.substring(0, 8);
      print('if referralCode = ' +
          referralCode +
          ' length ' +
          referralCode.length.toString());
    } else {

      //For same length of referral code 12
      final length = name.length;

      referralCode = name +
          encoded.substring(
              0,
              8 +
                  (length == 1
                      ? 3
                      : length == 2
                          ? 2
                          : 1));
      print('else referralCode = ' +
          referralCode +
          ' length ' +
          referralCode.length.toString());
    }
    return referralCode;
  }
}
