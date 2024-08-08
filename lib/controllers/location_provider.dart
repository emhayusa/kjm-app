import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  bool _isGpsEnabled = false;
  bool _isLoading = true;
  String _errorMessage = "";

  final Location _location = Location();

  bool get isGpsEnabled => _isGpsEnabled;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  LocationData? _currentLocation;

  LocationData? get currentLocation => _currentLocation;

  LocationProvider() {
    _checkGpsStatus();
  }

  Future<void> _checkGpsStatus() async {
    try {
      _isGpsEnabled = await _location.serviceEnabled();
      if (_isGpsEnabled) {
        await _getCurrentLocation();
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Memeriksa apakah layanan lokasi telah diaktifkan
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Service not enabled');
        //return;
      }
    }

    // Memeriksa izin lokasi telah diberikan
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Permission not granted');
        //return;
      }
    }

    // Mendapatkan lokasi saat ini
    _currentLocation = await _location.getLocation();
  }

  Future<void> refreshLocation() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();
    await _checkGpsStatus();
  }
}
