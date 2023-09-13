// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import 'main.dart';

Future<String> asyncInputDialog(BuildContext context, String prompt,
    {TextInputType textInputType = TextInputType.text}) async {
  String teamName = '';
  await showDialog(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            Expanded(
                child: TextField(
              keyboardType: textInputType,
              autofocus: true,
              decoration: InputDecoration(labelText: prompt),
              onChanged: (String value) {
                teamName = value;
              },
            ))
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(teamName);
            },
          ),
        ],
      );
    },
  );
  return teamName;
}

enum SelfHandledActions { Shown, Clicked, Dismissed }

Future<SelfHandledActions?> asyncSelfHandledDialog(BuildContext context) async {
  debugPrint('$tag asyncSelfHandledDialog');
  return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose action'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, SelfHandledActions.Shown);
              },
              child: const Text('Shown'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, SelfHandledActions.Clicked);
              },
              child: const Text('Clicked'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, SelfHandledActions.Dismissed);
              },
              child: const Text('Dismissed'),
            ),
          ],
        );
      });
}
