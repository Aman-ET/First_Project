import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';




class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const String apiKey = "AIzaSyBRfgedyY2mY-CTOBEu9Bf-unhRbdXfpvc";
  static const LatLng source = LatLng(26.6062476, 79.4816371);
  static const LatLng dest = LatLng(26.4541141, 80.3478942);

  final Set<Marker> _markers = {
    const Marker(markerId: MarkerId('s'), position: source), // This one can stay const
    Marker( // Removed 'const' here
      markerId: const MarkerId('d'),
      position: dest,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  };

  Set<Polyline> _polylines = {};

  void _getPolyline() async {
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      googleApiKey: apiKey,
      request: PolylineRequest(
        origin: PointLatLng(source.latitude, source.longitude),
        destination: PointLatLng(dest.latitude, dest.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          points: result.points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
          color: Colors.blue, width: 5,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: source, zoom: 10),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (c) => _getPolyline(),
      ),
    );
  }
}


/*

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  final LatLng _start = LatLng(26.6062476, 79.4816371); // SF
  final LatLng _end = LatLng(26.4541141, 80.3478942);   // SJ


  // final LatLng _center = const LatLng(37.4279, -122.0857);
  LatLng? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // determinePosition();
    getRoute();
  }

  void getRoute() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyBRfgedyY2mY-CTOBEu9Bf-unhRbdXfpvc",
      request: PolylineRequest(
        origin: PointLatLng(_start.latitude, _start.longitude),
        destination: PointLatLng(_end.latitude, _end.longitude),
        mode: TravelMode.driving,
      ),

    );

    if (result.points.isNotEmpty) {
      List<LatLng> points = result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      setState(() {
        polylines[PolylineId("poly")] = Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.blue,
          points: points,
          width: 5,
        );
      });
    }
  }


  Future<void> determinePosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        getRoute();
      });
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps in Flutter'),
        elevation: 2,
      ),
      body: currentPosition == null
          ? Center(child: CircularProgressIndicator()):
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _start,
          zoom: 14.0,
        ),
        polylines: Set<Polyline>.of(polylines.values),

        markers: {
          Marker(
            markerId: MarkerId('unique_id_1'),
            position: currentPosition!,
            infoWindow: InfoWindow(
              title: 'Marker Title',
              snippet: 'A short description or address',
              onTap: () {
                // Action when the info window itself is tapped
                print('Info Window Tapped');
              },
            ),
            onTap: () {
              // Optional: Action when the marker is tapped
              print('Marker Tapped');
            },
          ),
        },
        // Enable common UI features
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}

*/
