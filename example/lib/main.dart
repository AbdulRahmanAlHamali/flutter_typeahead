import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:example/material_app.dart';
import 'package:example/cupertino_app.dart';

void main() =>
    runApp(!kIsWeb && Platform.isIOS ? MyCupertinoApp() : MyMaterialApp());
