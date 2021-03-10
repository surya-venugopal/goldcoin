import 'dart:async';

import 'package:flutter/cupertino.dart';

class Wins with ChangeNotifier {
  bool isHighLighted = false;

  Timer _timer;
  int _start = 10;

  void startTimer() {
    print("\n\n\n\n\nTimer started");

    const oneSec = const Duration(minutes: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          isHighLighted = true;
          _timer.cancel();
          notifyListeners();
        } else {
          _start--;
        }
      },
    );
  }
}
