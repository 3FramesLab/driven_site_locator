part of sl_widget_module;

class SLCancelText extends StatelessWidget {
  final VoidCallback onCancelTap;
  const SLCancelText({required this.onCancelTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: SLSemanticStrings.noLocationsModalCancelButton,
      child: GestureDetector(
        onTap: onCancelTap,
        child: _cancelText(),
      ),
    );
  }

  Text _cancelText() {
    return const Text(
      SLViewText.cancel,
      style: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.black,
          fontSize: 16,
          fontFamily: DrivenFonts.avertaFontFamily,
          fontWeight: DrivenFonts.fontWeightSemibold),
    );
  }
}
