part of sl_widget_module;

class SingleFunctionDialog extends StatelessWidget {
  final String dialogTitle;
  final String buttonTitle;
  final VoidCallback onButtonTap;
  final VoidCallback onCancelTap;

  const SingleFunctionDialog({
    required this.dialogTitle,
    required this.buttonTitle,
    required this.onButtonTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: DrivenRectangleBorder.mediumRounded,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: SLInternalText.minLocationEnableDialogHeight,
        ),
        child: DrivenColumn(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            padding: const EdgeInsets.all(16),
            children: [
              _dialogTitle(),
              DialogButton(
                onPressed: onButtonTap,
                text: buttonTitle,
                height: 48,
              ),
              CancelText(
                onCancelTap: onCancelTap,
              ),
            ]),
      ),
    );
  }

  Widget _dialogTitle() => Text(
        dialogTitle,
        textAlign: TextAlign.center,
        style: f16RegularBlack,
      );
}
