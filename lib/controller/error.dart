import 'package:flutter/material.dart';

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key, required this.errorMessage});

  final String errorMessage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Something went wrong',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(body: Center(child: Text(errorMessage))),
    );
  }
}
