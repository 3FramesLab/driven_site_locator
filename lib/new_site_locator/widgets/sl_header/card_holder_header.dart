part of sl_widget_module;

class CardHolderHeader extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  const CardHolderHeader({
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        _headerText,
        style: f16SemiBoldBlack,
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String get _headerText {
    final nickName = SLSessionManager().selectedCardNickname;

    if (SLSessionManager()
        .selectedCardLastFourDigits
        .isNotNullEmptyOrWhitespace) {
      return '$nickName *${SLSessionManager().selectedCardLastFourDigits}';
    } else if (SLSessionManager()
        .selectedFleetId()
        .isNotNullEmptyOrWhitespace) {
      return SLSessionManager().selectedFleetId();
    } else {
      return '';
    }
  }
}
