import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_streaming_flutter_app/firebase/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_streaming_flutter_app/frontEnd/homescreen/homeScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp( const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({ key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
   String uid='';
bool getUid=false;
  late String username;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  Future<void> profile() async
  {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    uid=firebaseUser!.uid;
    print(uid);
    setState(() {
      getUid=true;
    });
    if(uid.isNotEmpty)
      {
        try
        {
          FirebaseFirestore.instance.collection('user_email').doc(uid).get().then((value) {
            username=value.data()!['username'];
          });
        }
        catch (e) {
          print("something went wrong");
        }
      }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    profile();
    switch (state) {
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        await FirebaseFirestore.instance.collection("liveuser").doc(username).delete().then((value) =>
            print("Success"));
        break;
      case AppLifecycleState.resumed:
        print('resumed');
        break;
      case AppLifecycleState.detached:
        print('detached');

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: BroadCasterProfile(),
        home:
        (uid=='')?(getUid==false)? const SignUp():const HomeScreen():const Center(
          child: CircularProgressIndicator(),
        )
    );
  }
}
