import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum LocationStatus { granted, denied, permanentlyDenied }

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}

Future<Position> getLocation(BuildContext context) async {
  // Check current permission
  PermissionStatus status = await Permission.locationWhenInUse.status;

  if (status.isDenied) {
    status = await Permission.locationWhenInUse.request();
  }

  // Permanently denied
  if (status.isPermanentlyDenied) {
    await Get.dialog(
      AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
          "Location permission is permanently denied. Please enable it in app settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Open Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );

    throw LocationException("Location permission permanently denied");
  }

  // Denied
  if (status.isDenied) {
    await Get.dialog(
      AlertDialog(
        title: const Text("Location Permission Denied"),
        content: const Text(
          "Location permission is denied. The app cannot get your location.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    throw LocationException("Location permission denied");
  }

  // Check if GPS service is enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Get.dialog(
      AlertDialog(
        title: const Text("Location Services Disabled"),
        content: const Text("Please enable location services to continue."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );

    throw LocationException("Location services are disabled");
  }

  // Check Geolocator permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw LocationException("Geolocator permission denied");
    }
  }

  // Everything ok → return position
  return await Geolocator.getCurrentPosition();
}
