import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'P&T Timer',
      home: const PTTimer(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ),
  );
}

class PTTimer extends StatelessWidget {
  static const String _githubURL = 'https://github.com/doctor-g/PTTimer';

  const PTTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('P&T Timer'),
        actions: [
          IconButton(
              onPressed: () => showAboutDialog(
                    context: context,
                    applicationName: 'P&T Timer',
                    children: [
                      Text('©2021–${DateTime.now().year} Paul Gestwicki'),
                      const Text(
                          'Licensed under GNU General Public License v3.0'),
                      Link(
                        uri: Uri.parse(_githubURL),
                        builder: (context, followLink) => InkWell(
                          onTap: followLink,
                          child: const Text(
                            _githubURL,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
              icon: const Icon(Icons.info)),
        ],
      ),
      body: const SizedBox.expand(
        child: MainPage(),
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
          label: 'Extended Discussion',
          duration: Duration(minutes: 10),
        ),
        TimerWidget(
          label: 'Closing Statement',
          duration: Duration(minutes: 2),
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
  final _player = AudioPlayer();

  @override
  void initState() {
    _secondsRemaining = widget.duration.inSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var columnChildren = [
      _makeTimerWidget(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: !_isRunning && _secondsRemaining > 0
                  ? () => _startTimer()
                  : null,
              child: const Text('Start')),
          TextButton(
              onPressed: _isRunning ? () => _pauseTimer() : null,
              child: const Text('Pause')),
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

  Widget _makeTimerWidget() {
    String text =
        '${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}';
    return Text(
      text,
      style: TextStyle(
        fontSize: 48,
        color: _isRunning ? Colors.black : Colors.grey,
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _secondsRemaining -= 1;
          if (_secondsRemaining == 0) {
            _player.play(AssetSource('chime.wav'));
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
