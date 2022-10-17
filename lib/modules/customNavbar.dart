import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final String label;
  final ThemeData theme;
  final Widget backBtn;
  final List<Widget> actionList;

  CustomAppBar(
      { this.label, this.theme, this.backBtn, this.actionList})
      : super(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    automaticallyImplyLeading: false,
    title: Text(
      label,
      style: theme.textTheme.headline2.copyWith(
        color: Colors.white,
      ),
    ),
    leading: backBtn,
    actions: actionList ?? [],
  );
}

