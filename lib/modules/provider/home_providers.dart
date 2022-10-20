import 'dart:developer';

import 'package:circuit4driver/models/location_model.dart';
import 'package:circuit4driver/utils/constFile.dart';
import 'package:circuit4driver/utils/distance_calculator.dart';
import 'package:circuit4driver/utils/map_service.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeProvider with ChangeNotifier {
  BuildContext context;

  init({BuildContext context}) {
    this.context = context;
  }

  bool loading = false;
  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool pathLoading = false;
  setpathLoading(bool value) {
    pathLoading = value;
    notifyListeners();
  }

  var timeFormat = DateFormat.jm();

  bool mapTypeValue = false;
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  GoogleMapController myController;
  Completer<GoogleMapController> _controller = Completer();
  LatLng currentLaltg;
  var currentAddress;
  final LatLng center = const LatLng(45.521563, -122.677433);
  final Set<Marker> markers = Set();
  Set<Polyline> polyline = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();
// One Parking Veriables and Required Functions

  List<LocationModel> locationList = [];
  RxInt startIndex = 0.obs;
  RxInt endIndex = 0.obs;

  var renternCurrentLoaction;
  var renternCurrentLoactionAddres;
  double oneAddressLat;
  double oneAddressLong;

  String locationDescription;
  String locationperiority;
  String locationTypeofRide;
  String locationArrivedbetweenStart;
  String locationArrivedbetweenEnd;
  int locationTimeAtStop;
  String locationPlaceinVehicleFirst;
  String locationPlaceinVehicleSecond;
  String locationPlaceinVehicleThird;

  setSingleValue(locationresult) async {
    renternCurrentLoaction = locationresult;
    renternCurrentLoactionAddres = renternCurrentLoaction.formattedAddress;
    oneAddressLat = renternCurrentLoaction.geometry.location.lat;
    oneAddressLong = renternCurrentLoaction.geometry.location.lng;

    log('parkingAddressLong = $oneAddressLong');
    log('parkingAddressLat = $oneAddressLat');
    log('renteraddress = ${renternCurrentLoaction.formattedAddress}');

    var distance = await calculateDistanceInKM(
        LatLng(locationList[locationList.length - 1].locationLat,
            locationList[locationList.length - 1].locationLong),
        LatLng(oneAddressLat, oneAddressLong));

    var rideTime = await calculateETAInMinutes(distance, 30);
    debugPrint('distance_________________________: ${distance}');
    locationList.add(
      LocationModel(
        locationAddress: renternCurrentLoactionAddres,
        locationLat: oneAddressLat,
        locationLong: oneAddressLong,
        locationDescription: '',
        locationperiority: 'Normal',
        locationPlaceinVehicleFirst: 'Front',
        locationPlaceinVehicleSecond: 'Left',
        locationPlaceinVehicleThird: 'Floor',
        locationArrivedbetweenStart: 'Now',
        locationArrivedbetweenEnd: 'Anytime',
        locationTimeAtStop: 1,
        locationTypeofRide: 'Delivery',
        timeofLocationSet: rideTime.toStringAsFixed(1),
        distance: distance == null ? "0.0" : distance.toStringAsFixed(1),
      ),
    );

    log('locationList length = ${locationList.length}');
    notifyListeners();
  }

  locatePosition() async {
    print('i am in the location function');
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      print("Location is Off =======================>>");
    } else {
      print("Location is ON =======================>>");
      // Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      print('location 1 ');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      print('location 2 ');
      print('position: $position');
      var currentPosition = position;
      currentLaltg = LatLng(position.latitude, position.longitude);
      print('currentLaltg: $currentLaltg');

      CameraPosition cameraPosition =
          CameraPosition(target: currentLaltg, zoom: 14);

      // CameraPosition cameraPosition =
      //     CameraPosition(target: emulatorCurrentLocation, zoom: 14);
      myController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      print('Marker is going to add ');

      addmarkers(currentLaltg);

      // List placemarks =
      //     await placemarkFromCoordinates(52.2165157, 6.9437819);

      print('Marker is added ');
      print('add current location also in list');
      await locationList.add(
        LocationModel(
          locationAddress: "Current Address",
          locationLat: currentLaltg.latitude,
          locationLong: currentLaltg.longitude,
          locationDescription: '',
          locationperiority: 'Normal',
          locationPlaceinVehicleFirst: 'Front',
          locationPlaceinVehicleSecond: 'Left',
          locationPlaceinVehicleThird: 'Floor',
          locationArrivedbetweenStart: 'Now',
          locationArrivedbetweenEnd: 'Anytime',
          locationTimeAtStop: 1,
          locationTypeofRide: 'Delivery',
          timeofLocationSet: "0",
          distance: "0.0",
        ),
      );
      notifyListeners();
    }
  }

  void addmarkers(showLocation) async {
    final Uint8List markerIcon =
        await MapServices.getMarkerWithSizeandWithoutContedt(
            60, "assets/images/0.png");

    markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: showLocation,
        infoWindow: const InfoWindow(title: 'Driver'),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker,
        //  BitmapDescriptor.fromBytes(markerIcon),
      ),
    );

    notifyListeners();
  }

  void drawParkingMarker() async {
    setpathLoading(true);
    print('drawParkingMarker function running');
    // final Uint8List markerIcon = await MapServices.getMarkerWithSize(80);

    markers.clear();
    String img = await "assets/images/${locationList.length - 1}.png";

    final Uint8List markerIcon =
        await MapServices.getMarkerWithSizeandWithoutContedt(60, img);
    await markers.add(
      Marker(
        onTap: () {
          log('Marker Added End');
        },
        markerId: MarkerId("1"),
        position: LatLng(
          locationList[locationList.length - 1].locationLat,
          locationList[locationList.length - 1].locationLong,
        ),
        infoWindow: InfoWindow(
            title: locationList[locationList.length - 1].locationAddress),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    );

    // locationList.forEach((element) async {
    //   var latitude = element.locationLat;
    //   var longitude = element.locationLong;
    //   var locationId = element.locationAddress;

    //   String img = "assets/images/m.png" ;

    //   final Uint8List markerIcon =
    //     await MapServices.getMarkerWithSizeandWithoutContedt(60, img);

    //   markers.add(
    //     Marker(
    //       onTap: () {
    //         log('Marker Added');
    //       },
    //       markerId: MarkerId(element.locationAddress),
    //       position: LatLng(latitude, longitude),
    //       infoWindow: InfoWindow(title: element.locationAddress),
    //       draggable: false,
    //       zIndex: 2,
    //       flat: true,
    //       anchor: const Offset(0.5, 0.5),
    //       icon: latitude == locationList[0].locationLat
    //           ? BitmapDescriptor.defaultMarker
    //           : BitmapDescriptor.fromBytes(markerIcon),
    //     ),
    //   );

    //   addCustomWindow(
    //     LatLng(latitude, longitude),
    //   );
    // });
    // allMarkerAdded = true;

    var lastLocation = locationList.last;
    var firstlocation = locationList.first;
    log(lastLocation.locationAddress);
    log(lastLocation.locationAddress);

    for (var i = 0; i < locationList.length; i++) {
      var latitude = locationList[i].locationLat;
      var longitude = locationList[i].locationLong;
      var locationId = locationList[i].locationAddress;

      String img = await "assets/images/$i.png";

      final Uint8List markerIcon =
          await MapServices.getMarkerWithSizeandWithoutContedt(60, img);

      await markers.add(
        Marker(
          onTap: () {
            log('Marker Added');
          },
          markerId: MarkerId(locationList[i].locationAddress),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: locationList[i].locationAddress),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: latitude == locationList[0].locationLat
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.fromBytes(markerIcon),
        ),
      );

      await setPolylineOnMap(
        locationList[i].locationLat,
        locationList[i].locationLong,
        i == locationList.length
            ? locationList[locationList.length].locationLat
            : locationList[i + 1].locationLat,
        i == locationList.length
            ? locationList[locationList.length].locationLong
            : locationList[i + 1].locationLong,
      );
    }

    notifyListeners();
  }

  checkBoolAndDeliveryType(
    int indexval,
    String stringVal,
  ) {
    log('Before Change locationperiority = ' +
        locationList[indexval].locationperiority);
    locationList[indexval].locationperiority = stringVal;
    log('After Change locationperiority = ' +
        locationList[indexval].locationperiority);
    notifyListeners();
  }

  checkTypeofRide(int indexval, String stringVal) {
    log('Before Change locationTypeofRide = ' +
        locationList[indexval].locationTypeofRide);
    locationList[indexval].locationTypeofRide = stringVal;
    log('After Change locationTypeofRide = ' +
        locationList[indexval].locationTypeofRide);
    notifyListeners();
  }

  setTimeAtStop(int indexval, int timeStopVal) {
    locationList[indexval].locationTimeAtStop = timeStopVal;

    notifyListeners();
  }

  deletWholeIndex(int indexVal) {
    locationList.removeAt(indexVal);

    notifyListeners();
  }

  clearEveryThing() {
    locationList.clear();
    polyline.clear();
    markers.clear();
    notifyListeners();
  }

  setDirectionOfRoute() {
    final directionsService = DirectionsService();
    var lastLocation = locationList.last;
    var firstlocation = locationList.first;
    // final request = DirectionsRequest(
    //   origin: firstlocation.locationAddress,
    //   destination: lastLocation.locationAddress,
    //   travelMode: TravelMode.driving,
    // );

    // directionsService.route(request,
    //     (DirectionsResult response, DirectionsStatus status) {
    //   if (status == DirectionsStatus.ok) {
    //     log('Route Created');
    //   } else {
    //     log('Route Created');
    //   }
    // });
  }

  // void setPolylineOnMap() async {
  //   if (locationList.isEmpty) {
  //     log('LOcation List is Null');
  //   } else {
  //     log('LOcation List is Null');
  //     print("String Polyline..............................");
  //     var lastLocation = locationList.last;
  //     var firstlocation = locationList.first;
  //     PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
  //         googleApikey,
  //         PointLatLng(firstlocation.locationLat, firstlocation.locationLong),
  //         PointLatLng(lastLocation.locationLat, lastLocation.locationLong));
  //     log(result.errorMessage.toString());
  //     if (result.status == "OK") {
  //       result.points.forEach((PointLatLng point) {
  //         _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       });

  //       _polyline.add(Polyline(
  //           width: 4,
  //           polylineId: PolylineId('polyline'),
  //           color: Colors.red,
  //           points: _polylineCoordinates));
  //     } else {
  //       print("Polyline Not Generated!!!!!!!!!!!!!!!!");
  //     }
  //   }

  //   notifyListeners();
  // }

  void setPolylineOnMap(double startLat, double startLong, double destiLat,
      double destiLong) async {
    print("String Polyline..............................");
    log(startLat.toString());
    log(startLong.toString());
    log(destiLat.toString());
    log(destiLong.toString());
    PointLatLng start = PointLatLng(startLat, startLong);
    PointLatLng endLatlong = PointLatLng(destiLat, destiLong);
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        googleApikey,
        PointLatLng(startLat, startLong),
        PointLatLng(destiLat, destiLong));
    log(result.errorMessage.toString());
    if (result.status == "OK") {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      // addDestinationMarkers(LatLng(destiLat, pickUpLong));

      polyline.add(Polyline(
          width: 4,
          polylineId: PolylineId('polyline'),
          color: Colors.red,
          points: _polylineCoordinates));
      CameraPosition cameraPosition = CameraPosition(
          target: locationList.isEmpty
              ? LatLng(0.0, 0.0)
              : LatLng(
                  locationList[0].locationLat, locationList[0].locationLong),
          zoom: 14);
      myController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } else {
      print("Polyline Not Generated!!!!!!!!!!!!!!!!");
    }
    setpathLoading(false);
    notifyListeners();
  }

  launchMapsUrl() async {
    var sourceLatitude = locationList[startIndex.value].locationLat;
    var sourceLongitude = locationList[startIndex.value].locationLong;
    var destinationLatitude = locationList[endIndex.value].locationLat;
    var destinationLongitude = locationList[endIndex.value].locationLong;
    debugPrint('endIndex: ${endIndex}');

    String mapOptions = [
      'saddr=$sourceLatitude,$sourceLongitude',
      'daddr=$destinationLatitude,$destinationLongitude',
      'dir_action=navigate'
    ].join('&');

    final url = 'https://www.google.com/maps?$mapOptions';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
