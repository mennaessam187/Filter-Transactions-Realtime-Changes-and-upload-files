import 'package:flutter/material.dart';

TextFormField text(String hint, TextEditingController controller, Widget icon,
    String? Function(String?) validate, Function(String?)? onSaved) {
  return TextFormField(
    onSaved: onSaved,
    validator: validate,
    controller: controller,
    decoration: InputDecoration(
      fillColor: const Color.fromARGB(185, 234, 231, 231),
      filled: true,
      hintText: hint,
      hintStyle: const TextStyle(color: Color.fromARGB(255, 213, 209, 209)),
      suffixIcon: icon,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: Color.fromARGB(185, 234, 231, 231),
          )),
    ),
    style: const TextStyle(fontSize: 15),
  );
}
