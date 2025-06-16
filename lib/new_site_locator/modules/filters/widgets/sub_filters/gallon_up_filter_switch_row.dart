part of sl_filter_module;

class GallonUpFilterSwitchRow extends StatelessWidget {
  final _controller = Get.find<AuthSLTypeChoicesController>();
  final Filter filter;

  GallonUpFilterSwitchRow({
    required this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return filter.hasGallonUpToggleButton
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _content,
          )
        : const SizedBox.shrink();
  }

  Widget get _content => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          switchToggle,
          const DrivenText(
            text: SLViewText.gallonUp,
            style: f16SemiBoldBlack,
          )
        ],
      );

  Widget get switchToggle => Transform.scale(
        scale: 0.75,
        child: Container(
          width: 55,
          height: 35,
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: _cupertinoSwitch,
        ),
      );

  Widget get _cupertinoSwitch => Obx(
        () => CupertinoSwitch(
          value: _controller.gallonUpSwitchValue(),
          onChanged: _controller.gallonUpSwitchValue,
          activeColor: DrivenColors.primary,
          trackColor: Colors.white,
          thumbColor:
              _controller.gallonUpSwitchValue() ? Colors.white : Colors.grey,
        ),
      );
}
