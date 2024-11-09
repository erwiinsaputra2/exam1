import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'user_model.dart';

class DetailsScreen extends StatelessWidget {
  final User user;
  DetailsScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(user.address.geo.lat, user.address.geo.lng),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId(user.id.toString()),
            position: LatLng(user.address.geo.lat, user.address.geo.lng),
            infoWindow: InfoWindow(
              title: user.address.city,
              snippet: '${user.address.street}, ${user.address.zipcode}',
            ),
          ),
        },
      ),
    );
  }
}
