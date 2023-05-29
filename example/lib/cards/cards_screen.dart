import 'package:flutter/material.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;
import 'package:moengage_flutter_example/cards/card_widget.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen>
    with TickerProviderStateMixin {
  List<moe.Card> cardList = [];

  moe.MoEngageCards cards = moe.MoEngageCards("DAO6UGZ73D9RTK8B5W96TPYN");

  List<String> categories = [];

  late TabController tabController;

  bool showHasUpdates = false;

  @override
  void initState() {
    super.initState();
    cards.initialize();
    cards.setAppOpenCardsSyncListener((data) {
      debugPrint("Cards App Open Sync Listener: $data");
    });
    cards.onCardsSectionLoaded((data) {
      if (data?.hasUpdates == true) {
        setState(() {
          showHasUpdates = true;
        });
      }
    });
    fetchCards();
    tabController = TabController(
      initialIndex: 0,
      length: categories.length,
      vsync: this,
    );
  }

  fetchCards() {
    cards.getCardsInfo().then((data) {
      setState(() {
        cardList = data.cards;
        categories.clear();
        if (data.isAllCategoryEnabled && data.categories.length > 0) {
          categories.add("All");
        }
        categories.addAll(data.categories);
        tabController = TabController(
          initialIndex: 0,
          length: categories.length,
          vsync: this,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          cards.onCardsSectionUnLoaded();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black54),
            backgroundColor: Colors.white,
            shadowColor: Colors.grey.shade100,
            title: Text(
              "Inbox",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                refreshCards();
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height,
                  child: (categories.isEmpty)
                      ? Center(
                          child: Text("No Data"),
                        )
                      : getListWidget(),
                ),
              )),
        ));
  }

  Widget getListWidget() {
    return Container(
        child: Stack(
      children: [
        Stack(
          children: [
            Column(
              children: [
                TabBar(
                  isScrollable: true,
                  padding: EdgeInsets.all(8.0),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: Colors.black54),
                    insets: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: categories
                      .map((category) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 18,
                              ),
                            ),
                          ))
                      .toList(),
                  controller: tabController,
                ),
                Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: categories
                          .map((category) => getCardsByCategory(category))
                          .map((list) {
                        return Container(
                          child: FutureBuilder<List<moe.Card>>(
                              future: list,
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  final data = snapshot.data ?? [];
                                  if (data.isEmpty) {
                                    return Center(child: Text("No Data"));
                                  }
                                  return ListView.builder(
                                      itemCount: data.length,
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, pos) {
                                        return (data[pos]
                                                    .template
                                                    .templateType ==
                                                moe.TemplateType.basic)
                                            ? BasicCard(
                                                data[pos], actionCallback)
                                            : IllustrationCard(
                                                data[pos], actionCallback);
                                      });
                                }
                                return Center(
                                    child: CircularProgressIndicator());
                              }),
                        );
                      }).toList()),
                )
              ],
            ),
            if (showHasUpdates)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: OutlinedButton(
                      child: Text(
                        "New Updates",
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        fetchCards();
                        setState(() {
                          this.showHasUpdates = false;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black54))),
                        side: MaterialStateProperty.all(
                          BorderSide(
                              color: Colors.black,
                              width: 1.0,
                              style: BorderStyle.solid),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox.shrink()
          ],
        )
      ],
    ));
  }

  void refreshCards() {
    cards.refreshCards((data) {
      if (data?.hasUpdates == true) {
        fetchCards();
      }
    });
  }

  void cardClicked(moe.Card card) {
    cards.cardClicked(card, card.template.containers[0].id);
  }

  void actionCallback(CardActionEvent event, moe.Card card,
      {int widgetId = -1}) {
    if (event == CardActionEvent.CLICK) {
      cards.cardClicked(card, widgetId);
    } else if (event == CardActionEvent.DELETE) {
      cards.deleteCard(card);
      setState(() {
        cardList.remove(card);
        fetchCards();
      });
    } else if (event == CardActionEvent.SHOWN) {
      cards.cardShown(card);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<List<moe.Card>> getCardsByCategory(String category) async {
    if (category == "All") return cardList;
    final cardData = await cards.getCardsForCategory(category);
    return cardData.cards;
  }
}
