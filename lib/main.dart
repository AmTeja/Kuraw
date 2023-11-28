import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kuraw/app.dart';
import 'package:kuraw/config/bloc_observer.dart';
import 'package:kuraw/config/http_overrides.dart';

void main() {
  HttpOverrides.global = CustomHttpOverrides();
  Bloc.observer = const SimpleBlocObserver();
  runApp(const App());
}
