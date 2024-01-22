part of filter_module;

class FuelBrandSearchField extends StatefulWidget {
  const FuelBrandSearchField({super.key});

  @override
  State<FuelBrandSearchField> createState() => _FuelBrandSearchFieldState();
}

class _FuelBrandSearchFieldState extends State<FuelBrandSearchField> {
  final EnhancedFilterController _filterController = Get.find();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (onFocus) {
        if (!onFocus) {
          SiteLocatorUtils.hideKeyboard();
        }
      },
      child: TextField(
        scrollPadding: const EdgeInsets.only(bottom: 250),
        textInputAction: TextInputAction.search,
        controller: _filterController.fuelBrandTextController,
        focusNode: _focusNode,
        onChanged: _filterController.onFuelBrandSearchTextChanged,
        onSubmitted: (_) => SiteLocatorUtils.hideKeyboard(),
        cursorColor: const Color.fromARGB(1, 60, 60, 60),
        cursorWidth: 1.2,
        decoration: _searchTextFieldDecoration,
      ),
    );
  }

  void _onClearClick() {
    _filterController.onFuelBrandClearSearchClick();
  }

  Widget get _searchTextfieldIcon => const Icon(
        Icons.clear,
        size: SiteLocatorDimensions.dp24,
        color: DrivenColors.white,
      );

  Widget get _searchTextFieldIconContainer =>
      SiteLocatorTextFieldStyle().searchTextFieldIconContainer(
        color: DrivenColors.black,
        child: _searchTextfieldIcon,
      );

  InputDecoration get _searchTextFieldDecoration =>
      SiteLocatorTextFieldStyle().searchTextFieldDecoration(
        suffixIcon: _searchTextFieldSuffixIcon(),
        hintText: EnhancedFilterConstants.search,
      );

  Widget _searchTextFieldSuffixIcon() => Obx(
        () => _filterController.isFuelBrandSearchTextEmpty()
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
                child: Semantics(
                  container: true,
                  label: SemanticStrings.clearIconButton,
                  child: GestureDetector(
                    onTap: _onClearClick,
                    child: _searchTextFieldIconContainer,
                  ),
                ),
              ),
      );
}
