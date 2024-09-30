import 'package:flutter/material.dart';

MaterialButton materialbutton(Function()? onPressed, String text) {
  return MaterialButton(
    onPressed: onPressed,
    color: Color.fromARGB(255, 14, 105, 179),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    minWidth: 100,
    height: 60,
    child: Text(
      "$text",
      style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700,
          fontFamily: 'DancingScript'),
    ),
  );
}

MaterialButton materialbuttonimage(
    Function()? onPressed, String text, bool isselect) {
  return MaterialButton(
    onPressed: onPressed,
    color: isselect ? Colors.green : Color.fromARGB(255, 14, 105, 179),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    minWidth: 100,
    height: 60,
    child: Text(
      "$text",
      style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700,
          fontFamily: 'DancingScript'),
    ),
  );
}
