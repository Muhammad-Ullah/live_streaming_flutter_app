
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';

class LiveUserCard extends StatelessWidget {
  final String broadName;
  final String broadImage;
   const LiveUserCard({Key? key, required this.broadImage, required this.broadName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      // width: 160,
      child: Container(
        margin: const EdgeInsets.only(
          top: 10.0,
          left: 2.0,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[50],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              child: Stack(
                children: [
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          broadImage,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5.0, top: 5.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 30,
                          // margin: EdgeInsets.only(left: 5.0, top: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: OurTheme().mPurple,
                          ),
                          child: const Center(
                            child: Text(
                              "Live",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          // margin: EdgeInsets.only(left: 5.0, top: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.eye,
                                  size: 22.0,
                                  color: OurTheme().mPurple,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      broadName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'PopM',
                          color: OurTheme().ourGrey,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 5.0),
            //   child: Row(
            //     children: [
            //       Flexible(
            //           child: Text(
            //         video.subTitle,
            //         overflow: TextOverflow.ellipsis,
            //         style: TextStyle(
            //             fontFamily: 'PopM',
            //             color: OurTheme().secGrey,
            //             fontSize: 13),
            //       )),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
