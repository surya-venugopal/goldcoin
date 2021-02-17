import 'package:flutter/material.dart';

class PassCodeModel with ChangeNotifier {
  String pin;

  void setPin(String pin) {
    print(pin);
    this.pin = pin;
    notifyListeners();
  }
}
