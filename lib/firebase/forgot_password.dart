import 'package:live_streaming_flutter_app/helper/ourTheme.dart';
import 'package:live_streaming_flutter_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String assetName = 'assets/forgot_password.svg';
  final Widget svgIcon = SvgPicture.asset(
    'assets/forgot_password.svg',
    semanticsLabel: 'A red up arrow',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(height: 300, child: svgIcon),
              Text(
                "Forgot Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'PopM',
                    color: OurTheme().mPurple),
              ),
              const Text(
                "Enter your registered Email to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontFamily: 'PopM'),
              ),
              const SizedBox(
                height: 10,
              ),
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
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: OurTheme().mPurple,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Reset Password",
                    style: biggerTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
