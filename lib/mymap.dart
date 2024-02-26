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

  static const LatLng from = LatLng(1.0374038854285719, 104.05531512880482);
  //1.0374038854285719, 104.05531512880482 salon depi
  static const LatLng to = LatLng(1.140088222477418, 104.01864322505489);
  //1.140088222477418, 104.01864322505489 satnusa

  PolylineResult? dataTracking = null;

  List<LatLng> polyLinePath = [];
  getPolyLine() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyC6LgH8lt4IILgH2KaM-Nk9V2jcpomkiu4',
        // punya galih AIzaSyC6LgH8lt4IILgH2KaM-Nk9V2jcpomkiu4
        PointLatLng(from.latitude, from.longitude),
        PointLatLng(to.latitude, to.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLinePath.add(LatLng(point.latitude, point.longitude));
      });
    }
    dataTracking = result;
    setState(() {});
  }

  @override
  void initState() {
    getPolyLine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.not_listed_location_sharp),
        onPressed: () {
          showModalBottomSheet(
            showDragHandle: true,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    listDetail(
                        icon: Icon(
                          Icons.timer_sharp,
                          color: Colors.blue,
                        ),
                        title: "Duration",
                        descp: "${dataTracking!.duration ?? "-"}"),
                    SizedBox(height: 10),
                    listDetail(
                        icon: Icon(
                          Icons.straighten_rounded,
                          color: Colors.purple,
                        ),
                        title: "Distance",
                        descp: "${dataTracking!.distance ?? "-"}"),
                    SizedBox(height: 10),
                    listDetail(
                        icon: Icon(
                          Icons.home_outlined,
                          color: Colors.green,
                        ),
                        title: "Start",
                        descp: "${dataTracking?.startAddress ?? "-"}"),
                    SizedBox(height: 10),
                    listDetail(
                        icon: Icon(
                          Icons.home_work_outlined,
                          color: Colors.pink,
                        ),
                        title: "End",
                        descp: "${dataTracking?.endAddress ?? "-"}"),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        compassEnabled: true,
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
            flat: true,
            infoWindow: InfoWindow(title: "Salon Mudi Suwarno"),
            position: from,
            markerId: MarkerId('from'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
          Marker(
            infoWindow: InfoWindow(title: "PT. Satnusa"),
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
            zoom: 15),
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

  Row listDetail(
      {required Icon icon, required String title, required String descp}) {
    return Row(
      children: [
        icon,
        SizedBox(width: 10),
        Flexible(fit: FlexFit.tight, flex: 1, child: Text(title)),
        SizedBox(width: 12),
        Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: Text(
              descp,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )),
      ],
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
