import 'package:get/get.dart';
import 'package:expertsway/routes/routing_constants.dart';
import 'package:expertsway/theme/box_icons_icons.dart';
import 'package:expertsway/theme/config.dart' as config;
import 'package:expertsway/ui/widgets/card.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final bool long;
  const VideoCard({
    required this.long,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CardWidget(
        gradient: false,
        button: true,
        width: long ? 360 : 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: long ? 360 : 180,
              height: 87,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/video.jpg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Text(""),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Stars - What are they made up of ?",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(color: Color(0xFF535353), fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: const <Widget>[
                  Icon(BoxIcons.bx_bar_chart_alt_2, size: 16),
                  Text(
                    "Beginner",
                    style: TextStyle(color: Color(0xFFADADAD), fontSize: 10),
                  ),
                  Spacer(),
                  Text(
                    "12 mins",
                    style: TextStyle(color: Color(0xFFADADAD), fontSize: 10),
                  ),
                  Icon(BoxIcons.bx_timer, size: 16),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                  decoration: BoxDecoration(gradient: config.Colors().waves),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Icon(BoxIcons.bx_play_circle, color: Colors.white),
                      Text(
                        "Watch Lecture",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Get.toNamed(AppRoute.videoPage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
