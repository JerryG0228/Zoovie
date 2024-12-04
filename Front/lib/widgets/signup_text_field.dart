import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData icon,
  bool obscureText = false,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    validator: validator,
  );
}
