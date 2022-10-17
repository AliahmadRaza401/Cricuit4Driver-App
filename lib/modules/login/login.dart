import 'package:circuit4driver/constant.dart';
import 'package:circuit4driver/localization/strings_app.dart';
import 'package:circuit4driver/modules/appPages/routes.dart';
import 'package:circuit4driver/preferences/preference_data.dart';
import 'package:circuit4driver/preferences/preference_keys.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'loginController.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg3.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Container(
            //   height: size.height,
            //   width: size.width,
            //   color: Colors.brown,
            //   child: Icon(Icons.backpack),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 30,
                      ),
                      // Text(
                      //   login.tr,
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 35,
                      //       fontWeight: FontWeight.w700),
                      // ),
                      Text(
                        'CIRCUIT 4DRIVERS',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Text(
                    'Pianificazione multi-fermata per conducenti spedizioni',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: SizedBox()),
                // ElevatedButton(
                //     onPressed: () async {
                //       language = 'en';
                //       SharedPreferenceManager.saveString(
                //           SharePreferenceKeys.language, 'en');
                //       Get.updateLocale(const Locale('en', 'US'));
                //     },
                //     child: Text("English")),
                // ElevatedButton(
                //     onPressed: () async {
                //       language = 'ar';
                //       SharedPreferenceManager.saveString(
                //           SharePreferenceKeys.language, 'ar');
                //       Get.updateLocale(const Locale('ar', 'DZ'));
                //     },
                //     child: Text("Arabic")),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.REGISTER);
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Continua con Google',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/apple.png',
                        height: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Continua con Apple',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continua con email',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
