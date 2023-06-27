import 'package:expertsway/theme/config.dart' as config;
import 'package:expertsway/ui/widgets/card.dart';
import 'package:expertsway/ui/widgets/section_header.dart';
import 'package:expertsway/ui/widgets/top_bar.dart';
import 'package:expertsway/ui/widgets/video_card.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PlannerPage extends StatelessWidget {
  PlannerPage({
    Key? key,
    required this.onMenuTap,
  }) : super(key: key);
  final Function()? onMenuTap;

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.Colors().secondColor(1),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFixedExtentList(
                    delegate: SliverChildListDelegate.fixed([Container()]),
                    itemExtent: MediaQuery.of(context).size.height * 0.16),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    text: 'Today\'s Work',
                    onPressed: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return const VideoCard(long: true);
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    text: 'Calendar',
                    onPressed: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 450,
                    child: CardWidget(
                      button: false,
                      gradient: false,
                      child: Material(
                        child: CalendarCarousel(
                          isScrollable: false,
                          todayButtonColor: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 70,
                    child: Text(""),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: TopBar(
              controller: controller,
              expanded: false,
              onMenuTap: onMenuTap,
            ),
          )
        ],
      ),
    );
  }
}
