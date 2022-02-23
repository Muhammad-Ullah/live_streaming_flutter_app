import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_streaming_flutter_app/firebase/authorization/authService.dart';
import 'package:live_streaming_flutter_app/firebase/signup.dart';
import 'package:live_streaming_flutter_app/frontEnd/homescreen/homeScreen.dart';
import 'package:live_streaming_flutter_app/helper/loading.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';
import 'package:live_streaming_flutter_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController =  TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  final AuthService2 _auth = AuthService2();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future signIn2() async {
    // works only and only if the validators return null
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try
      {
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword
        (email:emailEditingController.text,password:passwordEditingController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
        setState(() {
          isLoading = false;
        });

      } catch(e) {
        print(e.toString());
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: e.toString(),
          ),
        );
      }
    }
  }

  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //  Commented By Ashley
        // appBar: appBarMain(context),
        body: isLoading
            ? const Loading()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email"),
                            onChanged: (val) {
                              setState(
                                () {
                                  email = val;
                                },
                              );
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : "Enter Password 6+ characters";
                            },
                            style: simpleTextStyle(),
                            controller: passwordEditingController,
                            decoration: textFieldInputDecoration("password"),
                            onChanged: (value) {
                              setState(
                                () {
                                  password = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>const ForgotPassword()),
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Forgot Password?",
                                style: simpleTextStyle(),
                              )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin:EdgeInsets.only(top: MediaQuery.of(context).size.height*0.12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: OurTheme().mPurple,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child:(isLoading)?const Center(
                        child: CircularProgressIndicator(),
                      ) :TextButton(
                        onPressed: ()async => await signIn2(),
                        child: Text(
                          "Sign In",
                          style: biggerTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: simpleTextStyle(),
                        ),
                        InkWell(
                          onTap: () {
                            // widget.toggleView();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                                color: OurTheme().mPurple,
                                fontFamily: 'PopM',
                                fontSize: 17,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
      ),
    );
  }
}
