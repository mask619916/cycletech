// Import necessary packages and files
import 'package:flutter/material.dart';

// Enum to represent different types of text fields
enum TextFieldType {
  normal,
  password,
  number,
  readonly,
}

// Custom text field widget
class CustomTextField extends StatefulWidget {
  // Constructor with required parameters
  const CustomTextField({
    super.key,
    required this.title,
    required this.type,
    this.onChanged,
    this.trailing,
    this.controller,
  });

  // Properties of the custom text field
  final String title;
  final TextFieldType type;
  final Function(String text)? onChanged;
  final Widget? trailing;
  final TextEditingController? controller;

  // Create the state for the custom text field
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

// State class for the custom text field
class _CustomTextFieldState extends State<CustomTextField> {
  // Variable to track password visibility
  bool _visibility = false; // False means text is hidden by default

  // Toggle password visibility based on current state
  Widget _togglePasswordVisibility() {
    if (!_visibility) {
      // If the password is hidden, display "eye opened" icon
      // and show password when icon is clicked.
      return IconButton(
        onPressed: () {
          setState(() {
            _visibility = !_visibility;
          });
        },
        icon: const Icon(Icons.visibility_outlined),
      );
    } else {
      // If the password is displayed, display "eye closed" icon
      // and hide password when icon is clicked.
      return IconButton(
        onPressed: () {
          setState(() {
            _visibility = !_visibility;
          });
        },
        icon: const Icon(Icons.visibility_off_outlined),
      );
    }
  }

  // Display search icon for the search text field
  Widget _displaySearchIcon() {
    return const Icon(Icons.search_outlined);
  }

  // Build method for the custom text field
  @override
  Widget build(BuildContext context) {
    return TextField(
      // Set the provided controller for text input
      controller: widget.controller,
      // Set read-only mode if the type is readonly
      readOnly: (widget.type == TextFieldType.readonly) ? true : false,
      // Disable interactive selection if the type is readonly
      enableInteractiveSelection:
          (widget.type == TextFieldType.readonly) ? false : true,
      // Set the keyboard type to number if the type is number
      keyboardType:
          (widget.type == TextFieldType.number) ? TextInputType.number : null,
      // Set obscureText to hide password if the type is password and visibility is false
      obscureText: (widget.type == TextFieldType.password && !_visibility)
          ? true
          : false,
      // Define decoration for the text field
      decoration: InputDecoration(
        // Set label text for the text field
        labelText: widget.title,
        // Set suffix icon based on the type of the text field
        suffixIcon: (widget.type == TextFieldType.password)
            ? _togglePasswordVisibility()
            : widget.trailing,
      ),
    );
  }
}
