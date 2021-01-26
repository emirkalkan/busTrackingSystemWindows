import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';
import 'package:bus_tracking_system/tabs/DriverTabs/homeTabDriver.dart';
import 'package:bus_tracking_system/tabs/DriverTabs/profileTabDriver.dart';
import 'package:bus_tracking_system/tabs/DriverTabs/routeTabDriver.dart';
import 'package:bus_tracking_system/tabs/busStopTab.dart';
import 'package:bus_tracking_system/tabs/busTab.dart';
import 'package:bus_tracking_system/tabs/homeTab.dart';
import 'package:bus_tracking_system/tabs/profileTab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainPageDriver extends StatefulWidget {

  static const String id = 'mainPageDriver';

  @override
  _MainPageDriverState createState() => _MainPageDriverState();
}

class _MainPageDriverState extends State<MainPageDriver> with SingleTickerProviderStateMixin {

  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    HelperMethods.getDriverInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          RouteTabDriver(),
          HomeTabDriver(),
          ProfileTabDriver(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: BrandColors.colorIcon,
        selectedItemColor: BrandColors.colorGreen,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
      ),
    );
  }
}
