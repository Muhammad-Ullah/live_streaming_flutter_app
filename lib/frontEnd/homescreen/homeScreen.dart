import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_streaming_flutter_app/agora/host.dart';
import 'package:live_streaming_flutter_app/agora/join.dart';
import 'package:live_streaming_flutter_app/frontEnd/homescreen/live.dart';
import 'package:live_streaming_flutter_app/frontEnd/userProfileScreen/userProfileScreen.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';
import 'package:live_streaming_flutter_app/widget/liveUserCard.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:live_streaming_flutter_app/helper/users.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   String _profileImageUrl='';
  final databaseReference = FirebaseFirestore.instance;
  List<Live> list = [];
  List<Live> list2 = [];
  late Live liveUser;
  var username;
  user_email pass=user_email(username: '', image: '', email: '', name: '');
  String uid=FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    currentUserProfile();
    super.initState();
    setState(() {
      dbChangeListen();
      dbChangeListen2();
    });

  }

  void connectionChecker()async
  {
  bool check=await DataConnectionChecker().hasConnection;
    if(check)
    {
      onCreate(username: pass.username, image: _profileImageUrl);
      print("Function called");

    }
    else
    {
    await  showAlertDialog(context);
    }

  }
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Connection Checker"),
      content: const Text("Make sure you have an internet connection"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<void> currentUserProfile()
  async {
    print("Current userprofile: $uid");
    try
    {
      FirebaseFirestore.instance.collection('user_email').doc(uid).get().then((value) {
        pass.name=value.data()!['name'];
        pass.email=value.data()!['email'];
        pass.image=value.data()!['image'];
        pass.username=value.data()!['username'];
        setState(() {
          _profileImageUrl=value.data()!['image'];
        });
      });
    }
    catch (e) {
      print("something went wrong");
    }
  }
  void dbChangeListen2() {
    databaseReference
        .collection('liveuser')
        .snapshots()
        .listen((result) {

      for (var result in result.docs) {
        setState(() {
          list2.add(Live(
              username: result.data()['name'],
              image: result.data()['image'],
              channelId: result.data()['channel'],
              me: false));
        });
      }
    });
  }

  void dbChangeListen() {
    databaseReference
        .collection('liveuser')
        .orderBy("time", descending: true)
        .snapshots().where((event) => "name"!=pass.name ?false:true)
        .listen((result) {
      for (var result in result.docs) {
        setState(() {
          list.add( Live(
              username: result.data()['name'],
              image: result.data()['image'],
              channelId: result.data()['channel'],
              me: false));
        });
      }
    });
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content:  const Text('Do you want to Exit the APP'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                elevation: 0.5,
                backgroundColor: Colors.white,
                title: Text(
                  "LIVE",
                  style: TextStyle(
                      color: OurTheme().mPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                centerTitle: true,
                actions: [
                  Container(
                    height: 30,
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserProfileScreen(userData: pass)),
                        );
                      },
                      child: CachedNetworkImage(
                        key: null,
                        imageUrl: (_profileImageUrl=='') ?
                            'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg':
                        _profileImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
                bottom: TabBar(
                  indicatorColor: Colors.transparent,
                  labelColor: OurTheme().mPurple,
                  unselectedLabelColor: OurTheme().secGrey,
                  labelStyle: const TextStyle(fontSize: 18, fontFamily: 'PopS'),
                  unselectedLabelStyle:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  tabs: const [
                    Tab(
                      text: "Trending",
                    ),
                    Tab(
                      text: "Recent",
                    ),
                  ],
                ),
              ),

              floatingActionButton: InkWell(
                onTap: () {
                  connectionChecker();

                },
                child: Container(
                  // height: 100.0,
                  decoration: BoxDecoration(
                    color: OurTheme().mPurple,
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  height: 50,
                  width: 150.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.video_call,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Go Live',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              body: TabBarView(
                children: [
                  Center(child: getStories2()),
                  Center(child: getStories()),
                ],
              )
            ),
        ),
      ),

    );
  }
  Widget getStories2() {
    return ListView(
        semanticChildCount: 2,
        scrollDirection: Axis.vertical,
        children: getUserStories2());
  }
  Widget getStories() {
    return ListView(
        semanticChildCount: 2,
        scrollDirection: Axis.vertical,
        children: getUserStories());
  }

  List<Widget> getUserStories() {

    List<Widget> stories = [];
    for (Live users in list) {
      stories.add(getStory(users));
    }
    return stories;
  }
  List<Widget> getUserStories2() {
    List<Widget> stories = [];
    for (Live users in list2) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(Live users) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Join function
              onJoin(
                  channelName: users.username,
                  channelId: users.channelId,
                  username: users.username,
                  hostImage: users.image,
                  userImage: _profileImageUrl);
            },
            child: Column(
              children: [
                //if (users.username!=_myName)
                  LiveUserCard(
                    broadName: users.username,
                    broadImage: users.image,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onJoin(
      {channelName, channelId, username, hostImage, userImage}) async {
    // update input validation
    if (channelName.isNotEmpty) {
      // push video page with given channel name
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Join(userId: uid, channelName: channelName, myImage: userImage, myName: username)),
      );

    }
  }


  Future<void> onCreate({username, image}) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    var currentTime = '$DateFormat("dd-MM-yyyy hh:mm:ss").format(date)';
    // push video page with given channel name

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>  Host(uid: uid, isBroadcaster: true, channelName: username,))
    );
  }

  Future<void> _handleCameraAndMic() async {
    await [Permission.camera, Permission.microphone].request();
  }
}
