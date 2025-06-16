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
    final nickName = DrivenSessionManager().selectedCardNickname;

    if (DrivenSessionManager()
        .selectedCardLastFourDigits
        .isNotNullEmptyOrWhitespace) {
      return '$nickName *${DrivenSessionManager().selectedCardLastFourDigits}';
    } else if (DrivenSessionManager()
        .selectedFleetId()
        .isNotNullEmptyOrWhitespace) {
      return DrivenSessionManager().selectedFleetId();
    } else {
      return '';
    }
  }
}
