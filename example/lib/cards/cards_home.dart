// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint

import 'package:flutter/material.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;

import '../constants.dart';
import 'cards_screen.dart';

class CardsHome extends StatefulWidget {
  const CardsHome({super.key});

  @override
  State<CardsHome> createState() => _CardsHomeState();
}

class _CardsHomeState extends State<CardsHome> {
  moe.MoEngageCards cards = moe.MoEngageCards(APP_ID);

  @override
  void initState() {
    super.initState();
    cards.setSyncCompleteListener((moe.SyncCompleteData? data) {
      debugPrint('Cards Sync Listener: $data');
    });
    cards.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cards Home'),
        ),
        body: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: const Text('New Cards Count'),
                    onTap: () {
                      cards.getNewCardsCount().then((int value) {
                        showSnackBar('New Cards Count: $value', context);
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('UnClicked Cards Count'),
                    onTap: () {
                      cards.getUnClickedCardsCount().then((int value) {
                        showSnackBar('UnClicked Cards Count: $value', context);
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Get Cards Categories'),
                    onTap: () {
                      cards.getCardsCategories().then((List<String> value) {
                        showSnackBar('Get Cards Categories: $value', context);
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Is All Category Enabled'),
                    onTap: () {
                      cards.isAllCategoryEnabled().then((bool value) {
                        showSnackBar(
                            'Is All Category Enabled: $value', context);
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Mark Card as Delivered'),
                    onTap: () async {
                      cards.cardDelivered();
                      showSnackBar('Marking Card as Delivered', context);
                    },
                  ),
                  ListTile(
                    title: const Text('Fetch Cards'),
                    onTap: () async {
                      final moe.CardsData data = await cards.fetchCards();
                      final int count = data.cards.length;
                      // ignore: use_build_context_synchronously
                      showSnackBar(
                          'Fetched $count card(s) , Category-${data.category}',
                          context);
                    },
                  ),
                  ListTile(
                    title: const Text('Go To Cards UI'),
                    tileColor: Colors.blueGrey.shade50.withAlpha(100),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const CardsScreen()));
                    },
                  ),
                ],
              ).toList(),
            ),
          ],
        ));
  }

  showSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    ));
  }
}
