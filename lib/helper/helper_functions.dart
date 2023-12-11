import 'package:flutter/material.dart';

// display error message
void displayErrorMessage(String message, BuildContext context) {
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(message),
    )
  );
}

// display success message
void displaySuccessMessage(String message, BuildContext context) {
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(message),
    )
  );
}