import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String? email;
  Map<String, dynamic>? achievements;
  Timestamp? dob;
  String? gender;
  int? weight;
  int? height;
  String? fName;
  String? lName;
  String? profileAvatarUrl;

  UserDetails({
    this.email,
    this.achievements,
    this.dob,
    this.fName,
    this.gender,
    this.height,
    this.lName,
    this.profileAvatarUrl,
    this.weight,
  });

  Map<String, dynamic> tomap() {
    return {
      "dob": dob,
      "fName": fName,
      "lName": lName,
      "gender": gender,
      "height": height,
      "weight": weight,
      "profileAvatarUrl": profileAvatarUrl,
      "achievements": achievements,
    };
  }
}
