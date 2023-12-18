import 'package:flutter/material.dart';

enum TextFieldType {
  normal,
  search,
  password,
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.type,
    this.onChanged,
    this.trailing,
    this.controller,
  });

  final String title;
  final TextFieldType type;
  final Function(String text)? onChanged;
  final Widget? trailing;
  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _visibility = false; // False means text is hidden by default

  Widget _togglePasswordVisibility() {
    if (!_visibility) {
      // If the password is hidden then display "eye opened" icon
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
      // If the password is displayed then display "eye closed" icon
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

  Widget _displaySearchIcon() {
    return const Icon(Icons.search_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: (widget.type == TextFieldType.password && !_visibility)
          ? true
          : false,
      decoration: InputDecoration(
        labelText: widget.title,
        border: (widget.type == TextFieldType.search)
            ? const OutlineInputBorder()
            : null,
        prefixIcon:
            (widget.type == TextFieldType.search) ? _displaySearchIcon() : null,
        suffixIcon: (widget.type == TextFieldType.password)
            ? _togglePasswordVisibility()
            : widget.trailing,
      ),
    );
  }
}
