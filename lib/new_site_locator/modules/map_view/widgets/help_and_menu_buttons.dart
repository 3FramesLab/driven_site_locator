part of map_view_module;

class HelpAndMenuButton extends StatelessWidget {
  const HelpAndMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _content;
  }

  Widget get _content {
    return Positioned(
      left: 6,
      bottom: DrivenSiteLocator.instance.isUserAuthenticated
          ? (DrivenSiteLocator.instance.getBottomNavBarHeight() + 10)
          : 10,
      child: Column(
        children: [
          SLMenuButton(),
          const SizedBox(height: 8),
          SLHelpButton(),
        ],
      ),
    );
  }
}
