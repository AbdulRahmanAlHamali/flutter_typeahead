import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:example/material_app.dart';
import 'package:example/cupertino_app.dart';

void main() => runApp(Platform.isIOS ? MyCupertinoApp() : MyMaterialApp());
