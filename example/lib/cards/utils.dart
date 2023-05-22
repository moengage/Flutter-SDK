import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;
import 'package:url_launcher/url_launcher.dart';

Color? colorFromHex(String? hexColor) {
  if (hexColor == null) return null;
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String getDateFromMillis(int timeInMillis) {
  var format = DateFormat("dd MMM,yy hh:mm a");
  return format.format(DateTime.fromMillisecondsSinceEpoch(timeInMillis));
}

handleAction(moe.Action action) async {
  if (action.actionType == moe.ActionType.navigate) {
    action = action as moe.NavigationAction;
    if (action.navigationType == moe.NavigationType.screenName) {
      debugPrint("Screen Name Navigation Not supported");
      return;
    }
    if (action.value.isEmpty) {
      debugPrint("Url Empty");
      return;
    }
    var uri =
        Uri.parse(action.value).replace(queryParameters: action.keyValuePairs);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch url: ${action.value}');
    }
  }
}

handleWidgetActions(List<moe.Action>? actions) {
  actions?.forEach((action) {
    handleAction(action);
  });
}
