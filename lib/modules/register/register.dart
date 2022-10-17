import 'package:circuit4driver/constant.dart';
import 'package:circuit4driver/modules/Home/home.dart';
import 'package:circuit4driver/modules/appPages/routes.dart';
import 'package:circuit4driver/modules/customNavbar.dart';
import 'package:circuit4driver/modules/login/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../customTextField.dart';

class Register extends GetView<LoginController> {
  const Register({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.white70,
        body: SafeArea(
            child: Container(
                child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white),
                    child: TextField(
                      // controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.0,
                          ),
                        ),
                        labelText: 'Add Another Stop',
                      ),
                      onChanged: (text) {},
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Done',
                  style: TextStyle(
                      fontSize: 16,
                      color: orangeColor,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        '2345 Pine',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                      Icon(
                        Icons.apps_sharp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.black54,
                    height: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        '2345 Pine',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.black54,
                    height: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: orangeColor,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: orangeColor),
                          child: Center(
                              child: Text(
                            'Normal',
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Center(child: Text('ASAP')),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: orangeColor,
                      ),
                      SizedBox(
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
                      SizedBox(
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
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: orangeColor,
                      ),
                      SizedBox(
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
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: orangeColor,
                      ),
                      SizedBox(
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
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: ((context) => Home())));
                      // Get.offNamedUntil(Routes.HOME, (route) => false);
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
                            'Register',
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
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ],
        ))));
  }
}
