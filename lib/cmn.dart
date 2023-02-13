export 'dart:convert';
export 'dart:async';
export 'dart:io';
export 'dart:math';

export 'package:flutter/services.dart';
export 'package:icons_plus/icons_plus.dart';
export 'package:flutter/foundation.dart';

export 'package:app_links/app_links.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:routemaster/routemaster.dart';
export 'package:url_strategy/url_strategy.dart';

export 'package:flutter/foundation.dart' show kIsWeb;

export 'package:flutter/material.dart';
export 'package:provider/provider.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:shared_preferences/shared_preferences.dart';

export './models/mo_response.dart';
export './models/mo_user_profile.dart';

export './provider/providers.dart';

export './api/dio.dart';
export './widgets/cache_network_iamge.dart';

export './helper/empty_web.dart' if (dart.library.io) 'package:url_protocol/url_protocol.dart';
export './helper/webimports.dart' if (dart.library.io) './helper/emptyio.dart';

export './screens/home.dart';
export './screens/login.dart';

const kWindowsScheme = 'sample';
const kWindowshost = "sample.com";
