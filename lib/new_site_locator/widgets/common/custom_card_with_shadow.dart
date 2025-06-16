part of sl_widget_module;

class CustomCardWithShadow extends StatelessWidget {
  final Widget child;
  final bool? hasShadow;

  const CustomCardWithShadow(
      {required this.child, this.hasShadow = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: hasShadow ?? false ? 3 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}
