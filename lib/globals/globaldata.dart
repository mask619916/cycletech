// Import necessary packages and files
import 'dart:async';
import 'package:cycletech/models/user_details.dart';
import 'package:flutter/material.dart';

// Initialize a default gender selection
String selectedGender = 'Male';

// Create a stream controller for managing brightness changes
StreamController<Brightness> brightnessStream = StreamController();

// Variable to store the current brightness value
Brightness? currBrightness;

// Variable to store the current user details
UserDetails currUserDetails = UserDetails();
