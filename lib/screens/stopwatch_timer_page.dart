// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'button_widget.dart';

class StopWatchTimerPage extends StatefulWidget {
  const StopWatchTimerPage({Key? key}) : super(key: key);
  @override
  _StopWatchTimerPageState createState() => _StopWatchTimerPageState();
}

class _StopWatchTimerPageState extends State<StopWatchTimerPage> {
  static const countdownDuration = Duration(seconds: 15);
  Duration duration = const Duration();
  Timer? timer;
  int paperCount = 0;
  bool countDown = true;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void addPaper() {
    setState(() {
      paperCount++;
    });
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  var period = const Duration(seconds: 1);
  void startTimer() {
    timer = Timer.periodic(period, (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("GamFed Focus App"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.green,
          child: Text(paperCount.toString()),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [buildTime(), const SizedBox(height: 80), buildButtons()],
          ),
        ),
      );

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    bool isComplated = duration.inSeconds == 0;

    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isComplated
              ? [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "1 Sayfa Daha Kazandın!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 25),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ButtonWidget(
                          text: "Sayfanı Topla",
                          backgroundColor: Colors.green,
                          onClicked: () {
                            addPaper();
                            stopTimer();
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              title: "Tebrikler!",
                              text: "Sayfan Eklendi!",
                            );
                          })
                    ],
                  ),
                ]
              : [
                  buildTimeCard(time: hours, header: 'Saat'),
                  const SizedBox(width: 8),
                  buildTimeCard(time: minutes, header: 'Dakika'),
                  const SizedBox(width: 8),
                  buildTimeCard(time: seconds, header: 'Saniye'),
                ]),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(header, style: const TextStyle(color: Colors.black45)),
        ],
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isCompleted
        ? ButtonWidget(
            text: "Tekrar Başla",
            color: Colors.black,
            backgroundColor: Colors.white,
            onClicked: () {
              stopTimer();
            })
        : isRunning
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                      text: 'Durdur',
                      onClicked: () {
                        if (isRunning) {
                          stopTimer(resets: false);
                        }
                      }),
                  const SizedBox(width: 12),
                  ButtonWidget(text: "İptal", onClicked: stopTimer),
                ],
              )
            : ButtonWidget(
                text: "Başla",
                color: Colors.black,
                backgroundColor: Colors.white,
                onClicked: () {
                  startTimer();
                });
  }
}
