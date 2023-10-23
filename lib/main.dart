// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'services/preferences.dart';
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';

import 'package:http/http.dart' as http;

import 'util.dart';
import 'model/user_details.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String serverResponse = 'Server response';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 80),
              child: Text(
                'AIIP Prototype 7: Flutter x PostGres via Node.js',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
                child: Text('Send Request to server'),
                onPressed: () {
                  _makeGetRequest();
                }),
            spaceVertical(15),
            Form(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                ),
                spaceVertical(15),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                ),
                spaceVertical(15),
                ElevatedButton(
                    child: Text('Log in'),
                    onPressed: () {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      _logIn(email, password);
                    }),
              ],
            )),
            spaceVertical(15),
            // ElevatedButton(
            //     child: Text('Get user details'),
            //     onPressed: () {
            //       _getUserDetails();
            //     }),
            // spaceVertical(15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Builder(builder: (context) {
                        try {
                          return Text(serverResponse);
                        } catch (e) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: Icon(Icons.delete),
        onPressed: () {
          _clearText();
        },
      ),
    );
  }

  _makeGetRequest() async {
    final url = Uri.parse('${_domainName()}/get_user_details');
    var response = await http.get(url);
    setState(() {
      serverResponse = response.body;
      UserPreferences.setJson(serverResponse);
      // List<dynamic> list = json.decode(serverResponse);
    });
  }

  // _getUserDetails() async {
  //   var url = Uri.https(_domainName(), '/get_user_details');
  //   var response = await http.get(url);
  //   setState(() {
  //     serverResponse = 'response.body: ${response.body}';
  //   });
  // }

  _clearText() {
    setState(() {
      serverResponse = 'Response cleared.';
    });
  }

  String _domainName() {
    // if (Platform.isAndroid)
    return 'http://47.250.10.195:3030';
  }

  _logIn(String email, String password) async {
    final url = Uri.parse('${_domainName()}/get_user_details');
    var response = await http.get(url);
    String thisJson = response.body;
    // print('---Pass 1---');

    List<dynamic> listJson = json.decode(thisJson);

    int i = 0;
    String e = '';
    bool error = true;
    bool emailFound = false;
    // print('---Pass 2---');
    while (i < listJson.length) {
      // print('---Pass 3---');
      var user = UserDetails.fromJson(listJson[i]);
      e = 'Wrong email';

      if (user.email == email) {
        // print('---Pass 4---');
        // print('INPUT: $email\nEMAIL: ${user.email}\n---');
        // print('INPUT: $password\nPASSWORD: ${user.password}\n---');
        e = 'Wrong password';
        emailFound = true;
        if (BCrypt.checkpw(password,
            user.password.replaceAllMapped(RegExp(r"[$]"), (match) => "\$"))) {
          // print('---Pass 5---');
          setState(() {
            serverResponse = 'Welcome ${user.firstName} ${user.lastName}';

            //uuid simpan dalam app
            UserPreferences.setUser(user.id);
          });
          error = false;
          break;
        }
      }

      if (emailFound) {
        break;
      }
      i++;
    }

    if (error) {
      setState(() {
        serverResponse = e;
      });
    }
  }
}
