import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyPapersPage extends StatefulWidget {
  const MyPapersPage({super.key});

  @override
  State<MyPapersPage> createState() => _MyPapersPageState();
}

class _MyPapersPageState extends State<MyPapersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfalarım'),
      ),
      body: const Center(
        child: Text('Geçmiş ekran süreleri, istatistikler'),
      ),
    );
  }
}
