import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:gamfedapp/screens/blog_page.dart';
import 'package:gamfedapp/screens/friends_pafe.dart';
import 'package:gamfedapp/screens/library_page.dart';
import 'package:gamfedapp/screens/my_papers.dart';
import 'package:gamfedapp/screens/settings_page.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../widgets/button_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Duration> countdownDuration = [
    const Duration(seconds: 5), // 15 minutes but now 5 seconds for testing
    const Duration(minutes: 30),
    const Duration(minutes: 60),
    const Duration(minutes: 120)
  ];
  List<int> paperCounts = [1, 3, 5, 10]; // add paper count for each duration
  double durationIndex = 0; // double for slider

  bool countDown = true;
  Duration duration = const Duration();
  int paperCount = 0; // user paper count
  var period = const Duration(seconds: 1);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // for AppLifecycleState
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // asıl logic bu kısımda işleyecek
    debugPrint('state = $state');
    if (state == AppLifecycleState.resumed) {
      debugPrint('resumed');
    } else if (state == AppLifecycleState.paused) {
      debugPrint('paused');
    } else if (state == AppLifecycleState.detached) {
      debugPrint('detached');
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('inactive');
    }
  }

  void addPaper() {
    setState(() {
      paperCount += paperCounts[durationIndex ~/ 1];
    });
  }

  void reset() {
    if (countDown) {
      setState(() => duration =
          countdownDuration[durationIndex ~/ 1]); // toInt() isn't working
    } else {
      setState(() => duration = const Duration());
    }
  }

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

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    bool isComplated = duration.inSeconds == 0;
    final isRunning = timer == null ? false : timer!.isActive;

    return Column(children: [
      isRunning
          ? const SizedBox(height: 56)
          : SfSlider(
              min: 0.0,
              max: 3.0,
              interval: 1,
              showTicks: true,
              stepSize: 1,
              showLabels: true,
              labelFormatterCallback:
                  (dynamic actualLabel, dynamic formattedText) {
                switch (actualLabel.toInt()) {
                  case 0:
                    return '15 dk';
                  case 1:
                    return '30 dk';
                  case 2:
                    return '1 saat';
                  case 3:
                    return '2 saat';
                  default:
                    return '';
                }
              },
              value: durationIndex,
              onChanged: (dynamic newValue) {
                setState(() {
                  durationIndex = newValue;
                });
                reset();
              },
            ),
      const SizedBox(height: 60),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isComplated
              ? [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Tebrikler! ${paperCounts[durationIndex ~/ 1]} Sayfa Daha Kazandın.",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
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

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.orange[50],
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              const UserAccountsDrawerHeader(
                accountName: Text("Abhishek Mishra"),
                accountEmail: Text("abhishekm977@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text("Sayfalarım"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyPapersPage();
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.library_books),
                title: const Text("Kütüphane"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LibraryPage();
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text("Arkadaşlarım"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const FriendsPage();
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text("Başarılarım"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text("Blog"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const BlogPage();
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Ayarlar"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingsPage();
                  }));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("GamFed Screen App"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
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
}
