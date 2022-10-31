import 'dart:ui';

import 'package:circuit4driver/constant.dart';
import 'package:circuit4driver/modules/Home/impostazioni.dart';
import 'package:circuit4driver/modules/Home/subscribtion.dart';
import 'package:circuit4driver/modules/provider/home_providers.dart';
import 'package:circuit4driver/utils/constFile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';

Widget drawer(context) {
  HomeProvider homeProvider = Provider.of<HomeProvider>(context);
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xfff1f5fe),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff004c3f),
                ),
                child: Text(
                  "A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Text(
                "Antimo Fiorellino",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "fantimo786@gmail.com",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff959fb5),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Piano gratuito    ",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff959fb5),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color(0xff959fb5),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Oggi",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[300], width: 0.5),
                  color: Color(0xfff1f5fe),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Nessun percorso",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlacePicker(
                                  apiKey: googleApikey,
                                  hintText: "Find a place ...",
                                  searchingText: "Please wait ...",
                                  selectText: "Select place",
                                  outsideOfPickAreaText: "Place not in area",
                                  initialPosition:
                                      homeProvider.currentLaltg != null
                                          ? homeProvider.currentLaltg
                                          : homeProvider.center,
                                  useCurrentLocation: true,
                                  selectInitialPosition: true,
                                  usePinPointingSearch: true,
                                  usePlaceDetailSearch: true,
                                  onPlacePicked: (result) {
                                    homeProvider.setSingleValue(result);
                                    Navigator.of(context).pop();
                                  })),
                        );
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: orangeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nuovo percorso',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "In precedenza questa settimana",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[300], width: 0.5),
                    color: Color(0xfff1f5fe),
                  ),
                  child: Row(
                    children: [
                      homeProvider.locationList.isEmpty
                          ? SizedBox()
                          : Text(
                              "  ${homeProvider.locationList[0].locationAddress}",
                              style: TextStyle(
                                fontSize: 15,
                                color: orangeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text("Nuovo percorse"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => Subscribtion())));
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Aiuto e assistenza"),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Impostazioni"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => Impostazioni())));
                },
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard_sharp),
                title: Text("Ottieni un mese gratuito"),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Circuit for Teams"),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
