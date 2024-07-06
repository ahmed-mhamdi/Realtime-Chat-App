import 'package:chat_app_material3/Widgets/custom_form_field.dart';
import 'package:chat_app_material3/consts.dart';
import 'package:chat_app_material3/services/alert_service.dart';
import 'package:chat_app_material3/services/auth_service.dart';
import 'package:chat_app_material3/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  String? email, password;

  late AuthService _authService;
  late NavigationService _navigationService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: [_headerText(), _loginForm(), _createAcountLink()],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomFormField(
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                hintText: "Email",
                validationRegEx: EMAIL_VALIDATION_REGEX,
                height: MediaQuery.of(context).size.height * 0.09),
            CustomFormField(
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                hintText: "Password",
                validationRegEx: PASSWORD_VALIDATION_REGEX,
                obscuredText: true,
                height: MediaQuery.of(context).size.height * 0.09),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  if (_loginFormKey.currentState?.validate() ?? false) {
                    _loginFormKey.currentState?.save();
                    bool result = await _authService.login(email!, password!);
                    print(result);
                    if (result) {
                      _navigationService.pushReplacementNamed("/home");
                    } else {
                      GetIt.instance.get<AlertService>().showAlert(
                          content: "Failed to login, Please try again!",
                          icon: Icons.error);
                    }
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Column(
        children: [
          Text(
            "Login",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text("Hello! you've been missed!", style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }

  Widget _createAcountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Don't have an account?",
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            GetIt.instance.get<NavigationService>().pushNamed("/signup");
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
        )
      ],
    ));
  }
}
