import 'package:flutter/material.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;

import 'cards_screen.dart';

class CardsHome extends StatefulWidget {
  const CardsHome({Key? key}) : super(key: key);

  @override
  State<CardsHome> createState() => _CardsHomeState();
}

class _CardsHomeState extends State<CardsHome> {
  moe.MoEngageCards cards = moe.MoEngageCards("DAO6UGZ73D9RTK8B5W96TPYN");

  @override
  void initState() {
    super.initState();
    cards.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cards Home"),
        ),
        body: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: Text("New Cards Count"),
                    onTap: () {
                      cards.getNewCardsCount().then((value) {
                        showSnackBar("New Cards Count: $value", context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("UnClicked Cards Count"),
                    onTap: () {
                      cards.getUnClickedCardsCount().then((value) {
                        showSnackBar("UnClicked Cards Count: $value", context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("Get Cards Categories"),
                    onTap: () {
                      cards.getCardsCategories().then((value) {
                        showSnackBar("Get Cards Categories: $value", context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("Is All Category Enabled"),
                    onTap: () {
                      cards.isAllCategoryEnabled().then((value) {
                        showSnackBar(
                            "Is All Category Enabled: $value", context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("Mark Card as Delivered"),
                    onTap: () async {
                      cards.cardDelivered();
                      showSnackBar("Marking Card as Delivered", context);
                    },
                  ),
                  ListTile(
                    title: Text("Fetch Cards"),
                    onTap: () async {
                      var data = await cards.fetchCards();
                      var count = data.cards.length;
                      showSnackBar("Fetched $count card(s)", context);
                    },
                  ),
                  ListTile(
                    title: Text("Go To Cards UI"),
                    tileColor: Colors.blueGrey.shade50.withAlpha(100),
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CardsScreen()));
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
      duration: Duration(seconds: 2),
    ));
  }
}
