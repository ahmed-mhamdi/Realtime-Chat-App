import 'dart:io';

import 'package:chat_app_material3/models/user_model.dart';
import 'package:chat_app_material3/services/auth_service.dart';
import 'package:chat_app_material3/services/db_service.dart';
import 'package:chat_app_material3/services/media_service.dart';
import 'package:chat_app_material3/services/navigation_service.dart';
import 'package:chat_app_material3/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/custom_form_field.dart';
import '../consts.dart';
import '../services/alert_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey();
  File? _selectedImage;
  String? name, email, password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign Up',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: !isLoading
          ? _body()
          : Center(child: const CircularProgressIndicator()),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_headerText(), _signupForm(), _loginLink()],
        ),
      ),
    );
  }

  Widget _loginLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Already have an account?",
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            GetIt.instance.get<NavigationService>().pushNamed("/login");
          },
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
        )
      ],
    ));
  }

  Widget _signupForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05),
      child: Form(
        key: _signupFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _profileImageSelector(),
            CustomFormField(
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
                hintText: "Name",
                validationRegEx: NAME_VALIDATION_REGEX,
                height: MediaQuery.of(context).size.height * 0.09),
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
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    if (_signupFormKey.currentState?.validate() ?? false) {
                      _signupFormKey.currentState?.save();
                      bool result = await GetIt.instance
                          .get<AuthService>()
                          .signup(email: email!, password: password!);
                      if (result) {
                        String? profilePhotoUrl = await GetIt.instance
                            .get<StorageService>()
                            .uploadUserProfilePhoto(
                                file: _selectedImage!,
                                uid: GetIt.instance
                                    .get<AuthService>()
                                    .user!
                                    .uid);
                        if (profilePhotoUrl != null) {
                          await GetIt.instance
                              .get<DbService>()
                              .createUserProfile(
                                  userModel: UserModel(
                                      uid: GetIt.instance
                                          .get<AuthService>()
                                          .user!
                                          .uid,
                                      name: name,
                                      profilePhotoURL: profilePhotoUrl));
                          GetIt.instance.get<AlertService>().showAlert(
                              content:
                                  "Congrats! You have successfully created your account!",
                              title: "Success",
                              icon: Icons.check);
                          GetIt.instance.get<NavigationService>().back();
                          GetIt.instance
                              .get<NavigationService>()
                              .pushReplacementNamed("/home");
                        } else {
                          throw Exception("Unable to upload profile photo!");
                        }
                      } else {
                        throw Exception("Unable to sign up!");
                      }
                    }
                  } catch (e) {
                    GetIt.instance.get<AlertService>().showAlert(
                        content: "Failed to signup! Please try again.",
                        title: "Failure",
                        icon: Icons.error);
                    print(e);
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _profileImageSelector() {
    return InkWell(
      onTap: () async {
        File? file =
            await GetIt.instance.get<MediaService>().selectImageFromGallery();
        if (file != null) {
          setState(() {
            _selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: _selectedImage != null
            ? FileImage(_selectedImage!)
            : const NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Text(
        "Create your new account!",
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}
