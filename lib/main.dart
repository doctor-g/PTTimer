import 'dart:async';

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
  const TimerWidget({Key? key}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _TimerWidgetState();
  }
  
}

class _TimerWidgetState extends State<TimerWidget> {

  int _secondsElapsed = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds:1), (timer) { 
      setState(() {
        _secondsElapsed+=1;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Text(_secondsElapsed.toString());
  }

}