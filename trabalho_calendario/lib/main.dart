

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_calendario/pages/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendario',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyPage(),
    );
  }
}