import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  final String user_id;
  MyMap(this.user_id);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;

  static const LatLng from = LatLng(37.33500926, -122.03272188);
  static const LatLng to = LatLng(37.33429383, -122.06600055);

  List<LatLng> polyLinePath = [];
  getPolyLine() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyBMUJHlOIhv12hVN2W9yTQWWRuJaHe0nqw',
        PointLatLng(from.latitude, from.longitude),
        PointLatLng(to.latitude, to.longitude));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLinePath.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  @override
  void initState() {
    // getPolyLine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        compassEnabled: 
        true,
        zoomControlsEnabled: false,
        markers: {
          // Marker(
          //     position: LatLng(
          //       snapshot.data!.docs.singleWhere(
          //           (element) => element.id == widget.user_id)['latitude'],
          //       snapshot.data!.docs.singleWhere(
          //           (element) => element.id == widget.user_id)['longitude'],
          //     ),
          //     markerId: MarkerId('id'),
          //     icon: BitmapDescriptor.defaultMarkerWithHue(
          //         BitmapDescriptor.hueMagenta)),
          Marker(
            position: from,
            markerId: MarkerId('from'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
          Marker(
            position: to,
            markerId: MarkerId('to'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('rute'),
            color: Colors.deepPurple,
            width: 6,
            points: polyLinePath,
          ),
        },
        initialCameraPosition: CameraPosition(
            target: from,

            // target: LatLng(
            //   snapshot.data!.docs.singleWhere(
            //       (element) => element.id == widget.user_id)['latitude'],
            //   snapshot.data!.docs.singleWhere(
            //       (element) => element.id == widget.user_id)['longitude'],
            // ),
            zoom: 13.5),
        // onMapCreated: (GoogleMapController controller) async {
        //   setState(() {
        //     _controller = controller;
        //     _added = true;
        //   });
        // },
      ),

      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('location').snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (_added) {
      //       mymap(snapshot);
      //     }
      //     if (!snapshot.hasData) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     return GoogleMap(
      //       mapType: MapType.normal,

      //       markers: {
      //         // Marker(
      //         //     position: LatLng(
      //         //       snapshot.data!.docs.singleWhere(
      //         //           (element) => element.id == widget.user_id)['latitude'],
      //         //       snapshot.data!.docs.singleWhere(
      //         //           (element) => element.id == widget.user_id)['longitude'],
      //         //     ),
      //         //     markerId: MarkerId('id'),
      //         //     icon: BitmapDescriptor.defaultMarkerWithHue(
      //         //         BitmapDescriptor.hueMagenta)),
      //         Marker(
      //           position: from,
      //           markerId: MarkerId('from'),
      //           icon: BitmapDescriptor.defaultMarkerWithHue(
      //               BitmapDescriptor.hueRed),
      //         ),
      //         Marker(
      //           position: to,
      //           markerId: MarkerId('to'),
      //           icon: BitmapDescriptor.defaultMarkerWithHue(
      //               BitmapDescriptor.hueBlue),
      //         ),
      //       },
      //       polylines: {
      //         Polyline(
      //           polylineId: PolylineId('rute'),
      //           color: Colors.deepPurple,
      //           width: 6,
      //           points: polyLinePath,
      //         ),
      //       },
      //       initialCameraPosition: CameraPosition(
      //           target: from,

      //           // target: LatLng(
      //           //   snapshot.data!.docs.singleWhere(
      //           //       (element) => element.id == widget.user_id)['latitude'],
      //           //   snapshot.data!.docs.singleWhere(
      //           //       (element) => element.id == widget.user_id)['longitude'],
      //           // ),
      //           zoom: 13.5),
      //       // onMapCreated: (GoogleMapController controller) async {
      //       //   setState(() {
      //       //     _controller = controller;
      //       //     _added = true;
      //       //   });
      //       // },
      //     );
      //   },
      // ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.47)));
  }
}
