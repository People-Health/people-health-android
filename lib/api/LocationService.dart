import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  Future<void> init() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LocationData> getLocation() async {
    return await location.getLocation();
  }
}
