// Import necessary packages and files
import 'package:cycletech/globals/globaldata.dart';
import 'package:flutter/material.dart';

// Dropdown example widget
class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

// State class for the dropdown example widget
class _DropdownExampleState extends State<DropdownExample> {
  String selectedValue = 'Male'; // Default selected value

  @override
  Widget build(BuildContext context) {
    // Build method for the widget
    return Row(
      children: [
        const Text(
          "Gender :   ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // DropdownButton widget to create a dropdown menu
        DropdownButton<String>(
          // Set the current selected value
          value: selectedValue,
          // Callback when the user selects a new value
          onChanged: (String? newValue) {
            setState(() {
              // Update the selected value and the global variable 'selectedGender'
              selectedValue = newValue!;
              selectedGender = selectedValue;
            });
          },
          // List of dropdown items (in this case, Male and Female)
          items: <String>['Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
