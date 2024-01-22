part of list_view_module;

class CardInfoBody extends StatelessWidget {
  const CardInfoBody(this.siteLocation, {Key? key}) : super(key: key);

  final SiteLocation siteLocation;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        CardInfoBodyLeft(siteLocation),
        const SizedBox(width: 5),
        CardInfoBodyRight(siteLocation),
      ],
    );
  }
}
