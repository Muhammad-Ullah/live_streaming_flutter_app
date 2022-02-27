import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_streaming_flutter_app/firebase/authorization/authService.dart';
import 'package:live_streaming_flutter_app/firebase/signin.dart';
import 'package:live_streaming_flutter_app/frontEnd/homescreen/homeScreen.dart';
import 'package:live_streaming_flutter_app/helper/loading.dart';
import 'package:live_streaming_flutter_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController =  TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController _nameController =  TextEditingController();
  late File _image;
  bool imagePicked=false;
  signUp2() async {
    // ignore: unnecessary_null_comparison
    if (imagePicked==false) {
      setState(() {
        isLoading = false;
      });
      imageDialog();
      return;
    }
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final pass = passwordEditingController.text.toString().trim();
      final email = emailEditingController.text.toString().trim();
      final name = _nameController.text.toString().trim();
      final username = usernameEditingController.text.toString().trim();
       try{
         await _auth.registerUser(
             email: email,
             name: name,
             username: username,
             pass: pass,
             image: _image);
         setState(() {
           isLoading = false;
         });
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const HomeScreen()),
         );
       }catch(e)
    {
      print("Error");
      print(e.toString());
    }

    }
  }


  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: appBarMain(context),
      body: isLoading
          ? const Loading()
          : SingleChildScrollView(
              // padding: EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              chooseFile();
                            },
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              // ignore: unnecessary_null_comparison
                              child: (imagePicked==false)?Container(
                                padding: const EdgeInsets.all(10),
                                width: w * 0.35,
                                height: h * 0.18,
                                decoration: BoxDecoration(
                                  color: OurTheme().ourGrey,
                                  shape: BoxShape.circle,
                                ),
                                child:  Icon(
                                  Icons.add_a_photo, size: w * 0.26, color: Colors.white,),
                              ): CircleAvatar(
                                backgroundColor: Colors.black12,
                                backgroundImage:FileImage(_image),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            style: simpleTextStyle(),
                            controller: _nameController,
                            validator: (val) {
                              return val!.isEmpty || val.length < 3
                                  ? "Enter Full Name"
                                  : null;
                            },
                            decoration: textFieldInputDecoration("Full Name"),
                          ),
                          TextFormField(
                            style: simpleTextStyle(),
                            controller: usernameEditingController,
                            validator: (val) {
                              return val!.isEmpty || val.length < 3
                                  ? "Enter Username 3+ characters"
                                  : null;
                            },
                            decoration: textFieldInputDecoration("username"),
                          ),
                          TextFormField(
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Enter correct email";
                            },
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password"),
                            controller: passwordEditingController,
                            validator: (val) {
                              return val!.length < 6
                                  ? "Enter Password 6+ characters"
                                  : null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: OurTheme().mPurple,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: isLoading
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : TextButton(
                        onPressed: ()
                       async {
                           await signUp2();
                        },
                            child: Text(
                                "Sign Up",
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
                          "Already have an account? ",
                          style: simpleTextStyle(),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: const SignIn(),
                                    type: PageTransitionType.leftToRight));
                          },
                          child: Text(
                            "Sign In now",
                            style: TextStyle(
                                color: OurTheme().mPurple,
                                fontFamily: 'PopM',
                                fontSize: 17,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    // Spacer(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future chooseFile() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imagePicked=true;
      } else {
        print('No image selected.');
      }
    });
  }

  void imageDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height:MediaQuery.of(context).size.height*0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Select Image',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Image is not selected for avatar.",
                    style: TextStyle(color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Try Again',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
