// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;
import 'package:url_launcher/url_launcher.dart';

Color? colorFromHex(String? hexColor) {
  if (hexColor == null) {
    return null;
  }
  final String hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String getDateFromMillis(int timeInMillis) {
  final DateFormat format = DateFormat('dd MMM,yy hh:mm a');
  return format.format(DateTime.fromMillisecondsSinceEpoch(timeInMillis));
}

Future<void> handleAction(moe.Action action) async {
  if (action.actionType == moe.ActionType.navigate) {
    action = action as moe.NavigationAction;
    if (action.navigationType == moe.NavigationType.screenName) {
      debugPrint('Screen Name Navigation Not supported');
      return;
    }
    if (action.value.isEmpty) {
      debugPrint('Url Empty');
      return;
    }
    final Uri uri =
        Uri.parse(action.value).replace(queryParameters: action.keyValuePairs);
    if (action.navigationType == moe.NavigationType.richLanding) {
      //Open RichLanding Url in WebView Inside App
      await launch(uri.toString(), forceWebView: true, forceSafariVC: true);
    } else if (action.navigationType == moe.NavigationType.deepLink) {
      //Open DeepLink In External App
      await launch(uri.toString());
    }
  }
}

handleWidgetActions(List<moe.Action>? actions) {
  actions?.forEach((moe.Action action) {
    handleAction(action);
  });
}
