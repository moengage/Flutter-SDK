import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;
import 'package:moengage_flutter_example/cards/cards_helper.dart';
import 'package:moengage_flutter_example/cards/utils.dart';

enum CardActionEvent { CLICK, DELETE, SHOWN }

typedef CardActionCallback = void
    Function(CardActionEvent cardActionEvent, moe.Card card, {int widgetId});

class IllustrationCard extends StatefulWidget {
  final CardActionCallback callback;
  final moe.Card card;

  IllustrationCard(this.card, this.callback);

  @override
  State<IllustrationCard> createState() => _IllustrationCardState();
}

class _IllustrationCardState extends State<IllustrationCard> {
  @override
  void initState() {
    super.initState();
    widget.callback.call(CardActionEvent.SHOWN, widget.card);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            child: Card(
          color:
              colorFromHex(widget.card.getContainer()?.style?.backgroundColor),
          child: Container(
            foregroundDecoration:
                (widget.card.metaData.campaignState.isClicked == false)
                    ? BadgeDecoration()
                    : BoxDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: Column(
                children: [
                  Visibility(
                    visible: widget.card.metaData.displayControl.isPinned,
                    child: Row(
                      children: [
                        Spacer(),
                        Icon(
                          Icons.bookmark_added_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  getImageWidget(context),
                  getHeaderText(context),
                  getMessageText(context),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateFromMillis(
                            widget.card.metaData.updatedTime * 1000),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Spacer(),
                      getCtaText(context)
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
        onTap: () {
          widget.callback.call(CardActionEvent.CLICK, widget.card,
              widgetId: widget.card.getContainer()?.id ?? 0);
          handleWidgetActions(widget.card.getContainer()?.actionList);
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: GestureDetector(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.callback.call(CardActionEvent.DELETE, widget.card);
                  },
                ),
              );
            },
          );
        });
  }

  getImageWidget(BuildContext context) {
    moe.Widget? image = widget.card.getImageWidget();
    if (image == null || image.content.isEmpty) return SizedBox.shrink();
    return Image.network(
      image.content,
      fit: BoxFit.fill,
      height: 150,
      width: MediaQuery.of(context).size.width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  getHeaderText(BuildContext context) {
    moe.Widget? header = widget.card.getHeaderWidget();
    if (header == null || header.content.isEmpty) return SizedBox.shrink();
    return Html(
      data: header.content,
      style: {
        '#': Style(
          fontSize: FontSize(16),
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        "body": Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(vertical: 4),
        )
      },
    );
  }

  getMessageText(BuildContext context) {
    moe.Widget? message = widget.card.getMessageWidget();
    if (message == null || message.content.isEmpty) return SizedBox.shrink();
    return Html(
      data: message.content,
      style: {
        '#': Style(
          fontSize: FontSize(12),
          maxLines: 4,
          textOverflow: TextOverflow.ellipsis,
        ),
        "body": Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(vertical: 4),
        )
      },
    );
  }

  getCtaText(BuildContext context) {
    moe.Widget? cta = widget.card.getButtonWidget();
    if (cta == null || cta.content.isEmpty) return SizedBox.shrink();
    return TextButton(
        onPressed: () {
          widget.callback
              .call(CardActionEvent.CLICK, widget.card, widgetId: cta.id);
          handleWidgetActions(cta.actionList);
        },
        child: Html(
          data: cta.content,
          shrinkWrap: true,
          style: {
            '#': Style(
              fontSize: FontSize(12),
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            "body": Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(vertical: 4),
            )
          },
        ));
  }
}

class BasicCard extends StatefulWidget {
  final CardActionCallback callback;
  final moe.Card card;

  BasicCard(this.card, this.callback);

  @override
  State<BasicCard> createState() => _BasicCardState();
}

class _BasicCardState extends State<BasicCard> {
  @override
  void initState() {
    super.initState();
    widget.callback.call(CardActionEvent.SHOWN, widget.card);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            child: Card(
          color:
              colorFromHex(widget.card.getContainer()?.style?.backgroundColor),
          child: Container(
            foregroundDecoration:
                (widget.card.metaData.campaignState.isClicked == false)
                    ? BadgeDecoration()
                    : BoxDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Column(
                children: [
                  Visibility(
                    visible: widget.card.metaData.displayControl.isPinned,
                    child: Row(
                      children: [
                        Spacer(),
                        Icon(
                          Icons.bookmark_added_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      getImageWidget(context),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              getHeaderText(context),
                              getMessageText(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        getDateFromMillis(
                            widget.card.metaData.updatedTime * 1000),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Spacer(),
                      getCtaText(context)
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
        onTap: () {
          widget.callback.call(CardActionEvent.CLICK, widget.card,
              widgetId: widget.card.getContainer()?.id ?? 0);
          handleWidgetActions(widget.card.getContainer()?.actionList);
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: GestureDetector(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.callback.call(CardActionEvent.DELETE, widget.card);
                  },
                ),
              );
            },
          );
        });
  }

  getImageWidget(BuildContext context) {
    moe.Widget? image = widget.card.getImageWidget();
    if (image == null || image.content.isEmpty) return SizedBox.shrink();
    return Image.network(
      image.content,
      fit: BoxFit.fill,
      width: MediaQuery.of(context).size.width * .2,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  getHeaderText(BuildContext context) {
    moe.Widget? header = widget.card.getHeaderWidget();
    if (header == null || header.content.isEmpty) return SizedBox.shrink();
    return Html(
      data: header.content,
      style: {
        '#': Style(
          fontSize: FontSize(16),
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        "body": Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(vertical: 4),
        )
      },
    );
  }

  getMessageText(BuildContext context) {
    moe.Widget? message = widget.card.getMessageWidget();
    if (message == null || message.content.isEmpty) return SizedBox.shrink();
    return Html(
      data: message.content,
      style: {
        '#': Style(
          fontSize: FontSize(12),
          maxLines: 4,
          textOverflow: TextOverflow.ellipsis,
        ),
        "body": Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(vertical: 4),
        )
      },
    );
  }

  getCtaText(BuildContext context) {
    moe.Widget? cta = widget.card.getButtonWidget();
    if (cta == null || cta.content.isEmpty) return SizedBox.shrink();
    return TextButton(
        onPressed: () {
          widget.callback
              .call(CardActionEvent.CLICK, widget.card, widgetId: cta.id);
          handleWidgetActions(cta.actionList);
        },
        child: Html(
          data: cta.content,
          shrinkWrap: true,
          style: {
            '#': Style(
              fontSize: FontSize(16),
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            "body": Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(vertical: 4),
            )
          },
        ));
  }
}

class BadgeDecoration extends Decoration {
  final Color badgeColor;
  final double badgeSize;

  BadgeDecoration({this.badgeColor = Colors.lightBlue, this.badgeSize = 15});

  @override
  BoxPainter createBoxPainter([VoidCallback? callback]) =>
      _BadgePainter(badgeColor, badgeSize);
}

class _BadgePainter extends BoxPainter {
  static const double CORNER_RADIUS = 4;
  final Color badgeColor;
  final double badgeSize;

  _BadgePainter(this.badgeColor, this.badgeSize);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.save();
    canvas.translate(
        offset.dx + (configuration.size?.width ?? 0) - badgeSize, offset.dy);
    canvas.drawPath(buildBadgePath(), getBadgePaint());
    canvas.restore();
  }

  Paint getBadgePaint() => Paint()
    ..isAntiAlias = true
    ..color = badgeColor;

  Path buildBadgePath() => Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(RRect.fromLTRBAndCorners(0, 0, badgeSize, badgeSize,
            topRight: Radius.circular(CORNER_RADIUS))),
      Path()
        ..lineTo(0, badgeSize)
        ..lineTo(badgeSize, badgeSize)
        ..close());
}
