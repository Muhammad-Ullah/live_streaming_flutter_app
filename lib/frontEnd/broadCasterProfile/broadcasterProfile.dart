import 'package:cached_network_image/cached_network_image.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';
import 'package:live_streaming_flutter_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BroadCasterProfile extends StatelessWidget {
  final String bName;
  final String bImage;
  final String currentUser;
  final String uid;

  const BroadCasterProfile({Key? key, required this.bName, required this.bImage, required this.currentUser, required this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: OurTheme().mPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          key: null,
          imageUrl: bImage,
          imageBuilder: (context, imageProvider) => Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          bName,
          style: TextStyle(
              fontFamily: 'PopS',
              letterSpacing: 0.5,
              fontSize: 30,
              color: OurTheme().mPurple),
        ),
        const SizedBox(
          height: 30,
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   PageTransition(
            //       child: IndexPage(
            //         broadcaster: bName,
            //         currentUser: currentUser,
            //         uid: uid,
            //       ),
            //       type: PageTransitionType.leftToRight),
            // );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: OurTheme().mPurple,
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.video,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "One to One",
                  style: biggerTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
