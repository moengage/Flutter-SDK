// ignore_for_file: public_member_api_docs
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;
import '../constants.dart';
import 'card_widget.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen>
    with TickerProviderStateMixin {
  List<moe.Card> cardList = [];

  moe.MoEngageCards cards = moe.MoEngageCards(WORKSPACE_ID);

  List<String> categories = [];

  late TabController tabController;

  bool showHasUpdates = false;

  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    cards.setSyncCompleteListener((moe.SyncCompleteData? data) {
      debugPrint('Cards Sync Listener Callback: $data');
    });
    setUpTabs();
    cards.onCardsSectionLoaded((moe.SyncCompleteData? data) {
      debugPrint('onCardsSectionLoaded(): Callback Data: $data');
      if (data?.hasUpdates == true) {
        setState(() {
          showHasUpdates = true;
        });
      }
    });
    fetchCards();
    cards.initialize();
  }

  void fetchCards() {
    cards.getCardsInfo().then((moe.CardsInfo data) {
      setState(() {
        cardList = data.cards;
        categories.clear();
        if (data.shouldShowAllTab && data.categories.isNotEmpty) {
          categories.add('All');
        }
        categories.addAll(data.categories);
        setUpTabs();
      });
    });
  }

  void setUpTabs() {
    tabController = TabController(
      length: categories.length,
      vsync: this,
    );
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
            iconTheme: const IconThemeData(color: Colors.black54),
            backgroundColor: Colors.white,
            shadowColor: Colors.grey.shade100,
            title: const Text(
              'Inbox',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                refreshCards();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height,
                  child: (categories.isEmpty)
                      ? const Center(
                          child: Text('No Data'),
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
                  padding: const EdgeInsets.all(8.0),
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: Colors.black54),
                    insets: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: categories
                      .map((String category) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              category,
                              style: const TextStyle(
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
                      .map((category) =>
                          CardsListWidget(category, cards, actionCallback))
                      .toList(),
                ))
              ],
            ),
            if (showHasUpdates)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: OutlinedButton(
                      onPressed: () {
                        fetchCards();
                        setState(() {
                          showHasUpdates = false;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.black54))),
                        side: MaterialStateProperty.all(
                          const BorderSide(),
                        ),
                      ),
                      child: const Text(
                        'New Updates',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              )
            else
              const SizedBox.shrink()
          ],
        )
      ],
    ));
  }

  void refreshCards() {
    cards.refreshCards((moe.SyncCompleteData? data) {
      debugPrint('refreshCards(): Callback Data: $data');
      cards.cardDelivered();
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
}

class CardsListWidget extends StatefulWidget {
  const CardsListWidget(this.category, this.cards, this.actionCallback,
      {super.key});

  final String category;
  final moe.MoEngageCards cards;
  final CardActionCallback actionCallback;

  @override
  State<CardsListWidget> createState() => _CardsListWidgetState();
}

class _CardsListWidgetState extends State<CardsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<moe.CardsData>(
          future: widget.cards.getCardsForCategory(widget.category),
          builder:
              (BuildContext context, AsyncSnapshot<moe.CardsData> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              final List<moe.Card> data = snapshot.data?.cards ?? [];
              if (data.isEmpty) {
                return const Center(child: Text('No Data'));
              }
              return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int pos) {
                    return (data[pos].template.templateType ==
                            moe.TemplateType.basic)
                        ? BasicCard(data[pos], widget.actionCallback)
                        : IllustrationCard(data[pos], widget.actionCallback);
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
