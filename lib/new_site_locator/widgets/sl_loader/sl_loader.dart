part of sl_widget_module;

class SlLoader extends StatelessWidget {
  final bool showLoader;

  const SlLoader({
    required this.showLoader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return showLoader
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent.withOpacity(0.1),
            child: const Center(
              child: CircularProgressIndicator(
                color: DrivenColors.primary,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
