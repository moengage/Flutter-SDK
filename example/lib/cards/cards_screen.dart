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

  @override
  void initState() {
    super.initState();
    cards.initialize();
    cards.onCardsSectionLoaded();
    cards.getCardsCategories().then((data) {
      debugPrint("getCardsCategories: " + data.toString());
    });
    cards.isAllCategoryEnabled().then((data) {
      debugPrint("isAllCategoryEnabled: " + data.toString());
    });
    cards.getNewCardsCount().then((data) {
      debugPrint("getNewCardsCount: " + data.toString());
    });
    cards.getUnClickedCardsCount().then((data) {
      debugPrint("getUnClickedCardsCount: " + data.toString());
    });
    fetchCards();
    tabController = TabController(
      initialIndex: 0,
      length: categories.length,
      vsync: this,
    );
    cards.setPullToRefreshSyncListener((moe.SyncCompleteData data) {
      cards.cardDelivered();
      if (data.hasUpdates) {
        fetchCards();
      }
    });
    cards.setInboxOpenSyncListener((moe.SyncCompleteData data) {
      cards.cardDelivered();
      if (data.hasUpdates) fetchCards();
    });
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
            child: (categories.isEmpty)
                ? Center(
                    child: Text("No Data"),
                  )
                : getListWidget(),
          )),
    );
  }

  Widget getListWidget() {
    return Container(
        child: Stack(
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
                                  itemBuilder: (context, pos) {
                                    return (data[pos].template.templateType ==
                                            moe.TemplateType.basic)
                                        ? BasicCard(data[pos], actionCallback)
                                        : IllustrationCard(
                                            data[pos], actionCallback);
                                  });
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                    );
                  }).toList()),
            )
          ],
        )
      ],
    ));
  }

  void refreshCards() {
    cards.refreshCards();
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
