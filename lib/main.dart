// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'services/preferences.dart';
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';

import 'package:http/http.dart' as http;

import 'util.dart';
import 'model/van_user.dart';

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
  int section = 0;
  String serverResponse = 'Server response';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(section.toString()),
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
            ElevatedButton(
                child: Text('Get all outlet'),
                onPressed: () {
                  _getAllOutlet();
                }),
            spaceVertical(15),
            section == 0
                ? Form(
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
                  ))
                : Form(
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(hintText: 'First Name'),
                        ),
                      ),
                      spaceVertical(15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(hintText: 'Last Name'),
                        ),
                      ),
                      spaceVertical(15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(hintText: 'Address'),
                        ),
                      ),
                      spaceVertical(15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: _newEmailController,
                          decoration: InputDecoration(hintText: 'Email'),
                        ),
                      ),
                      spaceVertical(15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          obscureText: true,
                          controller: _newPasswordController,
                          decoration: InputDecoration(hintText: 'Password'),
                        ),
                      ),
                      spaceVertical(15),
                      ElevatedButton(
                          child: Text('Register Van User'),
                          onPressed: () {
                            String firstName = _firstNameController.text.trim();
                            String lastName = _lastNameController.text.trim();
                            String address = _addressController.text.trim();
                            String newEmail = _newEmailController.text.trim();
                            String newPassword =
                                _newPasswordController.text.trim();

                            _registerVanUser(firstName, lastName, address,
                                newEmail, newPassword);
                          }),
                    ],
                  )),
            spaceVertical(15),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: Icon(Icons.delete),
            onPressed: () {
              _clearText();
            },
          ),
          spaceHorizontal(12),
          ElevatedButton(
            child: Icon(Icons.change_circle_outlined),
            onPressed: () {
              setState(() {
                if (section != 0) {
                  section = 0;
                  return;
                }
                if (section != 1) {
                  section = 1;
                  return;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  _makeGetRequest() async {
    final url = Uri.parse('${_domainName()}/get_van_user');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    setState(() {
      serverResponse = response.body;
      UserPreferences.setJson(serverResponse);
      // List<dynamic> list = json.decode(serverResponse);
    });
  }

  _getAllOutlet() async {
    final url = Uri.parse('${_domainName()}/get_outlet');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    setState(() {
      serverResponse = response.body;
      UserPreferences.setJson(serverResponse);
      // List<dynamic> list = json.decode(serverResponse);
    });
  }

  _clearText() {
    setState(() {
      serverResponse = 'Response cleared.';
    });
  }

  String _domainName() {
    return 'http://47.250.10.195:3030';
    // return 'http://localhost:8080';
  }

  _logIn(String email, String password) async {
    final url = Uri.parse('${_domainName()}/get_van_user');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
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
      var user = VanUser.fromJson(listJson[i]);
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

          final lastLoginUrl = Uri.parse('${_domainName()}/update_last_login');
          http.post(lastLoginUrl,
              // headers: {"Content-Type": "application/json"},
              body: {"van_user_id": user.id});
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

  _registerVanUser(String firstName, String lastName, String address,
      String newEmail, String newPassword) {
    final url = Uri.parse('${_domainName()}/register_mobile/register_van_user');
    http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "address": address,
          "email": newEmail,
          "password": newPassword,
        }));

    setState(() {
      serverResponse = '''
{
  "first_name": $firstName,
  "last_name": $lastName,
  "address": $address,
  "email": $newEmail,
  "password": $newPassword,
}

''';
    });
  }
}
