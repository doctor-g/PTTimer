import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const PTTimer());
}

class PTTimer extends StatelessWidget {
  const PTTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TimerWidget();
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimerWidgetState();
  }
}

class _TimerWidgetState extends State<TimerWidget> {
  static const int _defaultSecondsRemaining = 60 * 3;

  bool _isRunning = false;
  int _secondsRemaining = _defaultSecondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TimeRemaining(_secondsRemaining),
        TextButton(
            child: const Text('Start'),
            onPressed: _isRunning ? null : () => _startTimer()),
        TextButton(
            child: const Text('Pause'),
            onPressed: _isRunning ? () => _pauseTimer() : null),
        TextButton(
          child: const Text('Reset'),
          onPressed: () => _resetTimer(),
        ),
      ],
    );
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _secondsRemaining = max(0, _secondsRemaining - 1);
        });
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null) {
      // This actually cancels the timer, but that's ok, because when
      // we start, it will make a new one.
      setState(() {
        _timer!.cancel();
        _isRunning = false;
      });
    } else {
      throw Exception('Cannot pause timer when there is no timer.');
    }
  }

  void _resetTimer() {
    setState(() {
      _secondsRemaining = _defaultSecondsRemaining;
    });
  }
}

class TimeRemaining extends StatelessWidget {
  final int seconds;

  const TimeRemaining(this.seconds, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text =
        '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    return Text(text);
  }
}
