import 'dart:async';
import 'package:flutter/material.dart';

String selectedGender = 'Male';

StreamController<Brightness> brightnessStream = StreamController();
Brightness? currBrightness;

