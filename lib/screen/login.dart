import 'package:aiip_p7_dbapi/model/user_details.dart';
import 'package:aiip_p7_dbapi/services/preferences.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';

import 'package:http/http.dart' as http;

import '../controller/util.dart';

class LoginImran extends StatefulWidget {
  const LoginImran({super.key, required this.title});
  final String title;
  @override
  State<LoginImran> createState() => _LoginImranState();
}

class _LoginImranState extends State<LoginImran> {
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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 80, 20, 80),
              child: Text(
                'AIIP Prototype 7: Flutter x PostGres via Node.js',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            // ElevatedButton(
            //   child: const Text('Send Request to server'),
            //   onPressed: () {
            //     _makeGetRequest();
            //   },
            // ),
            spaceVertical(15),
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                  ),
                  spaceVertical(15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                  ),
                  spaceVertical(15),
                  ElevatedButton(
                    child: const Text('Log in'),
                    onPressed: () {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      _logIn(email, password);
                    },
                  ),
                ],
              ),
            ),
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Builder(builder: (context) {
                        try {
                          return Text(serverResponse);
                        } catch (e) {
                          return const Center(
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
      // floatingActionButton: ElevatedButton(
      //   child: const Icon(Icons.delete),
      //   onPressed: () {
      //     _clearText();
      //   },
      // ),
    );
  }

  // _makeGetRequest() async {
  //   final url = Uri.parse('${_domainName()}/get_user_details');
  //   var response = await http.get(url);
  //   setState(
  //     () {
  //       serverResponse = response.body;
  //       UserPreferences.setJson(serverResponse);
  //       // List<dynamic> list = json.decode(serverResponse);
  //     },
  //   );
  // }

  // _getUserDetails() async {
  //   var url = Uri.https(_domainName(), '/get_user_details');
  //   var response = await http.get(url);
  //   setState(() {
  //     serverResponse = 'response.body: ${response.body}';
  //   });
  // }

  // _clearText() {
  //   setState(
  //     () {
  //       serverResponse = 'Response cleared.';
  //     },
  //   );
  // }

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
          setState(
            () {
              serverResponse = 'Welcome ${user.firstName} ${user.lastName}';

              //uuid simpan dalam app
              UserPreferences.setUser(user.id);
            },
          );
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
      setState(
        () {
          serverResponse = e;
        },
      );
    }
  }
}
