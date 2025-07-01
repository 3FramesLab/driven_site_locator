part of sl_widget_module;

class PanelHandle extends StatelessWidget {
  final Color? color;

  const PanelHandle({
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 33,
            height: 4,
            decoration: BoxDecoration(
              color: color ?? Colors.grey[500],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
