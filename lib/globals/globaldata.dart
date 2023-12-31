import 'dart:async';
import 'package:cycletech/models/user_details.dart';
import 'package:flutter/material.dart';

String selectedGender = 'Male';

StreamController<Brightness> brightnessStream = StreamController();
Brightness? currBrightness;

UserDetails currUserDetails = UserDetails();
