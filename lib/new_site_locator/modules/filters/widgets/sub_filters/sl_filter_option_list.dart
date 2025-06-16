part of sl_filter_module;

class SLFilterOptionList extends StatelessWidget {
  final _controller = Get.find<AuthSLTypeChoicesController>();
  final Filter filter;

  SLFilterOptionList({
    required this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _controller.filterDisplayList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return SLFilterOptionItem(
            index: index,
            siteFilter: _controller.filterDisplayList[index],
            isRadioButton: filter.radioButton,
          );
        },
      ),
    );
  }
}
