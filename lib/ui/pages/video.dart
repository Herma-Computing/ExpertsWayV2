import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expertsway/theme/box_icons_icons.dart';
import 'package:expertsway/ui/widgets/card.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  // final comment = comments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colorss().secondColor(1),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: const Icon(BoxIcons.bx_share_alt),
              onPressed: () {},
            ),
          ]),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image(
                        image: ResizeImage(
                          const AssetImage('assets/images/video.jpg'),
                          height: MediaQuery.of(context).size.width ~/ 2,
                          width:
                              (MediaQuery.of(context).size.height * 0.5) ~/ 2,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 10, 8, 8.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 4,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(500),
                                      color: const Color(0xFF343434)),
                                  child: const Text(""),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Revision - Kinematics",
                                    style: TextStyle(
                                        color: Color(0xFF343434), fontSize: 24),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(BoxIcons.bx_bar_chart_alt_2,
                                      size: 20, color: Color(0xFFADADAD)),
                                ),
                                Text(
                                  "Beginner",
                                  style: TextStyle(
                                      color: Color(0xFFADADAD), fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  "12 mins",
                                  style: TextStyle(
                                      color: Color(0xFFADADAD), fontSize: 14),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(BoxIcons.bx_timer,
                                      size: 20, color: Color(0xFFADADAD)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: const Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ut odio id urna ornare rhoncus. Fusce egestas tellus vitae elit pellentesque, sit amet gravida metus consectetur. Sed in hendrerit elit. Phasellus ullamcorper vulputate ex quis consequat. Aenean fringilla vulputate egestas. Aenean nec mattis turpis. Aenean a faucibus purus, in pulvinar velit. Nulla efficitur erat commodo.",
                              style: TextStyle(
                                  color: Color(0xFF343434), fontSize: 16),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsetsDirectional.only(
                              end: 170,
                            ),
                            // width: 200,
                            // height: 60,
                            // color: material.Colors.cyan,
                            child: GestureDetector(
                              // onTap: () => Navigator.push(
                                // context,
                                // MaterialPageRoute(
                                //     builder: (context) =>
                                        // const MyWidgetComment()),
                              // ),
                              child: Row(
                                children: const [
                                   SizedBox(
                                    width: 15,
                                  ),
                                   Icon(
                                    BoxIcons.bx_comment,
                                    size: 22,
                                  ),
                                   Text(
                                    "comments",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 80, 80, 80),
                                    ),
                                  ),
                                   SizedBox(
                                    width: 15,
                                  ),
                                   Text(
                                    // comment.length.toString(),
                                    '12', // this is hardcoded. it should be changed.
                                    style:  TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 80, 80, 80),
                                    ),
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
                Positioned(
                    right: 30,
                    top: MediaQuery.of(context).size.height * 0.465,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFABDCFF),
                              Color(0xFF0396FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 25,
                                color: const Color(0xFF03A9F4).withOpacity(0.4),
                                offset: const Offset(0, 4))
                          ],
                          borderRadius: BorderRadius.circular(500)),
                      child: FloatingActionButton(
                          heroTag: "video",
                          elevation: 0,
                          highlightElevation: 0,
                          backgroundColor: Colors.transparent,
                          child: const Icon(BoxIcons.bx_play, size: 40),
                          onPressed: () {}),
                    )),
              ],
            )),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CardWidget(
              button: true,
              gradient: true,
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Attempt Test",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(BoxIcons.bx_pencil, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
