import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/dataModels/busStops.dart';
import 'package:bus_tracking_system/dataModels/routes.dart';
import 'package:bus_tracking_system/tabs/busStopTab.dart';
import 'package:flutter/material.dart';

class RouteDetailsPage extends StatefulWidget {

  final int indexRoute;
  RouteDetailsPage(this.indexRoute);

  @override
  _RouteDetailsPageState createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BrandColors.colorAccent,
          title: Text('Route ${widget.indexRoute+1} Details'),
        ),
        body: buildListView(context)
    );
  }

  ListView buildListView(BuildContext context){
    return ListView.builder(
      itemCount: (widget.indexRoute == 0) ? 10 : (widget.indexRoute == 1) ? 8 : 8,
      itemBuilder: (_, indexRoute) {
        return Card(
          child: ListTile(
            title: Text('Bus Stop Name ${indexRoute+1}'),
            subtitle:
              Text('Tap to get time details for this bus stop.'),
            leading: IconButton(
              icon:  Icon(Icons.account_balance),
              alignment: Alignment.center,
            ),
          ),
        );
      },
    );
  }
}
