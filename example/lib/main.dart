import 'package:flutter/material.dart';
import 'package:use_state_builder/use_state_builder.dart';
import 'dart:math' show Random;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Use State Builder Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return UseStateBuilder(
      builder: (context, useState) {
        ValueNotifier<int> counter = useState(0);
        ValueNotifier<double> rand = useState(0.0);

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  '${rand.value}',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              counter.value++;
              rand.value = Random().nextDouble();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
