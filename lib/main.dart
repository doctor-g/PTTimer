import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PTTimer());
}

class PTTimer extends StatelessWidget {
  const PTTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P&T Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('P&T Timer'),
        ),
        body: const SizedBox.expand(
          child: MainPage(),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        TimerWidget(
          label: 'Opening Statement',
          duration: Duration(minutes: 3),
        ),
        TimerWidget(
          label: 'Discussion',
          duration: Duration(minutes: 20),
        ),
        TimerWidget(
          label: 'Extended discussion',
          duration: Duration(minutes: 10),
        ),
      ],
    );
  }
}

class TimerWidget extends StatefulWidget {
  final Duration duration;
  final String? label;

  const TimerWidget(
      {this.duration = const Duration(minutes: 3), this.label, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimerWidgetState();
  }
}

class _TimerWidgetState extends State<TimerWidget> {
  bool _isRunning = false;
  late int _secondsRemaining;
  Timer? _timer;
  final AudioCache _audioCache = AudioCache();

  @override
  void initState() {
    _secondsRemaining = widget.duration.inSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var columnChildren = [
      TimeRemaining(_secondsRemaining),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
      ),
    ];
    if (widget.label != null) {
      columnChildren.insert(0, Text(widget.label!));
    }
    return Column(children: columnChildren);
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _secondsRemaining -= 1;
          if (_secondsRemaining == 0) {
            _audioCache.play('chime.wav');
            if (_timer != null) {
              _timer!.cancel();
              _isRunning = false;
            }
          }
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
      _secondsRemaining = widget.duration.inSeconds;
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
    return Text(
      text,
      style: TextStyle(fontSize: 48),
    );
  }
}
