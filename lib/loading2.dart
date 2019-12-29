import 'dart:async';

import 'package:diabetes_app/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading2 extends StatefulWidget {
  @override
  _Loading2State createState() => _Loading2State();
}

class _Loading2State extends State<Loading2> {


  void initState() {

    Timer(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
