import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'register.dart';
import '../models/client.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? errorMsg;

  bool _validEmail = false;
  bool _hidePass = true;
  bool _loginResult = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool checkEmailField(String email) {
    if (email.length == 0) {
      return true;
    }
    bool checkEmail = EmailValidator.validate(email);
    if (checkEmail) {
      _validEmail = true;
    } else {
      _validEmail = false;
    }
    return checkEmail;
  }

  Future<void> loginButtonPress() async {
    if (_validEmail) {
      try {
        String token = await login(emailController.text, passController.text);
        Client client = await getClientFromEmail(emailController.text, token);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Homepage(client, token)));
      } catch (e) {
        errorMsg = e.toString();
      }
    }
    setState(() {});
  }

  void togglePass() {
    setState(() {
      _hidePass = !_hidePass;
    });
  }

  void openRegisterScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: TextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => checkEmailField(value!)
                    ? null
                    : "Introduceti o adresa de email valida.",
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: TextFormField(
                controller: passController,
                obscureText: _hidePass,
                decoration: InputDecoration(
                  hintText: "Parola",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: togglePass,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _hidePass ? Colors.grey : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              errorMsg ?? '',
              style: TextStyle(color: Colors.red),
            ),
            ElevatedButton(
              onPressed: loginButtonPress,
              child: Container(
                child: Text("Login"),
              ),
            ),
            ElevatedButton(
              onPressed: openRegisterScreen,
              child: Container(
                child: Text("Register"),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
