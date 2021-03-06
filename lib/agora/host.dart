import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:hexcolor/hexcolor.dart';
import 'package:live_streaming_flutter_app/agora/utils/settings.dart';
import 'package:live_streaming_flutter_app/frontEnd/homescreen/homeScreen.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';



class Host extends StatefulWidget {
  final String uid;
  final String channelName;
  const Host({Key? key,required this.uid,required this.channelName}) : super(key: key);

  @override
  _HostState createState() => _HostState();
}

class _HostState extends State<Host> {
  final _users = <int>[];
  bool firstmsgadded=false;
  final _channelMessageController = TextEditingController();
  late RtcEngine _engine;
  bool muted = false;
  late int streamId;

  bool loading=false;
  bool get=true;
  int view=0;
  bool ending=false;
  late var result;
  late String img;
  bool msgAdded=false;
  bool tryingToEnd=false;


  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk and leave channel
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeAgora();
    getData();
  }
  void getData()async
  {
    var date = DateTime.now().microsecondsSinceEpoch;
    result= await FirebaseFirestore.instance.collection('user_email').doc(widget.uid).get();
    if(result.data()['name']!='')
    {
      img=result.data()['image'];
      try {
        await FirebaseFirestore.instance.collection('channels')
            .doc(widget.channelName)
            .set({
          'viewers': 0,
          'end': 0,
          'image': img,
          'channelname': widget.channelName,
          'time':date,
        });
        try{
          await FirebaseFirestore.instance.collection('channels').doc(widget.channelName).collection("Messages").add(
              {
                'image':'https://www.kindpng.com/picc/m/252-2524695_dummy-profile-image-jpg-hd-png-download.png',
                'name':widget.channelName,
                'message':"Live comments",
              });
          setState(() {
            firstmsgadded=true;
          });
        }catch(e)
        {
          setState(() {
            firstmsgadded=false;
          });
        }
      }catch(e)
      {
        print("Error khan");
        print(e.toString());
      }

      func();
      initializeAgora();
    }
  }
  Future<void> initializeAgora() async {
    await _initAgoraRtcEngine();

     streamId = (await _engine.createDataStream(false, false))!;

    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          print('onJoinChannel: $channel, uid: $uid');
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          _users.add(uid);
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          _users.remove(uid);
        });
      },
      streamMessage: (_, __, message) {
        final String info = "here is the message $message";
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
      },
    ));
    print("Ikram ${widget.channelName}");
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }


  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));
    await _engine.enableVideo();

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await _engine.setClientRole(ClientRole.Broadcaster);
  }


  @override
  Widget build(BuildContext context) {

    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body:(ending==false)? Center(
            child: (loading==false)?Stack(
              children: <Widget>[
                _broadcastView(),
                _toolbar(w,h),
              ],
            ):const CircularProgressIndicator(),
          ):const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  const Text('Are you sure?'),
        content:  const Text('Do you want to stop streaming'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _onCallEnd(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
  Widget _toolbar(double w,double h) {
    return  ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin:const EdgeInsets.only(top: 10,left: 15),
                width: w*0.18,
                height: 28,
                decoration: BoxDecoration(
                    color: HexColor('#f02e63'),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: w*0.06,
                      height: 30,
                      child: (get == true)
                          ? ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            Timer.periodic(const Duration(seconds: 5), (timer) {
                              func();
                            });
                            return  Text(' $view',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),);
                          })
                          : Container(),
                    ),
                    const Icon(Icons.remove_red_eye,color: Colors.white,)
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding:const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: const  Text(
                'LIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _endCall(),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: h*0.5),
          width: w*0.98,
          height: h*0.3,
          child:  (firstmsgadded==true)?StreamBuilder(
              stream: FirebaseFirestore.instance.collection('channels').doc(widget.channelName).collection('Messages').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<cf.QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No data found",style: TextStyle(color: Colors.red),),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage(document['image']),
                          ),
                          title: Text(document['name'],style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                          subtitle: Text(document['message'],style: const TextStyle(color: Colors.black,fontFamily: 'PopM')),
                        ));
                  }).toList(),
                );
              }):Container(),
        ),
        row(w,h),

      ],
    );
  }
  Widget _endCall() {
    return Container(
      margin: const EdgeInsets.only(top: 10,right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
              onTap: () async {
                _onWillPop();
              },
              child: Container(
                width: 60,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: const Center(
                    child: Text(
                      ' END ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'PopM'),
                    )),
              )),
        ],
      ),
    );
  }
  Widget row(double w,double h)
  {
    return Padding(
      padding:const EdgeInsets.only(top: 10),

      child: Row(
        children: [
          SizedBox(
            width: w*0.7,
            child: TextField(
                cursorColor: OurTheme().mPurple,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
                style: const TextStyle(color: Colors.white),
                controller: _channelMessageController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: ()
                    {
                      _sendMessage(_channelMessageController.text);
                    },
                    icon: const Icon(Icons.send_rounded,color:Colors.redAccent,),
                  ),
                  isDense: true,
                  hintText: 'Comment',
                  hintStyle: const TextStyle(color: Colors.redAccent),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: OurTheme().mPurple)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.white)),
                )),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 6,left: 10),
            width: w*0.1,
            child: RawMaterialButton(
              onPressed: _onToggleMute,
              child: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: muted ? Colors.white : Colors.blueAccent,
                size: 25.0,
              ),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: muted ? Colors.blueAccent : Colors.white,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 6,left: 5,right: 5),
            width: w*0.13,
            child: RawMaterialButton(
              onPressed: _onSwitchCamera,
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 25.0,
              ),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  void _sendMessage(text) async {
    if (text.isEmpty) {
      return;
    }
    if(msgAdded==false)
    {
      try
      {
        await FirebaseFirestore.instance.collection('channels').doc(widget.channelName).update({
          'msgadded':1
        });
        setState(() {
          msgAdded==true;
        });
      }catch(e)
      {
        print("Message not added");
      }
    }
    try {
      await FirebaseFirestore.instance.collection('channels').doc(widget.channelName).collection("Messages").add(
          {
            'image':img,
            'name':widget.channelName,
            'message':_channelMessageController.text,
          }

      );
      _channelMessageController.clear();


    } catch (errorCode) {
      print('Send channel message error: ' + errorCode.toString());
    }
  }


  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(rtc_local_view.SurfaceView());

    for (var uid in _users) {
      list.add(rtc_remote_view.SurfaceView(uid: uid));
    }
    return list;
  }

  /// Video view row wrapper
  Widget _expandedVideoView(List<Widget> views) {
    final wrappedViews = views.map<Widget>((view) => Expanded(child: Container(child: view))).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[
            _expandedVideoView([views[0]])
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoView([views[0]]),
            _expandedVideoView([views[1]])
          ],
        );
      case 3:
        return Column(
          children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 3))],
        );
      case 4:
        return Column(
          children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 4))],
        );
      default:
    }
    return Container();
  }

  void _onCallEnd(BuildContext context) {
    if (mounted){
      setState(() {
        ending = true;
      });
    }
    try
    {
      FirebaseFirestore.instance.collection("channels").doc(widget.channelName).update({
        'end':1,
      });

      Timer(
        const Duration(seconds: 5),
            () => FirebaseFirestore.instance.collection("channels").doc(widget.channelName).delete(),
      );
      FirebaseFirestore.instance.collection("channels").doc(widget.channelName).collection('Messages').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs){
          ds.reference.delete();
        }});
      Timer(
          const Duration(seconds: 5),
              () =>   Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ));
      setState(() {
        ending = false;
      });
    }
    catch(e)
    {
      print("Channel name cannot be deleted");
    }

  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    //  if (streamId != null) _engine?.sendStreamMessage(streamId, "mute user blet");
    _engine.switchCamera();
  }
  Future<void> func()
  async {
    var res = await FirebaseFirestore.instance
        .collection('channels')
        .doc(widget.channelName)
        .get();
    if(res.data()!=null)
    {
        setState(() {
          view = res.data()!['viewers'];
        });

    }

  }

}
