import 'package:flutter/material.dart';

class LocationModel {
  double locationLat;
  double locationLong;
  String locationAddress;
  String locationDescription;
  String locationperiority;
  String locationTypeofRide;
  String locationArrivedbetweenStart;
  String locationArrivedbetweenEnd;
  int locationTimeAtStop;
  String locationPlaceinVehicleFirst;
  String locationPlaceinVehicleSecond;
  String locationPlaceinVehicleThird;
  int timeofLocationSet;

  LocationModel({
    this.locationLat,
    this.locationLong,
    this.locationAddress,
    this.locationDescription,
    this.locationperiority,
    this.locationTypeofRide,
    this.locationArrivedbetweenStart,
    this.locationArrivedbetweenEnd,
    this.locationTimeAtStop,
    this.locationPlaceinVehicleFirst,
    this.locationPlaceinVehicleSecond,
    this.locationPlaceinVehicleThird,
    this.timeofLocationSet
  });
}
