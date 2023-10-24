import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../controller/ui_controller.dart';
import '../model/user_details.dart';

import 'homepage.dart';

// import '../views/login_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String serverResponse = 'Server response';

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String _domainName() {
    // if (Platform.isAndroid)
    return 'http://47.250.10.195:3030';
  }

  void navigateToAnotherPage(context) {
    // Use the Navigator to push a new route onto the navigation stack.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MyHomePage();
        },
      ),
    );
  }

  _logIn(String email, String password) async {
    final url = Uri.parse('${_domainName()}/get_user_details');
    var response = await http.get(url);
    String thisJson = response.body;

    List<dynamic> listJson = json.decode(thisJson);

    int i = 0;
    bool credentialsCorrect = false;

    while (i < listJson.length) {
      var user = UserDetails.fromJson(listJson[i]);

      if (user.email == email &&
          BCrypt.checkpw(
              password,
              user.password
                  .replaceAllMapped(RegExp(r"[$]"), (match) => "\$"))) {
        // Credentials are correct
        setState(() {
          serverResponse = 'Welcome ${user.firstName} ${user.lastName}';
        });

        navigateToAnotherPage(context);

        credentialsCorrect = true;
        break;
      }

      i++;
    }

    if (!credentialsCorrect) {
      // Wrong credentials
      setState(() {
        serverResponse = 'Wrong email or password';
      });
    }
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size, simpleUIController, theme);
              } else {
                return _buildSmallScreen(size, simpleUIController, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 0,
            child: Lottie.asset(
              'assets/rocket.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Lottie.asset(
                'assets/wave.json',
                height: size.height * 0.2,
                width: size.width,
                fit: BoxFit.fill,
              ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Login',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Welcome back sayang',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    hintText: 'Gmail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter gmail';
                    } else if (!value.endsWith('@gmail.com')) {
                      return 'please enter valid gmail';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value.length < 7) {
                        return 'at least enter 6 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Cuba try test',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                loginButton(theme),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To other screen
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         CupertinoPageRoute(
                //             builder: (ctx) => const Try()));
                //     nameController.clear();
                //     emailController.clear();
                //     passwordController.clear();
                //     _formKey.currentState?.reset();

                //     simpleUIController.isObscure.value = true;
                //   },
                //   child: RichText(
                //     text: TextSpan(
                //       text: 'Already have an account?',
                //       style: kHaveAnAccountStyle(size),
                //       children: [
                //         TextSpan(
                //             text: " Login",
                //             style: kLoginOrSignUpTextStyle(size)),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // loginbutton
  Widget loginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          String email = emailController.text.trim();
          String password = passwordController.text.trim();
          _logIn(email, password);
        },
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
