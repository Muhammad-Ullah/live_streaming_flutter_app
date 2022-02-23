import 'package:live_streaming_flutter_app/firebase/authorization/authService.dart';
import 'package:live_streaming_flutter_app/helper/users.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';
import 'package:flutter/material.dart';


class UserProfileScreen extends StatefulWidget {
  final user_email userData;
  const UserProfileScreen({Key? key, required this.userData}) : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {



  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: OurTheme().mPurple,
          ),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
              color: OurTheme().mPurple,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.userData.image),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    cursorColor: OurTheme().mPurple,
                    initialValue: widget.userData.username,
                    onChanged: (val) {

                    },
                    style: TextStyle(
                        fontFamily: 'PopM',
                        fontSize: 19,
                        color: Colors.grey[800]),
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      // hintText: 'Enter your Full Name',
                      labelStyle: TextStyle(
                          fontSize: 15,
                          color: myFocusNode.hasFocus
                              ? Colors.blue
                              : Colors.grey[700]),

                      labelText: 'User Name',
                      fillColor: Colors.grey[200],
                      focusColor: Colors.grey[800],
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    cursorColor: OurTheme().mPurple,
                    initialValue: widget.userData.email,
                    onChanged: (val) {

                    },
                    style: TextStyle(
                        fontFamily: 'PopM',
                        fontSize: 19,
                        color: Colors.grey[800]),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          fontSize: 15,
                          color: myFocusNode.hasFocus
                              ? Colors.blue
                              : Colors.grey[700]),
                      labelText: 'User Email',
                      fillColor: Colors.grey[200],
                      focusColor: Colors.grey[800],
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 30,
                ),


                InkWell(
                  onTap: () async {
                    await AuthService2().signOut();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: OurTheme().ourGrey, width: 3),
                      // color: OurTheme().mPurple,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                          color: OurTheme().ourGrey,
                          fontSize: 17,
                          fontFamily: 'PopS'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
