import 'package:flutter/material.dart';

class TabBarr extends StatelessWidget {
  const TabBarr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TabController? tabController = DefaultTabController.of(context); // Get the TabController
    return TabBar(
      controller: tabController,
      dividerColor: Colors.transparent,
      indicatorColor: const Color(0xFFFF9900), // Primary color
      indicatorWeight: 3.0,
      tabs: const [
        // Use Image.asset for the first Tab
        Tab(
          child: Image(
            image: AssetImage('assets/icons/tab1.png'),
            height: 24, // Set image size if needed
            width: 24,
          ),
        ),
        Tab(
          child: Image(
            image: AssetImage('assets/icons/tab2.png'),
            height: 24, // Set image size if needed
            width: 24,
          ),
        ),
        Tab(
          child: Image(
            image: AssetImage('assets/icons/tab3.png'),
            height: 24, // Set image size if needed
            width: 24,
          ),
        ),
        Tab(
          child: Image(
            image: AssetImage('assets/icons/tab4.png'),
            height: 24, // Set image size if needed
            width: 24,
          ),
        ),
      ],
    );
  }
}
