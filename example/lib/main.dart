import 'package:example/app.dart';
import 'package:flutter/material.dart';
extension ListExtensions<E> on List<E> {
  List<E> addSkipNull(E? element) {
    if (element != null) add(element);
    return this;
  }

  List<E> addAllReturn(List<E> items) {
    addAll(items);

    return this;
  }
}
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  App(),
    );
  }
}
