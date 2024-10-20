import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_store_app/src/controllers/tabbar_controller.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/discussion.dart';
import 'package:pet_store_app/src/screens/bottomNavBar/screens/tabbar/videos.dart';

class PetCommunity extends StatelessWidget {
  const PetCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabBarController());

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Feeds'),
              Tab(text: 'Videos'),
            ],
            controller: controller.tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children:  [
                DiscussionScreen(),
                VideosScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
