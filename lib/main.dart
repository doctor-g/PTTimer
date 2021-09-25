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
  bool _isRunning = false;
  int _secondsRemaining = 60 * 3;

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
      ],
    );
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining = max(0, _secondsRemaining - 1);
      });
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
