import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String? email;
  Map<String, dynamic>? achievements;
  Map<String, dynamic>? trackedRides;
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
    this.trackedRides,
    this.dob,
    this.gender,
    this.weight,
    this.height,
    this.fName,
    this.lName,
    this.profileAvatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "achievements": achievements,
      "dob": dob,
      "gender": gender,
      "weight": weight,
      "height": height,
      "fName": fName,
      "lName": lName,
      "profileAvatarUrl": profileAvatarUrl,
    };
  }
}
