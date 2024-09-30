import 'package:flutter/material.dart';

Container contwebside(IconData icon) {
  return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: Icon(
        icon,
        color: Colors.blue,
        size: 50,
      ));
}
