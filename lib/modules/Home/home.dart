import 'dart:developer';

import 'package:circuit4driver/constant.dart';
import 'package:circuit4driver/models/location_model.dart';
import 'package:circuit4driver/modules/Home/drawer.dart';
import 'package:circuit4driver/utils/constFile.dart';
import 'package:circuit4driver/utils/customToast.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../customTextField.dart';
import '../provider/home_providers.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static GlobalKey<ScaffoldState> _keyScaffold = GlobalKey();
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
        key: _keyScaffold,
        extendBody: true,
        backgroundColor: Colors.white70,
        drawer: drawer(context),
        // appBar: AppBar(
        //   actions: [
        //     InkWell(
        //         onTap: () {
        //           // loadingAlertDialog(context);
        //         },
        //         child: Icon(Icons.ac_unit_outlined)),
        //   ],
        // ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: homeProvider.mapTypeValue
                    ? MapType.hybrid
                    : MapType.terrain,
                rotateGesturesEnabled: true,
                zoomGesturesEnabled: true,
                trafficEnabled: false,
                tiltGesturesEnabled: false,
                scrollGesturesEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: homeProvider.markers,
                polylines: homeProvider.polyline,
                initialCameraPosition: CameraPosition(
                  target: homeProvider.initialLatLng,
                  zoom: 14.47,
                ),
                onMapCreated: (GoogleMapController controller) {
                  homeProvider.myController = controller;

                  homeProvider.locatePosition();
                },
              ),
            ),
            SafeArea(
              child: InkWell(
                onTap: () {
                  _keyScaffold.currentState.openDrawer();
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: orangeColor,
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlacePicker(
                                          apiKey: googleApikey,
                                          hintText: "Find a place ...",
                                          searchingText: "Please wait ...",
                                          selectText: "Select place",
                                          outsideOfPickAreaText:
                                              "Place not in area",
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
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Search Locations for Routes',
                                      ),
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (homeProvider.locationList.length > 1) {
                                  homeProvider.clearEveryThing();
                                }
                              },
                              child: Icon(
                                Icons.delete,
                                size: 30,
                                color: homeProvider.locationList.length <= 1
                                    ? Colors.black
                                    : orangeColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      homeProvider.locationList.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/search.jpeg',
                                      width: 150,
                                    ),
                                    Text(
                                      "Usa la barra do ricerca in \n alto per aggiungere \n fermate",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              // scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: homeProvider.locationList == null
                                  ? 0
                                  : homeProvider.locationList.length,
                              itemBuilder: (context, i) {
                                LocationModel singleIndex =
                                    homeProvider.locationList[i];

                                return homeProvider.locationList.isEmpty
                                    ? const Text("No data")
                                    // : i == 0
                                    //     ? Container(
                                    //         margin: EdgeInsets.only(bottom: 10),
                                    //         child: Row(
                                    //           children: [
                                    //             Icon(
                                    //               Icons.home,
                                    //               color: orangeColor,
                                    //             ),
                                    //             SizedBox(
                                    //               width: 20,
                                    //             ),
                                    //             Column(
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
                                    //               children: [
                                    //                 Text(
                                    //                   homeProvider
                                    //                       .locationList[i]
                                    //                       .locationAddress
                                    //                       .toString(),
                                    //                   style: TextStyle(
                                    //                     fontWeight:
                                    //                         FontWeight.bold,
                                    //                   ),
                                    //                 ),
                                    //                 Text(
                                    //                   "Start From",
                                    //                 ),
                                    //               ],
                                    //             )
                                    //           ],
                                    //         ),
                                    //       )
                                    //     :
                                    : InkWell(
                                        onTap: () {
                                          _showBottomSheet(context, i);
                                        },
                                        child: Container(
                                            height: 150,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            // height: 200,
                                            width: size.width * 0.9,
                                            decoration: BoxDecoration(
                                              // color: Colors.grey
                                              //     .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // border: Border.all(
                                              //     color: Colors.grey
                                              //         .withOpacity(0.3),
                                              //     width: 1)
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        '${i}',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: orangeColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 4,
                                                      height: 110,
                                                      decoration: BoxDecoration(
                                                        color: orangeColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 250,
                                                      child: Text(
                                                        singleIndex
                                                            .locationAddress,
                                                        style: const TextStyle(
                                                          fontSize: 13.0,
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Color(0xFF212121),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width: 220,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          containerWidget(
                                                              'MRS', 70.0),
                                                          containerWidget(
                                                              singleIndex
                                                                  .locationperiority,
                                                              70.0),
                                                          containerWidget(
                                                              '${singleIndex.locationTimeAtStop.toString() + 'Min'}',
                                                              70.0),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: 220,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          containerWidget(
                                                              'After 7:46 PM',
                                                              105.0),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          containerWidget(
                                                              singleIndex
                                                                  .locationTypeofRide,
                                                              70.0),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Default Time " +
                                                    singleIndex
                                                        .timeofLocationSet
                                                        .toString()),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            )),
                                      );
                              },
                            ),
                      homeProvider.locationList.isEmpty
                          ? SizedBox()
                          : homeProvider.polyline.isNotEmpty
                              ? navigateBtn(homeProvider)
                              : optimizeRouteBtn(homeProvider),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            homeProvider.pathLoading == true ? loadingWidget() : SizedBox(),
          ],
        ));
  }

  Widget optimizeRouteBtn(HomeProvider homeProvider) {
    return GestureDetector(
      onTap: () {
        if (homeProvider.locationList.length < 3) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: orangeColor,
            content: Text('Add minimum 2 Locations'),
          ));
        } else {
          homeProvider.drawParkingMarker();
        }

        // loadingAlertDialog(context);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: orangeColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "Optimize Route",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget navigateBtn(HomeProvider homeProvider) {
    return GestureDetector(
      onTap: () {
        if (homeProvider.endIndex.value == 0) {
          homeProvider.endIndex.value = 1;
          homeProvider.launchMapsUrl();
        } else {
          homeProvider.startIndex.value = homeProvider.startIndex.value + 1;
          homeProvider.endIndex.value = homeProvider.endIndex.value + 1;
          homeProvider.launchMapsUrl();
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: orangeColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.navigation,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "Navigate",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget containerWidget(String textVal, double widthVal) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      width: widthVal,
      child: Align(alignment: Alignment.center, child: Text(textVal)),
    );
  }

  Widget _showEndBottomSheet(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      // isDismissible : false,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(kBorderRadius),
      // ),
      builder: (BuildContext bc) {
        return Container(
          // margin: const EdgeInsets.all(kHorizontalSpacing / 2),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 1.5,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white70),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white70),
                          child: TextFormField(
                            // controller: nameController,

                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                Icons.mic,
                                color: Colors.grey,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              labelText: 'Add Another Stop',
                            ),
                            onChanged: (text) {},
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.mode_edit),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '3 Femalee',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Via, Gigrio,',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: orangeColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            '3 Femalee',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Via, Gigrio,',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: orangeColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: orangeColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            '3 Femalee',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Via, Gigrio,',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: orangeColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: orangeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Oppimioe ii teni',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // const Padding(
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showSelectBottomSheet(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      // isDismissible : false,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(kBorderRadius),
      // ),
      builder: (BuildContext bc) {
        return GestureDetector(
          onTap: () {
            print("asdf");
            Navigator.of(context).pop();
          },
          child: Container(
            // margin: const EdgeInsets.all(kHorizontalSpacing / 2),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Container(
              color: Colors.white70,
              height: MediaQuery.of(context).size.height * 0.43,
              // padding: const EdgeInsets.all(kHorizontalSpacing),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Annuila...',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Expanded(
                          child: Text(
                            'PIecani videos',
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Gatto',
                          style: TextStyle(color: orangeColor),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: orangeColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/front.jpeg',
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Anteri',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: orangeColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/center.jpeg',
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Centroi',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: orangeColor.withOpacity(0.3),
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Rear.jpeg',
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Poste..',
                                style: TextStyle(
                                    color: orangeColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ), // const Padding(

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: orangeColor.withOpacity(0.3),
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Left.jpeg',
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Normale',
                                style: TextStyle(
                                    color: orangeColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: orangeColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Right.jpeg',
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Destra',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ), // const Padding(
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: orangeColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Floor.jpeg',
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Pavimneto',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: orangeColor.withOpacity(0.3),
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Shelf.jpeg',
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Ripiano',
                                style: TextStyle(
                                    color: orangeColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ), // const Padding(

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Rimuovi posto',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _showOttimazaButtonBottomSheet(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      // isDismissible : false,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(kBorderRadius),
      // ),
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          // margin: const EdgeInsets.all(kHorizontalSpacing / 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.45,
            // padding: const EdgeInsets.all(kHorizontalSpacing),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: TextFormField(
                            // controller: nameController,

                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                Icons.mic,
                                color: Colors.grey,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              labelText: 'Aggiungi 0 trova',
                            ),
                            onChanged: (text) {},
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.info_outlined),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "3 fermate",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Giovedi Percorso 3",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.home,
                      color: orangeColor,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Inizia dalla posizione attuae",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text(
                          "Utillizza la posizione GPS durante liottimi...",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.home,
                      color: orangeColor,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Inizia dalla posizione attuae",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text(
                          "Utillizza la posizione GPS durante liottimi...",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //  price Info Alert Dialog________________________________________________
  loadingAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 25,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Ottimizzazione del porcorso",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/logonew.jpeg',
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Container(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Elaboraziione del percorse migilore in corso",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CircularProgressIndicator(
                            color: orangeColor,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(15.0),
                          //   child: new LinearPercentIndicator(
                          //     width: MediaQuery.of(context).size.width * 0.6,
                          //     lineHeight: 15.0,
                          //     percent: 0.5,
                          //     barRadius: const Radius.circular(50),
                          //     linearStrokeCap: LinearStrokeCap.roundAll,
                          //     backgroundColor: orangeColor.withOpacity(0.5),
                          //     progressColor: orangeColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget loadingWidget() {
    return Container(
      alignment: Alignment.center,
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.3),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Ottimizzazione del porcorso",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/logonew.jpeg',
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Container(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Elaboraziione del percorse migilore in corso",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(
                      color: orangeColor,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(15.0),
                    //   child: new LinearPercentIndicator(
                    //     width: MediaQuery.of(context).size.width * 0.6,
                    //     lineHeight: 15.0,
                    //     percent: 0.5,
                    //     barRadius: const Radius.circular(50),
                    //     linearStrokeCap: LinearStrokeCap.roundAll,
                    //     backgroundColor: orangeColor.withOpacity(0.5),
                    //     progressColor: orangeColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showBottomSheet(BuildContext context, int indexVal) {
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      // isDismissible : false,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,

      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(kBorderRadius),
      // ),
      builder: (BuildContext bc) {
        HomeProvider homeProvider = Provider.of<HomeProvider>(context);

        return Consumer<HomeProvider>(
          builder: (context, person, child) {
            return Container(
              // margin: const EdgeInsets.all(kHorizontalSpacing / 2),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Container(
                color: Colors.white70,
                height: MediaQuery.of(context).size.height * 0.7,
                // padding: const EdgeInsets.all(kHorizontalSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            homeProvider.deletWholeIndex(indexVal);
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.grey,
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600]),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        // shrinkWrap: true,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              // border: Border.all(width: 1, color: Colors.grey),
                            ),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  homeProvider
                                      .locationList[indexVal].locationAddress,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(
                                  color: Colors.black54,
                                  height: 1,
                                ),
                                Container(
                                  // height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white),
                                  child: TextFormField(
                                    // controller: nameController,
                                    maxLines: 2,

                                    decoration: InputDecoration(
                                        // labelText: 'recipient, instructions, etc.',
                                        hintText: homeProvider
                                                .locationList[indexVal]
                                                .locationDescription
                                                .isEmpty
                                            ? 'recipient, instructions, etc.'
                                            : homeProvider
                                                .locationList[indexVal]
                                                .locationDescription,
                                        hintStyle:
                                            const TextStyle(fontSize: 18)),
                                    onChanged: (text) {
                                      homeProvider.locationList[indexVal]
                                          .locationDescription = text;
                                      log('locationDescription = ${homeProvider.locationList[indexVal].locationDescription}');
                                    },
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black54,
                                  height: 1,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_shipping,
                                      color: orangeColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          _showSelectBottomSheet(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                          ),
                                          child: const Center(
                                            // child: Text('Posto Navil'),
                                            child: Text('Set place in vehicle'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.electric_bolt_sharp,
                                      color: orangeColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            // _showEndBottomSheet(context);

                                            homeProvider
                                                .checkBoolAndDeliveryType(
                                                    indexVal, 'Normal');
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: homeProvider
                                                            .locationList[
                                                                indexVal]
                                                            .locationperiority ==
                                                        'Normal'
                                                    ? orangeColor
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: homeProvider
                                                                .locationList[
                                                                    indexVal]
                                                                .locationperiority ==
                                                            'Normal'
                                                        ? orangeColor
                                                        : Colors.grey,
                                                    width: 1)),
                                            child: Center(
                                                child: Text(
                                              'Normal',
                                              style: TextStyle(
                                                  color: homeProvider
                                                              .locationList[
                                                                  indexVal]
                                                              .locationperiority ==
                                                          'Normal'
                                                      ? Colors.white
                                                      : Colors.black),
                                            )),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          homeProvider.checkBoolAndDeliveryType(
                                              indexVal, 'ASAP');
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: homeProvider
                                                          .locationList[
                                                              indexVal]
                                                          .locationperiority ==
                                                      'ASAP'
                                                  ? orangeColor
                                                  : Colors.white,
                                              border: Border.all(
                                                  width: 1,
                                                  color: homeProvider
                                                              .locationList[
                                                                  indexVal]
                                                              .locationperiority ==
                                                          'ASAP'
                                                      ? orangeColor
                                                      : Colors.grey)),
                                          child: Center(
                                              child: Text('ASAP',
                                                  style: TextStyle(
                                                      color: homeProvider
                                                                  .locationList[
                                                                      indexVal]
                                                                  .locationperiority ==
                                                              'ASAP'
                                                          ? Colors.white
                                                          : Colors.black))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_rounded,
                                      color: orangeColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          homeProvider.checkTypeofRide(
                                              indexVal, 'Delivery');
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: homeProvider
                                                          .locationList[
                                                              indexVal]
                                                          .locationTypeofRide ==
                                                      'Delivery'
                                                  ? orangeColor
                                                  : Colors.grey,
                                            ),
                                            color: homeProvider
                                                        .locationList[indexVal]
                                                        .locationTypeofRide ==
                                                    'Delivery'
                                                ? orangeColor
                                                : Colors.white,
                                          ),
                                          child: Center(
                                              child: Text(
                                            'Delivery',
                                            style: TextStyle(
                                              color: homeProvider
                                                          .locationList[
                                                              indexVal]
                                                          .locationTypeofRide ==
                                                      'Delivery'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          homeProvider.checkTypeofRide(
                                              indexVal, 'Pickup');
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: homeProvider
                                                          .locationList[
                                                              indexVal]
                                                          .locationTypeofRide ==
                                                      'Pickup'
                                                  ? orangeColor
                                                  : Colors.white,
                                              border: Border.all(
                                                width: 1,
                                                color: homeProvider
                                                            .locationList[
                                                                indexVal]
                                                            .locationTypeofRide ==
                                                        'Pickup'
                                                    ? orangeColor
                                                    : Colors.grey,
                                              )),
                                          child: Center(
                                              child: Text(
                                            'Pickup',
                                            style: TextStyle(
                                              color: homeProvider
                                                          .locationList[
                                                              indexVal]
                                                          .locationTypeofRide ==
                                                      'Pickup'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      color: orangeColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: ReuseableTextField(
                                        hintText: 'Arrive between',
                                        labelText: 'Now',
                                        // controller: controller.passwordController,
                                        isPassword: false,
                                        inputAction: TextInputAction.done,
                                        validator: (String value) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: ReuseableTextField(
                                        edit: true,
                                        hintText: 'Arrive between',
                                        labelText: 'Now',
                                        // controller: controller.passwordController,
                                        isPassword: false,
                                        inputAction: TextInputAction.done,
                                        validator: (String value) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: orangeColor,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: ReuseableTextField(
                                        hintText: homeProvider
                                            .locationList[indexVal]
                                            .locationTimeAtStop
                                            .toString(),
                                        labelText:
                                            'By default ${homeProvider.locationList[indexVal].locationTimeAtStop.toString()}',
                                        // controller: controller.passwordController,
                                        isPassword: false,
                                        inputAction: TextInputAction.done,
                                        validator: (String value) {
                                          return null;
                                        },

                                        onChanged: (val) {
                                          homeProvider.setTimeAtStop(
                                              indexVal, int.parse(val));
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// class Homee extends GetView<LoginController> {
//   const Homee({Key key}) : super(key: key);

// }
