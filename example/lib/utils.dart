import 'package:flutter/material.dart';

Future asyncInputDialog(BuildContext context, String prompt,
    {TextInputType textInputType = TextInputType.text}) async {
  String teamName = '';
  return showDialog(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        content: new Row(
          children: [
            new Expanded(
                child: new TextField(
                  keyboardType: textInputType,
              autofocus: true,
              decoration: new InputDecoration(labelText: prompt),
              onChanged: (value) {
                teamName = value;
              },
            ))
          ],
        ),
        actions: [
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(teamName);
            },
          ),
        ],
      );
    },
  );
}

enum SelfHandledActions { Shown, Clicked, Dismissed }

Future asyncSelfHandledDialog(BuildContext context) async {
  print("asyncSelfHandledDialog");
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
