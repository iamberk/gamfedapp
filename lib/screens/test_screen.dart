import 'dart:async';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> with WidgetsBindingObserver {
  late Timer _timer;
  int _seconds = 0;
  int _pausedAt = 0;
  String _durationText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds += 1;
        _durationText = 'Seconds elapsed: $_seconds';
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void pauseTimer() {
    _timer.cancel();
    _pausedAt = _seconds;
  }

  void resumeTimer() {
    startTimer();
    _seconds = _pausedAt;
    _pausedAt = 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('state = $state');
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_pausedAt > 0) {
        resumeTimer();
      }
    } else if (state == AppLifecycleState.paused) {
      pauseTimer();
    } else if (state == AppLifecycleState.detached) {
      debugPrint('detached');
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('inactive');
    }
  }

  @override
  void deactivate() {
    debugPrint('deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              _durationText,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Start Timer'),
            onPressed: () {
              startTimer();
            },
          ),
        ],
      ),
    );
  }
}
