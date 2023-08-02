import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moengage_cards/moengage_cards.dart' as moe;
import 'cards_helper.dart';
import 'utils.dart';

enum CardActionEvent { CLICK, DELETE, SHOWN }

typedef CardActionCallback = void
    Function(CardActionEvent cardActionEvent, moe.Card card, {int widgetId});

class IllustrationCard extends StatefulWidget {
  const IllustrationCard(this.card, this.callback, {super.key});
  final CardActionCallback callback;
  final moe.Card card;

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
                    ? const BadgeDecoration()
                    : const BoxDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: Column(
                children: [
                  Visibility(
                    visible: widget.card.metaData.displayControl.isPinned,
                    child: Row(
                      children: const [
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
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateFromMillis(
                            widget.card.metaData.updatedTime * 1000),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      getCtaText(context)
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
        onTap: () {
          widget.callback.call(CardActionEvent.CLICK, widget.card);
          handleWidgetActions(widget.card.getContainer()?.actionList);
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: GestureDetector(
                  child: const Text(
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

  Widget getImageWidget(BuildContext context) {
    moe.Widget? image = widget.card.getImageWidget();
    if (image == null || image.content.isEmpty) return const SizedBox.shrink();
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

  Widget getHeaderText(BuildContext context) {
    moe.Widget? header = widget.card.getHeaderWidget();
    if (header == null || header.content.isEmpty) {
      return const SizedBox.shrink();
    }
    return Html(
      data: header.content,
      style: {
        '#': Style(
          fontSize: FontSize(16),
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        'body': Style(
          margin: Margins.zero,
        )
      },
    );
  }

  Widget getMessageText(BuildContext context) {
    moe.Widget? message = widget.card.getMessageWidget();
    if (message == null || message.content.isEmpty) {
      return const SizedBox.shrink();
    }
    return Html(
      data: message.content,
      style: {
        '#': Style(
          fontSize: FontSize(12),
          maxLines: 4,
          textOverflow: TextOverflow.ellipsis,
        ),
        'body': Style(
          margin: Margins.zero,
        )
      },
    );
  }

  Widget getCtaText(BuildContext context) {
    moe.Widget? cta = widget.card.getButtonWidget();
    if (cta == null || cta.content.isEmpty) return const SizedBox.shrink();
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
            'body': Style(
              margin: Margins.zero,
            )
          },
        ));
  }
}

class BasicCard extends StatefulWidget {
  const BasicCard(this.card, this.callback, {super.key});
  final CardActionCallback callback;
  final moe.Card card;

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
                    ? const BadgeDecoration()
                    : const BoxDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Column(
                children: [
                  Visibility(
                    visible: widget.card.metaData.displayControl.isPinned,
                    child: Row(
                      children: const [
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
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        getDateFromMillis(
                            widget.card.metaData.updatedTime * 1000),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      getCtaText(context)
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
        onTap: () {
          widget.callback.call(CardActionEvent.CLICK, widget.card);
          handleWidgetActions(widget.card.getContainer()?.actionList);
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: GestureDetector(
                  child: const Text(
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

  Widget getImageWidget(BuildContext context) {
    moe.Widget? image = widget.card.getImageWidget();
    if (image == null || image.content.isEmpty) return const SizedBox.shrink();
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

  Widget getHeaderText(BuildContext context) {
    moe.Widget? header = widget.card.getHeaderWidget();
    if (header == null || header.content.isEmpty) {
      return const SizedBox.shrink();
    }
    return Html(
      data: header.content,
      style: {
        '#': Style(
          fontSize: FontSize(16),
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        'body': Style(
          margin: Margins.zero,
        )
      },
    );
  }

  Widget getMessageText(BuildContext context) {
    moe.Widget? message = widget.card.getMessageWidget();
    if (message == null || message.content.isEmpty) {
      return const SizedBox.shrink();
    }
    return Html(
      data: message.content,
      style: {
        '#': Style(
          fontSize: FontSize(12),
          maxLines: 4,
          textOverflow: TextOverflow.ellipsis,
        ),
        'body': Style(
          margin: Margins.zero,
        )
      },
    );
  }

  Widget getCtaText(BuildContext context) {
    moe.Widget? cta = widget.card.getButtonWidget();
    if (cta == null || cta.content.isEmpty) return const SizedBox.shrink();
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
            'body': Style(
              margin: Margins.zero,
            )
          },
        ));
  }
}

class BadgeDecoration extends Decoration {
  const BadgeDecoration(
      {this.badgeColor = Colors.lightBlue, this.badgeSize = 15});
  final Color badgeColor;
  final double badgeSize;

  @override
  BoxPainter createBoxPainter([VoidCallback? callback]) =>
      _BadgePainter(badgeColor, badgeSize);
}

class _BadgePainter extends BoxPainter {
  _BadgePainter(this.badgeColor, this.badgeSize);
  static const double CORNER_RADIUS = 4;
  final Color badgeColor;
  final double badgeSize;

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
            topRight: const Radius.circular(CORNER_RADIUS))),
      Path()
        ..lineTo(0, badgeSize)
        ..lineTo(badgeSize, badgeSize)
        ..close());
}
