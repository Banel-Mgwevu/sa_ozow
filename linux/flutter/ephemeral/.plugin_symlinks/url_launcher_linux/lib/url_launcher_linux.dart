// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

const MethodChannel _channel =
    MethodChannel('plugins.flutter.io/url_launcher_linux');

/// An implementation of [UrlLauncherPlatform] for Linux.
class UrlLauncherLinux extends UrlLauncherPlatform {
  /// Registers this class as the default instance of [UrlLauncherPlatform].
  static void registerWith() {
    UrlLauncherPlatform.instance = UrlLauncherLinux();
  }

  @override
  final LinkDelegate? linkDelegate = null;

  @override
  Future<bool> canLaunch(String url) {
    return _channel.invokeMethod<bool>(
      'canLaunch',
      <String, Object>{'url': url},
    ).then((bool? value) => value ?? false);
  }

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) {
    return _channel.invokeMethod<bool>(
      'launch',
      <String, Object>{
        'url': url,
        'enableJavaScript': enableJavaScript,
        'enableDomStorage': enableDomStorage,
        'universalLinksOnly': universalLinksOnly,
        'headers': headers,
      },
    ).then((bool? value) => value ?? false);
  }

  @override
  Future<bool> supportsMode(PreferredLaunchMode mode) async {
    return mode == PreferredLaunchMode.platformDefault ||
        mode == PreferredLaunchMode.externalApplication;
  }

  @override
  Future<bool> supportsCloseForMode(PreferredLaunchMode mode) async {
    // No supported mode is closeable.
    return false;
  }
}
