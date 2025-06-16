part of sl_filter_module;

class BrandQuickFilterBottomContent extends StatelessWidget {
  final AuthSLTypeChoicesController authSLTypeChoicesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return _bottomContent;
  }

  Widget get _bottomContent => Container(
        decoration: const BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(0, 0.75),
          )
        ], color: Colors.white),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _updateButton,
              const SizedBox(height: 20),
              _cancelButton,
              const SizedBox(height: 30),
            ],
          ),
        ),
      );

  Widget get _updateButton => PrimaryButton(
        text: SLViewText.update,
        onPressed: authSLTypeChoicesController.updateBrandFiltersChecked,
      );

  Widget get _cancelButton => ClickableText(
        title: SLViewText.cancel,
        onTap: authSLTypeChoicesController.backToMapPage,
      );
}
